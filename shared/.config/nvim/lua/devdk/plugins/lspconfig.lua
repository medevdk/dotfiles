---@diagnostic disable: trailing-space
return {
	{
		"williamboman/mason.nvim",
		lazy = false,
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "gopls", "marksman", "templ", "htmx", "tailwindcss" },
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{ "saghen/blink.cmp" },
			-- "hrsh7th/cmp-nvim-lsp",
			{ "antosha417/nvim-lsp-file-operations", config = true },
			{ "folke/neodev.nvim", opts = {} },
			{ "j-hui/fidget.nvim", opts = {} },
		},

		config = function()
			local capabilities = require("blink.cmp").get_lsp_capabilities()
			-- capabilities.textDocument.completion.completionItem.snippetSupport = true

			local util = require("lspconfig.util")

			vim.lsp.config("lua_ls", {
				capabilities = capabilities,
				cmd = { "lua-language-server" },
				filetypes = { "lua" },
				root_markers = { ".luarc.json", ".luarc.jsonc" },

				settings = {
					Lua = {
						runtime = {
							version = "LuaJIT",
						},
					},
				},
			})
			vim.lsp.enable("lua_ls")

			vim.lsp.config("html", {
				capabilities = capabilities,
				cmd = { "vscode-html-language-server", "--stdio" },
				filetypes = { "html" },
				init_options = {
					configurationSection = { "html", "css", "javascript", "typescript" },
					embeddedLanguages = {
						css = true,
						javascript = true,
					},
					provideFormatter = true,
				},
				settings = {},
				single_file_support = true,
			})
			vim.lsp.enable("html")

			-- lspconfig.cssls.setup({
			vim.lsp.config("cssls", {
				capabilities = capabilities,
				cmd = { "vscode-css-language-server", "--stdio" },
				filetypes = { "css", "scss", "less" },
				-- root_dir = function(fname)
				-- 	return root_pattern(fname) or vim.loop.os_homedir()
				-- end,
				settings = {
					css = {
						validate = true,
					},
					less = {
						validate = true,
					},
					scss = {
						validate = true,
					},
				},
			})
			vim.lsp.enable("cssls")

			vim.lsp.config("jsonls", {
				capabilities = capabilities,
				cmd = { "vscode-json-language-server", "--stdio" },
			})
			vim.lsp.enable("jsonls")

			vim.lsp.config("marksman", {})
			vim.lsp.enable("marksman")

			vim.lsp.config("templ", {
				capabilities = capabilities,
				filetypes = { "templ" },
			})
			vim.lsp.enable("templ")

			vim.lsp.config("tailwindcss", {
				capabilities = capabilities,
				filetypes = { "html", "templ", "javascript", "typescript", "react" },
				init_options = {
					userLanguages = {
						templ = "html",
					},
				},
			})
			vim.lsp.enable("tailwindcss")

			vim.lsp.config("gopls", {
				cmd = { "gopls" },
				capabilities = capabilities,
				filetypes = { "go", "gomod", "gowork", "gotmpl" },
				root_dir = util.root_pattern("go.mod", ".git"),
				settings = {
					gopls = {
						gofumpt = true,
						experimentalPostfixCompletions = true,
						analyses = {
							nilness = true,
							unusedwrite = true,
							useany = true,
							unusedparams = true,
							shadow = true,
						},
						hints = {
							assignVariableTypes = true,
							compositeLiteralFields = true,
							compositeLiteralTypes = true,
							constantValues = true,
							functionTypeParameters = true,
							parameterNames = true,
							rangeVariableTypes = true,
						},
						usePlaceholders = true,
						completeUnimported = true,
						staticcheck = true,
						semanticTokens = true,
					},
				},
			})
			vim.lsp.enable("gopls")

			vim.lsp.config("htmx", {
				capabilities = capabilities,
				filetypes = { "html", "templ" },
			})
			vim.lsp.enable("htmx")

			--Do not show diagnostics in generated templ files
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					-- Fix: Ensure we use args.buf which is the integer buffer ID
					local bufnr = args.buf
					if not bufnr then
						return
					end

					local curr_filepath = vim.api.nvim_buf_get_name(bufnr)

					-- Check if it's a generated templ file
					if curr_filepath:match("_templ%.go$") then
						vim.diagnostic.enable(false, { bufnr = bufnr })
					end
				end,
			})

			-- Toggle the Quickfix window
			vim.keymap.set("n", "<leader>xl", "<cmd>copen<cr>", { desc = "Open Quickfix List" })
			vim.keymap.set("n", "<leader>xc", "<cmd>cclose<cr>", { desc = "Close Quickfix List" })

			-- Navigate through errors quickly
			vim.keymap.set("n", "[q", "<cmd>cprev<cr>", { desc = "Previous Quickfix Item" })
			vim.keymap.set("n", "]q", "<cmd>cnext<cr>", { desc = "Next Quickfix Item" })

			-- Send all current diagnostics to the Quickfix list
			vim.keymap.set("n", "<leader>xd", function()
				vim.diagnostic.setqflist()
			end, { desc = "Send Diagnostics to Quickfix" })

			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
		end,
	},
}
