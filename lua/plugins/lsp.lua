return {
  'neovim/nvim-lspconfig',
  dependencies = {
    { 'mason-org/mason.nvim', opts = {} },
    'mason-org/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    { 'j-hui/fidget.nvim',    opts = {} },
  },
  config = function()
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('user-lsp-attach', { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc, mode)
          vim.keymap.set(mode or 'n', keys, func,
            { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        -- Standard LSP Keymaps
        map('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
        map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
        map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client:supports_method('textDocument/documentHighlight', event.buf) then
          local highlight_augroup = vim.api.nvim_create_augroup('user-lsp-highlight', { clear = false })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })
          vim.api.nvim_create_autocmd('LspDetach', {
            group = vim.api.nvim_create_augroup('user-lsp-detach', { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = 'user-lsp-highlight', buffer = event2.buf }
            end,
          })
        end

        if client and client:supports_method('textDocument/inlayHint', event.buf) then
          map('<leader>th',
            function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }) end,
            '[T]oggle Inlay [H]ints')
        end
      end,
    })

    -- Create new capabilities with nvim cmp, and then broadcast that to the servers.
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

    local servers = {
      texlab = {},
      basedpyright = {
        on_new_config = function(new_config, _)
          if vim.env.VIRTUAL_ENV then
            new_config.settings.python = new_config.settings.python or {}
            new_config.settings.python.pythonPath = vim.env.VIRTUAL_ENV .. '/bin/python'
          end
        end,
        settings = {
          basedpyright = {
            analysis = {
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = 'openFilesOnly',
              typeCheckingMode = 'basic',
              diagnosticSeverityOverrides = {
                reportPrivateImportUsage = false,
                reportUnknownMemberType = false,
              },
            }
          },
        },
      },
      ruff = {},
      marksman = {},
      -- stylua has been completely evicted from the servers table!
      lua_ls = {
        settings = {
          Lua = {
            -- 1. Tell the LSP that 'vim' magically exists
            diagnostics = {
              globals = { 'vim' },
            },
            workspace = {
              checkThirdParty = false,
              -- 2. Point the LSP to Neovim's internal runtime files for autocomplete
              library = vim.api.nvim_get_runtime_file('', true),
            },
            telemetry = { enable = false },
          }
        },
      },
    }

    if vim.fn.has 'mac' == 1 then servers.clangd = {} end

    local ensure_installed = vim.tbl_keys(servers or {})
    -- Add all your non-LSP tools (formatters, linters) here
    vim.list_extend(ensure_installed, {
      'markdownlint',
      'clang-format',
      'latexindent',
      'ruff',
      'stylua',
    })

    require('mason-tool-installer').setup { ensure_installed = ensure_installed }

    for name, server in pairs(servers) do
      server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})

      -- NATIVE NEOVIM API (No more deprecation warnings)
      vim.lsp.config(name, server)
      vim.lsp.enable(name)
    end

    -- LINUX FALLBACK WITH NATIVE API
    if vim.fn.has('mac') == 0 then
      vim.lsp.config('clangd', { capabilities = capabilities })
      vim.lsp.enable('clangd')
    end
  end,
}
