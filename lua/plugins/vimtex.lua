return {
  'lervag/vimtex',
  lazy = false,
  init = function()
    vim.g.vimtex_compiler_method = 'latexmk'
    vim.g.vimtex_quickfix_open_on_warning = 1
    vim.g.vimtex_quickfix_mode = 2

    vim.g.vimtex_compiler_latexmk = {
      out_dir = 'out',
      continuous = 0,
      options = {
        '-pdf',
        '-shell-escape',
        '-verbose',
        '-file-line-error',
        '-synctex=1',
        '-interaction=nonstopmode',
      },
    }

    -- 2. Tell VimTeX to route RPC SyncTeX calls to Skim
    vim.g.vimtex_view_method = 'skim'
  end,
  config = function()
    -- 3. Change this from Single Shot (SS) to the continuous daemon toggle
    vim.keymap.set('n', '<leader>lc', '<cmd>VimtexCompileSS<CR>', { desc = '[L]aTeX [C]ompile (Single Shot)' })

    -- 4. Add a keymap for Forward Search (jump PDF to cursor)
    vim.keymap.set('n', '<leader>lv', '<cmd>VimtexView<CR>', { desc = '[L]aTeX [V]iew (Forward Search)' })

    vim.keymap.set('n', '<leader>lo', '<cmd>VimtexCompileOutput<CR>', { desc = '[L]aTeX [O]utput (Raw Log)' })
    vim.keymap.set('n', '<leader>le', '<cmd>VimtexErrors<CR>', { desc = '[L]aTeX [E]rrors' })
  end,
}

