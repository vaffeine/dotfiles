return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.8",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		require("telescope").setup()

		vim.api.nvim_create_user_command("Rg", function()
			require('telescope.builtin').grep_string({
				shorten_path = true,
				word_match = "-w",
				only_sort_text = true,
				search = '',
			})
		end, { desc = "Fuzzy search any text", nargs = 0 })

		vim.api.nvim_create_user_command("Files", function()
			require('telescope.builtin').find_files()
		end, { desc = "Fuzzy search files list", nargs = 0 })

		vim.api.nvim_create_user_command("Symbols", function()
			require('telescope.builtin').lsp_document_symbols()
		end, { desc = "Fuzzy search symbols in the current buffer", nargs = 0 })

		vim.api.nvim_create_user_command("Diagnostics", function()
			require('telescope.builtin').diagnostics()
		end, { desc = "Fuzzy search symbols in the current buffer", nargs = 0 })

		vim.keymap.set('n', 'gr',
			function() require('telescope.builtin').lsp_references() end,
			{ noremap = true, silent = true })
	end,
}
