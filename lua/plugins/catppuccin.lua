return {
  'catppuccin/nvim',
  name = 'catppuccin',
  priority = 1000,
  opts = {
    flavour = 'latte', -- latte, frappe, macchiato, mocha
  },
  -- Disabled during the grayscale (base16.lua) trial.
  -- Re-enable by restoring: init = function() vim.cmd.colorscheme 'catppuccin' end,
}
