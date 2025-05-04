return {
	{
		"williamboman/mason.nvim",
		lazy = false,
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		ensure_installed = {
			"lua_ls",
		},
		opts = {
			auto_install = true,
		},
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local lspconfig = require("lspconfig")
			lspconfig.gopls.setup({
				settings = {
					gopls = {
						analyses = {
							unusedparams = true,
						},
						staticcheck = true,
						gofumpt = true,
					},
				},
			})
			lspconfig.clangd.setup({
				root_dir = function(fname)
					local util = require('lspconfig.util')
					return util.root_pattern(
						'.clangd',
						'.clang-tidy',
						'.clang-format',
						'compile_commands.json',
						'compile_flags.txt',
						'configure.ac' -- AutoTools
					)(fname)
				end,
			})
			lspconfig.rust_analyzer.setup({
				settings = {
					["rust-analyzer"] = {
						imports = {
							granularity = {
								group = "module",
							},
							prefix = "self",
						},
						cargo = {
							buildScripts = {
								enable = true,
							},
						},
						procMacro = {
							enable = true
						},
					}
				}
			})
			-- Workaround for https://github.com/neovim/neovim/issues/30985
			for _, method in ipairs({ 'textDocument/diagnostic', 'workspace/diagnostic' }) do
				local default_diagnostic_handler = vim.lsp.handlers[method]
				vim.lsp.handlers[method] = function(err, result, context, config)
					if err ~= nil and err.code == -32802 then
						return
					end
					return default_diagnostic_handler(err, result, context, config)
				end
			end
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
				settings = {
					Lua = {
						runtime = {
							version = "LuaJIT",
						},
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							checkThirdParty = false,
							library = {
								vim.env.VIMRUNTIME,
							},
						},
						telemetry = {
							enable = false,
						},
						hint = {
							enable = true,
						},
					},
				},
			})
			lspconfig.pyright.setup({
				capabilities = capabilities,
				settings = {
					python = {
						analysis = {
							diagnosticSeverityOverrides = {
								reportUnusedExpression = "none",
							},
						},
					},
				},
			})

			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, {})
			vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {})
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
			vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, {})
			vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action, {})

			-- Errors
			vim.keymap.set("n", "<leader>dl", "<cmd>Telescope diagnostics<cr>", {})
			vim.keymap.set("n", "<C-n>", function() vim.diagnostic.jump({ count = 1, float = true }) end, {})
			vim.keymap.set("n", "<C-m>", function() vim.diagnostic.jump({ count = -1, float = true }) end, {})

			-- Automatically format on write
			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = { "*.lua", "*.rs", "*.go" },
				callback = function() vim.lsp.buf.format() end,
				group = vim.api.nvim_create_augroup("lsp_document_format", { clear = true })
			})

			-- Disable ugly semantic highlighting
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if client ~= nil then
						client.server_capabilities.semanticTokensProvider = nil
					end
				end,
			});
		end,
	},
}
