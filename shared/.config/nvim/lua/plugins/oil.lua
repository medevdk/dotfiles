return {
	"stevearc/oil.nvim",
	-- Load at startup so Oil can replace netrw as the default file explorer
	lazy = false,
	keys = {
		{ "-", "<CMD>Oil --float<CR>", desc = "Open Oil in float" },
	},
	opts = {
		float = {
			padding = 2,
			max_width = 80,
			max_height = 20,
			border = "rounded",
			win_options = {
				winblend = 0,
			},
		},
		confirmation = {
			border = "rounded",
			min_width = 40,
			max_width = 40,
		},
		keymaps = {
			["q"] = "actions.close",
			["<ESC>"] = "actions.close",
			["<C-r>"] = "actions.refresh", -- Refresh the file list if something changed externally
		},
		view_options = {
			show_hidden = true,
			is_hidden_file = function(name, bufnr)
				return vim.startswith(name, ".")
			end,
			is_always_hidden = function(name, bufnr)
				return name:match("_templ%.go$") ~= nil
			end,
		},

		--Delete to trashbin
		delete_to_trash = true,
		trash_command = "trash",
		default_file_explorer = true,
	},
}
