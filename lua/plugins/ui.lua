return {
  { 'NMAC427/guess-indent.nvim', opts = {} },
  {
    'folke/tokyonight.nvim',
    priority = 1000,
    opts = { styles = { comments = { italic = false } } },
  },
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = { add = { text = '+' }, change = { text = '~' }, delete = { text = '-' }, topdelete = { text = '‾' }, changedelete = { text = '~' } },
    },
  },
  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    opts = {
      delay = 0,
      icons = { mappings = vim.g.have_nerd_font },
      spec = {
        { '<leader>s', group = '[S]earch', mode = { 'n', 'v' } },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
        { 'gr', group = 'LSP Actions', mode = { 'n' } },
        { '<leader>l', group = '[L]aTeX', mode = { 'n', 'v' } },
      },
    },
  },
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },
  {
    'nvim-mini/mini.nvim',
    config = function()
      require('mini.ai').setup { n_lines = 500 }
      require('mini.surround').setup()
      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function() return '%2l:%-2v' end
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_filename = function()
        local filename = vim.fn.expand '%:~:.'
        if filename == '' then filename = '[No Name]' end
        local unsaved = vim.bo.modified and ' [UNSAVED]' or ''
        local readonly = vim.bo.readonly and ' [RO]' or ''
        return filename .. readonly .. unsaved
      end
    end,
  },
}
