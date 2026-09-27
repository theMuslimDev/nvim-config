-- base16 "Grayscale Dark" (Alexandre Gavioli) -- one-month grayscale trial.
-- Re-enable catppuccin.lua's `init` line to revert.
return {
  'RRethy/base16-nvim',
  lazy = false,
  priority = 1000,
  config = function()
    local colors = {
      base00 = '#101010',
      base01 = '#252525',
      base02 = '#464646',
      base03 = '#525252',
      base04 = '#ababab',
      base05 = '#b9b9b9',
      base06 = '#e3e3e3',
      base07 = '#f7f7f7',
      base08 = '#7c7c7c',
      base09 = '#999999',
      base0A = '#a0a0a0',
      base0B = '#8e8e8e',
      base0C = '#868686',
      base0D = '#686868',
      base0E = '#747474',
      base0F = '#5e5e5e',
    }

    require('base16-colorscheme').setup(colors)

    -- Grayscale can't lean on hue to tell token types apart, so restate
    -- syntax roles with weight/style instead of color.
    local styled = {
      Comment = { fg = colors.base03, italic = true },

      Keyword = { fg = colors.base0E, bold = true },
      Conditional = { fg = colors.base0E, bold = true },
      Repeat = { fg = colors.base0E, bold = true },
      Statement = { fg = colors.base0E, bold = true },
      Label = { fg = colors.base0E, bold = true },
      Exception = { fg = colors.base0E, bold = true },

      String = { fg = colors.base0B },

      Function = { fg = colors.base0D, underline = true },
    }

    for group, style in pairs(styled) do
      vim.api.nvim_set_hl(0, group, style)
    end

    -- Bridge treesitter/semantic-token captures onto the same styled groups
    -- (harmless even without a treesitter parser installed).
    local links = {
      ['@comment'] = 'Comment',
      ['@keyword'] = 'Keyword',
      ['@keyword.function'] = 'Keyword',
      ['@keyword.return'] = 'Keyword',
      ['@conditional'] = 'Conditional',
      ['@repeat'] = 'Repeat',
      ['@string'] = 'String',
      ['@function'] = 'Function',
      ['@function.call'] = 'Function',
      ['@function.builtin'] = 'Function',
    }

    for from, to in pairs(links) do
      vim.api.nvim_set_hl(0, from, { link = to })
    end

    -- Distinguish diagnostic severities by underline style since color
    -- alone won't do it in grayscale (icons are configured in autocmds.lua).
    vim.api.nvim_set_hl(0, 'DiagnosticUnderlineError', { sp = colors.base08, undercurl = true })
    vim.api.nvim_set_hl(0, 'DiagnosticUnderlineWarn', { sp = colors.base0A, underline = true })
  end,
}
