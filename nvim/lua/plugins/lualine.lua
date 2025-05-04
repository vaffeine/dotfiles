return {
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = {
					theme = "ayu",
					disabled_filetypes = { "alpha", "neo-tree" },
				},
			})
		end,
	},
}
