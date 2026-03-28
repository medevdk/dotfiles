return {
	"norcalli/nvim-colorizer.lua",

	config = function()
		require("colorizer").setup({
			css = { rgb_fn = true },
			scss = { rgb_fn = true },
			sass = { rgb_fn = true },
			stylus = { rgb_fn = true },
			vim = { names = false },
			"javascript",
			html = {
				mode = "foreground",
			},
		})
	end,
}
