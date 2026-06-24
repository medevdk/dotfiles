return {
	{
		"kevinhwang91/nvim-ufo",
		dependencies = { "kevinhwang91/promise-async" },
		config = function()
			-- UFO requires these options configured natively
			vim.o.foldcolumn = "1" -- '0' if you don't want a fold indicator column
			vim.o.foldlevel = 99
			vim.o.foldlevelstart = 99
			vim.o.foldenable = true

			-- Customize the gutter icons here
			vim.opt.fillchars = {
				horiz = "━",
				horizup = "┻",
				horizdown = "┳",
				vert = "┃",
				vertleft = "┫",
				vertright = "┣",
				verthoriz = "╋",
				foldopen = "", -- Icon when fold is open
				foldclose = "", -- Icon when fold is closed
				foldsep = " ", -- Eliminates the vertical line down the fold length
				eob = " ", -- Cleans up tildes at end of buffer
			}

			-- Tell UFO to use Tree-sitter as the main provider
			require("ufo").setup({
				provider_selector = function(bufnr, filetype, buftype)
					return { "treesitter", "indent" }
				end,
			})
		end,
	},
}
