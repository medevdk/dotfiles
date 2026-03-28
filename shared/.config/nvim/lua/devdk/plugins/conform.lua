return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")
		conform.setup({
			formatters_by_ft = {
				javascript = { "prettier" },
				css = { "prettier" },
				html = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },
				lua = { "stylua" },
				go = { "goimports", "gofumpt" },
				templ = { "templ" },
			},
			format_on_save = function(bufnr)
				if vim.api.nvim_buf_get_name(bufnr):match("cheatsheet%.txt$") then
					return nil
				end
				return { lsp_format = "fallback", async = false, timeout_ms = 2000 }
			end,
		}) -- <-- this closes conform.setup()
		vim.keymap.set({ "n", "v" }, "<leader>fp", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 500,
			})
		end, { desc = "Format file or range (in visual mode)" })
	end,
}
