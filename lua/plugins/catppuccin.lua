-- Catppuccin Frappe. Frappe's default red sits too close in lightness to the
-- warning peach and body text to read as an error at a glance, so it's
-- overridden below with a more saturated red, used only for diagnostics
-- (rest of the palette is untouched).
local MODE = 'dark' -- 'dark' (frappe) | 'light' (latte)

return {
  'catppuccin/nvim',
  name = 'catppuccin',
  priority = 1000,
  lazy = false,
  config = function()
    require('catppuccin').setup {
      background = { light = 'latte', dark = 'frappe' },
      lsp_styles = {
        underlines = {
          errors = { 'undercurl' },
          warnings = { 'undercurl' },
          hints = { 'underdotted' },
          information = { 'underdashed' },
        },
      },
      custom_highlights = function(colors)
        local err = '#ff5f6d' -- punchier red, tweak to taste
        return {
          DiagnosticError = { fg = err },
          DiagnosticSignError = { fg = err },
          DiagnosticUnderlineError = { sp = err, undercurl = true },
          DiagnosticVirtualTextError = { fg = err, bg = colors.mantle, bold = true },
          DiagnosticWarn = { fg = colors.yellow },
          DiagnosticVirtualTextWarn = { fg = colors.yellow, bg = colors.mantle },
        }
      end,
    }

    vim.o.background = MODE
    vim.cmd.colorscheme 'catppuccin'
  end,
}
