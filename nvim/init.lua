vim.opt.background = "dark"
vim.wo.number = true
vim.o.cursorline = true
vim.opt.termguicolors = true
vim.opt.relativenumber = true
vim.opt.smartindent = true
vim.opt.undofile = true
vim.g.mapleader = " "

-- Use Ctrl-[h, j, k, l] to move between splits
vim.keymap.set("n", [[<C-h>]], [[<C-\><C-n><C-w>h]])
vim.keymap.set("n", [[<C-j>]], [[<C-\><C-n><C-w>j]])
vim.keymap.set("n", [[<C-k>]], [[<C-\><C-n><C-w>k]])
vim.keymap.set("n", [[<C-l>]], [[<C-\><C-n><C-w>l]])

-- Remember cursor positions on buffers
vim.api.nvim_create_autocmd("BufReadPost", {
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local lcount = vim.api.nvim_buf_line_count(0)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})
vim.api.nvim_set_hl(0, "SignColumn", { ctermbg = Black, bg = LightGrey })
vim.api.nvim_set_hl(0, "Cursor", { ctermbg = Black, ctermfg = White })

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out,                            "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	spec = {
		{ import = "plugins" },
	},
	checker = { enabled = true },
})
