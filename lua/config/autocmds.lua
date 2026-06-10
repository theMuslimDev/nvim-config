local autocmd = vim.api.nvim_create_autocmd
local augroup = function(name) return vim.api.nvim_create_augroup('user_' .. name, { clear = true }) end

autocmd('FileType', {
  pattern = { 'tex', 'latex', 'markdown' },
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = 'en_gb'
  end,
})

autocmd('FileType', {
  group = augroup 'markdown_settings',
  pattern = 'markdown',
  callback = function()
    vim.opt_local.textwidth = 80
    vim.opt_local.formatoptions:append 't'
    vim.opt_local.colorcolumn = '80'
  end,
  
})


autocmd('BufWinEnter', {
  group = augroup 'latex_settings',
  pattern = '*.tex',
  callback = function()
    vim.opt_local.textwidth = 80
    vim.opt_local.formatoptions:append 't'
    vim.opt_local.colorcolumn = '100'
  end,
})

autocmd('BufWinEnter', {
  group = augroup 'c_settings',
  pattern = { '*.c', '*.cpp', '*.h' },
  callback = function() vim.opt_local.colorcolumn = '80' end,
})

vim.opt_local.colorcolumn = '100'

local rel_num_group = augroup 'relative_numbers'
autocmd('InsertEnter', {
  group = rel_num_group,
  callback = function() vim.opt.relativenumber = false end,
})
autocmd('InsertLeave', {
  group = rel_num_group,
  callback = function() vim.opt.relativenumber = true end,
})

autocmd('TextYankPost', {
  group = augroup 'highlight_yank',
  callback = function() vim.hl.on_yank() end,
})

-- Strip trailing whitespace on save
vim.api.nvim_create_autocmd('BufWritePre', {
  group = vim.api.nvim_create_augroup('user_trim_whitespace', { clear = true }),
  pattern = '*',
  callback = function()
    -- Save the current cursor position
    local curpos = vim.api.nvim_win_get_cursor(0)
    -- Search and replace trailing whitespace (keeppatterns prevents cluttering search history)
    vim.cmd [[keeppatterns %s/\s\+$//e]]
    -- Restore the cursor position so it doesn't jump to the top of the file
    vim.api.nvim_win_set_cursor(0, curpos)
  end,
  desc = 'Strip trailing whitespace on save',
})

-- Diagnostic Config
vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },
  virtual_text = true,
  virtual_lines = false,
  jump = { float = true },
}
