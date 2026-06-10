return {
	'stevearc/oil.nvim',
	dependencies = { 'nvim-tree/nvim-web-devicons' },
	config = function()
		require('oil').setup({
			-- We keep the default view clean, but allow visibility into hidden files
			-- so you can manage your .gitignore and .latexmkrc
			view_options = {
				show_hidden = true,
			},
			-- This ensures that when you edit a file name in the buffer,
			-- the change is written to disk instantly upon saving (:w)
			cleanup_delay_ms = false,
		})

		-- The boundary crosser: Map '-' to open the parent directory of the current buffer
		vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
	end,
}
