return {
	{
		"nmac427/guess-indent.nvim",
		config = function() require("guess-indent").setup() end,
	},
	{
		"norcalli/nvim-colorizer.lua",
		config = function()
			require('colorizer').setup()
		end,
	},
	{
		"Shatur/neovim-ayu",
		lazy = false,
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			require("ayu").setup({
				terminal = true,
				overrides = {
					Normal = { bg = "None" },
					NormalFloat = { bg = "none" },
					ColorColumn = { bg = "None" },
					SignColumn = { bg = "None" },
					Folded = { bg = "None" },
					FoldColumn = { bg = "None" },
					CursorLine = { bg = "None" },
					CursorColumn = { bg = "None" },
					VertSplit = { bg = "None" },
				},
			})
			vim.cmd("colorscheme ayu")
		end,
	},
	{
		"mfussenegger/nvim-dap",
		config = function()
			local dap = require("dap")
			dap.adapters.gdb = {
				type = "executable",
				command = "gdb",
				args = { "--interpreter=dap", "--eval-command", "set print pretty on" }
			}
		end,
	},
}
