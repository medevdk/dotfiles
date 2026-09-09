return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		notifier = { enabled = true },
		lazygit = { enabled = true },
		dashboard = { enabled = false },
		-- vim.ui.input replacement (was dressing.nvim);
		-- vim.ui.select is handled by telescope-ui-select
		input = { enabled = true },
	},
	keys = {
		{
			"<leader>lg",
			function()
				Snacks.lazygit()
			end,
			desc = "Lazygit ",
		},
	},
}
