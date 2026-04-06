opt = vim.opt

opt.termguicolors = true

opt.backspace = "indent,eol,start"

--Line number
opt.number = true --show absolute number
opt.relativenumber = true --add numbers to each line on the left side

--Splits
opt.splitright = true -- vertical split open on the right
opt.splitbelow = true -- horizontal split open below

-- Sign column always show
opt.signcolumn = "yes"

opt.isfname:append("@-@") -- treat @ as part of a filename (useful with Go imports)

--Tab / Indent
opt.expandtab = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.smartindent = true

opt.cursorline = true

--Do not wrap
opt.wrap = false

--Search
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false

-- Persist undo
opt.undofile = true -- Maximum numbers of undo=1000

--Clipboard
opt.clipboard:append("unnamedplus") --use system clipboard as default register

-- Minimum number of lines to keep above and below the cursor
opt.scrolloff = 8

-- Prevents Neovim from automatically trying to find tags when jumping
vim.opt.tagfunc = ""

--Spelling
opt.spelllang = "en_us"

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "markdown", "text", "gitcommit" },
	callback = function()
		vim.opt_local.spell = true
	end,
})

--Highlight on yank
local highlight_group = vim.api.nvim_create_augroup("YankHighLight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch", timeout = 1000 })
	end,
	group = highlight_group,
	pattern = "*",
})
