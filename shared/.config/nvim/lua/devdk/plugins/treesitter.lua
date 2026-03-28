return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		dependencies = { "windwp/nvim-ts-autotag" },
		event = { "BufReadPre", "BufNewFile" },
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)

			--Setup autotag independently (fix deprication warning)
			require("nvim-ts-autotag").setup()

			-- Register the templ filetype
			vim.treesitter.language.register("templ", "templ")
		end,
		opts = {
			ensure_installed = {
				"lua",
				"vim",
				"markdown",
				"markdown_inline",
				"json",
				"html",
				"css",
				"vimdoc",
				"go",
				"templ",
				"html",
				"gomod",
				"gowork",
				"gosum",
				"sql",
				"c",
				"cpp",
				"regex",
			},
			sync_install = false,
			highlight = { enable = true },
			indent = { enable = true },
			autopairs = { enable = true },
			context_commentstring = {
				enable = true,
				enable_autocmd = false,
			},
		},
	},
}
