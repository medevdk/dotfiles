return {
	"windwp/nvim-ts-autotag",
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	event = "InsertEnter",
	opts = {
		--Defaults
		enable_close = true,
		enable_rename = true,
		enable_close_on_slash = false,
	},
	config = function()
		require("nvim-ts-autotag").setup()
		per_filetype = {
			["html"] = {
				enable_close = false,
			},
		}
	end,
}
