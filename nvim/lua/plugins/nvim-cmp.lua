return {
	{
		"L3MON4D3/LuaSnip",
		version = "v2.*",
		lazy = false,
		keys = {
			{
				"<C-j>",
				function() require("luasnip").jump(1) end,
				desc = "Jump forward a snippet placement",
				mode = "i",
				noremap = true,
				silent = true
			},
			{
				"<C-k>",
				function() require("luasnip").jump(-1) end,
				desc = "Jump backward a snippet placement",
				mode = "i",
				noremap = true,
				silent = true
			},
		},
		config = function()
			require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/snippets" })
		end,
	},
	{
		"saadparwaiz1/cmp_luasnip",
	},
	{
		"hrsh7th/cmp-nvim-lsp",
	},
	{
		"hrsh7th/cmp-buffer",
	},
	{
		"hrsh7th/nvim-cmp",
		config = function()
			local cmp = require("cmp")
			local mapping = {
				["<C-e>"] = cmp.mapping.abort(),
				["<CR>"] = cmp.mapping({
					i = function(fallback)
						if cmp.visible() and cmp.get_active_entry() then
							cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
						else
							if cmp.visible() then
								cmp.close()
							end
							fallback()
						end
					end,
					s = cmp.mapping.confirm({ select = true }),
				}),
				["<Tab>"] = cmp.mapping(
					function(fallback)
						if cmp.visible() then
							if #cmp.get_entries() == 1 then
								cmp.confirm({ select = true })
							else
								cmp.select_next_item()
							end
						else
							fallback()
						end
					end,
					{ "i", "s" }
				),
				["<S-Tab>"] = cmp.mapping(
					function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						else
							fallback()
						end
					end,
					{ "i", "s" }
				),
			}
			cmp.setup({
				mapping = cmp.mapping.preset.insert(mapping),
				preselect = cmp.PreselectMode.None,
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "buffer" },
					{ name = "luasnip" },
				}, {
					{ name = "buffer" },
				}),
			})

			local cmp_autopairs = require('nvim-autopairs.completion.cmp')
			cmp.event:on(
				'confirm_done',
				cmp_autopairs.on_confirm_done()
			)
		end,
	},
}
