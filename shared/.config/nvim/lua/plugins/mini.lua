return {
	"echasnovski/mini.nvim",
	version = false,

	config = function()
		-- Add/delete/replace surroundings (brackets, quotes, etc.)
		--
		-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
		-- - sd'   - [S]urround [D]elete [']quotes
		-- - sr)'  - [S]urround [R]eplace [)] [']
		-- Delete surounding with sd
		-- Replace surronding with sr
		-- Find surrounding with sf sF
		-- Highlight surrounding with sh
		require("mini.surround").setup()

		require("mini.pairs").setup()

		require("mini.ai").setup()

		-- require('mini.starter').setup()
	end,
}
