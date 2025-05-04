return {
	{
		"3rd/image.nvim",
		opts = {
			backend = "kitty",
		},
		config = function()
			require("image").setup({
				backend = "kitty",
				max_width = 300,
				max_height = 36,
			})
		end,
	},
	{
		"benlubas/molten-nvim",
		version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
		-- dependencies = { "willothy/wezterm.nvim" },
		dependencies = { "3rd/image.nvim" },
		build = ":UpdateRemotePlugins",
		init = function()
			vim.g.molten_image_provider = "image.nvim"
		end,
		config = function()
			vim.keymap.set("n", "<leader>e", ":MoltenEvaluateLine<CR>",
				{ silent = true, desc = "evaluate line" })
			vim.keymap.set("v", "<leader>e", ":<C-u>MoltenEvaluateVisual<CR>gv",
				{ silent = true, desc = "evaluate visual selection" })
			vim.keymap.set("n", "<leader>os", ":noautocmd MoltenEnterOutput<CR>",
				{ silent = true, desc = "open output window" })
			vim.keymap.set("n", "<leader>oh", ":MoltenHideOutput<CR>",
				{ silent = true, desc = "close output window" })
			vim.keymap.set("n", "<leader>md", ":MoltenDelete<CR>",
				{ silent = true, desc = "delete Molten cell" })

			vim.g.molten_wrap_output = true
			vim.g.molten_virt_text_output = true
			vim.g.molten_image_location = "float"
			vim.g.molten_output_virt_lines = false
			vim.g.molten_virt_lines_off_by_1 = false
			-- not supported by wezterm
			-- vim.g.molten_auto_open_output = false

			-- automatically import output chunks from a jupyter notebook
			-- tries to find a kernel that matches the kernel in the jupyter notebook
			-- falls back to a kernel that matches the name of the active venv (if any)
			local imb = function(e) -- init molten buffer
				vim.schedule(function()
					local kernels = vim.fn.MoltenAvailableKernels()
					local try_kernel_name = function()
						local metadata = vim.json.decode(io.open(e.file, "r"):read("a"))
						    ["metadata"]
						return metadata.kernelspec.name
					end
					local ok, kernel_name = pcall(try_kernel_name)
					if not ok or not vim.tbl_contains(kernels, kernel_name) then
						kernel_name = nil
						local venv = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX")
						if venv ~= nil then
							kernel_name = string.match(venv, "/.+/(.+)")
						end
					end
					if kernel_name ~= nil and vim.tbl_contains(kernels, kernel_name) then
						vim.cmd(("MoltenInit %s"):format(kernel_name))
					end
					vim.cmd("MoltenImportOutput")
				end)
			end

			-- automatically import output chunks from a jupyter notebook
			vim.api.nvim_create_autocmd("BufAdd", {
				pattern = { "*.ipynb" },
				callback = imb,
			})

			-- we have to do this as well so that we catch files opened like nvim ./hi.ipynb
			vim.api.nvim_create_autocmd("BufEnter", {
				pattern = { "*.ipynb" },
				callback = function(e)
					if vim.api.nvim_get_vvar("vim_did_enter") ~= 1 then
						imb(e)
					end
				end,
			})

			-- automatically export output chunks to a jupyter notebook on write
			vim.api.nvim_create_autocmd("BufWritePost", {
				pattern = { "*.ipynb" },
				callback = function()
					if require("molten.status").initialized() == "Molten" then
						vim.cmd("MoltenExportOutput!")
					end
				end,
			})

			-- Provide a command to create a blank new Python notebook
			-- note: the metadata is needed for Jupytext to understand how to parse the notebook.
			-- if you use another language than Python, you should change it in the template.
			local default_notebook = [[
			  {
			    "cells": [
			     {
			      "cell_type": "markdown",
			      "metadata": {},
			      "source": [
				""
			      ]
			     }
			    ],
			    "metadata": {
			     "kernelspec": {
			      "display_name": "Python 3",
			      "language": "python",
			      "name": "python3"
			     },
			     "language_info": {
			      "codemirror_mode": {
				"name": "ipython"
			      },
			      "file_extension": ".py",
			      "mimetype": "text/x-python",
			      "name": "python",
			      "nbconvert_exporter": "python",
			      "pygments_lexer": "ipython3"
			     }
			    },
			    "nbformat": 4,
			    "nbformat_minor": 5
			  }
			]]

			local function new_notebook(filename)
				local path = filename .. ".ipynb"
				local file = io.open(path, "w")
				if file then
					file:write(default_notebook)
					file:close()
					vim.cmd("edit " .. path)
				else
					print("Error: Could not open new notebook file for writing.")
				end
			end

			vim.api.nvim_create_user_command('NewNotebook', function(opts)
				new_notebook(opts.args)
			end, {
				nargs = 1,
				complete = 'file'
			})
		end,
	},
	{
		"quarto-dev/quarto-nvim",
		dependencies = {
			"jmbuhr/otter.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		ft = { "quarto", "markdown" },
		config = function()
			local quarto = require("quarto")
			quarto.setup({
				lspFeatures = {
					languages = { "python" },
					chunks = "all",
					diagnostics = {
						enabled = true,
						triggers = { "BufWritePost" },
					},
					completion = {
						enabled = true,
					},
				},
				keymap = {
					hover = "H",
					definition = "gd",
					references = "gr",
					rename = "<leader>r",
				},
				codeRunner = {
					enabled = true,
					default_method = "molten",
				},
			})
			local runner = require("quarto.runner")
			vim.keymap.set("n", "<leader>rc", runner.run_cell, { desc = "run cell", silent = true })
			vim.keymap.set("n", "<leader>ra", runner.run_above,
				{ desc = "run cell and above", silent = true })
			vim.keymap.set("n", "<leader>rA", runner.run_all, { desc = "run all cells", silent = true })
			vim.keymap.set("n", "<leader>rl", runner.run_line, { desc = "run line", silent = true })
			vim.keymap.set("v", "<leader>r", runner.run_range,
				{ desc = "run visual range", silent = true })
			vim.keymap.set("n", "<leader>RA", function()
				runner.run_all(true)
			end, { desc = "run all cells of all languages", silent = true })
		end
	},
	{
		"GCBallesteros/jupytext.nvim",
		config = function()
			require("jupytext").setup({
				style = "markdown",
				output_extension = "md",
				force_ft = "markdown",
			})
		end
	},
}
