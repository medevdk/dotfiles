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
			{ "folke/lazydev.nvim", opts = {} },
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

			-- 1. Global Diagnostic & Quickfix Keys (These work always)
			-- Toggle the Quickfix window
			vim.keymap.set("n", "<leader>xl", "<cmd>copen<cr>", { desc = "Open Quickfix List" })
			vim.keymap.set("n", "<leader>xc", "<cmd>cclose<cr>", { desc = "Close Quickfix List" })

			-- Navigate through errors quickly
			vim.keymap.set("n", "[q", ":cprev!<cr>zz", { desc = "Previous Quickfix Item" })
			vim.keymap.set("n", "]q", ":cnext!<cr>zz", { desc = "Next Quickfix Item" })

			-- Send all current diagnostics to the Quickfix list
			vim.keymap.set("n", "<leader>xd", function()
				vim.diagnostic.setqflist()
			end, { desc = "Send Diagnostics to Quickfix" })

			-- 2. LSP-Specific Keys (Only active when a server like gopls is attached)
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					-- Base options: force the mapping to be local to this specific buffer
					local opts = { buffer = ev.buf }

					-- Helper function to keep things readable and "self-documenting"
					local map = function(keys, func, descr)
						vim.keymap.set("n", keys, func, {
							buffer = ev.buf,
							desc = "LSP: " .. descr,
						})
					end

					-- Navigation
					map("gd", vim.lsp.buf.definition, "Goto Definition")
					map("K", vim.lsp.buf.hover, "Hover Documentation")
					-- 2. Telescope-powered LSP functions (The ones that look better)
					local ts = require("telescope.builtin")

					map("gr", ts.lsp_references, "Goto References [Telescope]")
					map("gi", ts.lsp_implementations, "Goto Implementation [Telescope]")
					map("gt", ts.lsp_type_definitions, "Goto Type Definition [Telescope]")
					map("<leader>dd", ts.diagnostics, "Document Diagnostics [Telescope]")

					-- Diagnostic Navigation
					map("[d", vim.diagnostic.goto_prev, "Prev Diagnostic")
					map("]d", vim.diagnostic.goto_next, "Next Diagnostic")
					map("<leader>ee", vim.diagnostic.open_float, "Line Diagnostics")

					map("<leader>ds", function()
						local clients = vim.lsp.get_clients({ bufnr = 0 })
						local client = clients[1]

						-- If we have a client, get its encoding; otherwise default to utf-16
						local offset_encoding = client and client.offset_encoding or "utf-16"

						require("telescope.builtin").lsp_document_symbols({
							offset_encoding = offset_encoding,
							-- This helps with Go function signatures in the Telescope view
							symbol_width = 60,
						})
					end, "Document Symbols")
					-- Actions & Refactoring
					map("<leader>rn", vim.lsp.buf.rename, "Rename Symbol")
					map("<leader>ca", vim.lsp.buf.code_action, "Code Action")

					-- Signature help (useful when typing function arguments)
					vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, {
						buffer = ev.buf,
						desc = "LSP: Signature Help",
					})
				end,
			})
		end,
	},
}
