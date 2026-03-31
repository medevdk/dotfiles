return {
	"ray-x/go.nvim",
	dependencies = {
		"ray-x/guihua.lua",
		"neovim/nvim-lspconfig",
		"nvim-treesitter/nvim-treesitter",
	},
	config = function()
		-- 1. Setup go.nvim (Keep this for the Go-specific tools)
		require("go").setup({
			mappings = false, -- disable go.nvim own keymaps, to avoid hijacking telescope <leader>ff
			lsp_capabilities = require("blink.cmp").get_lsp_capabilities(),
			lsp_cfg = false,
			lsp_gofmt = true,
			goimport = "gopls",
			fillstruct = "gopls",
		})

		-- 2. Manually set up gopls with ONLY the filetypes you want
		vim.lsp.config("gopls", {
			capabilities = require("blink.cmp").get_lsp_capabilities(),
			-- STRICT FILETYPES: Still avoiding 'gotmpl' to fix your RPC errors
			filetypes = { "go", "gomod", "gowork" },
			settings = {
				gopls = {
					gofumpt = true,
					usePlaceholders = true,
					completeUnimported = true,
					staticcheck = true,
					analyses = {
						nilness = true,
						unusedwrite = true,
						unusedparams = true,
						shadow = true,
					},
					hints = {
						assignVariableTypes = true,
						compositeLiteralFields = true,
						parameterNames = true,
						rangeVariableTypes = true,
					},
				},
			},
		})

		-- 3. Enable it!
		vim.lsp.enable("gopls")
		-- Toggle Inlay Hints (The "Intellisense" visual aid)
		vim.keymap.set("n", "<leader>th", function()
			-- Check if the current buffer has an LSP client that supports inlay hints
			local filter = { bufnr = 0 }
			if vim.lsp.inlay_hint.is_enabled(filter) then
				vim.lsp.inlay_hint.enable(false, filter)
			else
				-- Only enable if the buffer is a Go file to avoid gopls metadata errors
				if vim.bo.filetype == "go" then
					vim.lsp.inlay_hint.enable(true, filter)
				else
					print("Inlay hints not supported for this filetype/context")
				end
			end
		end, { desc = "Toggle Inlay Hints" })
		-- Run gofmt + goimports on save
		local format_sync_grp = vim.api.nvim_create_augroup("goimports", {})
		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = "*.go",
			callback = function()
				require("go.format").goimports()
			end,
			group = format_sync_grp,
		})
	end,
	event = { "CmdlineEnter" },
	ft = { "go", "gomod" },
	build = ':lua require("go.install").update_all_sync()',
}
