-- Added for render-markdown.nvim, which needs treesitter to parse markdown.
-- Scoped to markdown only for now -- not enabling treesitter highlighting
-- globally, since every other filetype currently relies on legacy syntax
-- highlighting and the custom groups in plugins/catppuccin.lua.
return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  lazy = false,
  build = ':TSUpdate',
  config = function()
    require('nvim-treesitter').install { 'markdown', 'markdown_inline' }

    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'markdown' },
      callback = function() vim.treesitter.start() end,
    })
  end,
}
