return {
	"NvChad/nvim-colorizer.lua",
	opts = {
		filetypes = {
			"css",
			"scss",
			"sass",
			"stylus",
			"javascript",
			"html",
			"vim",
		},
		user_default_options = {
			rgb_fn = true,
			names = false,
		},
		filetypes_overwrites = {
			html = { mode = "foreground" },
			vim = { names = false },
		},
	},
}
