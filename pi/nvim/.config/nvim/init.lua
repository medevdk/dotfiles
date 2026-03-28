-- Pi Neovim Config - Minimal
-- lazy.nvim bootstrap
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Options
local opt = vim.opt
opt.termguicolors = true
opt.number = true
opt.relativenumber = true
opt.expandtab = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.smartindent = true
opt.cursorline = true
opt.wrap = false
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false
opt.undofile = true
opt.clipboard:append("unnamedplus")
opt.scrolloff = 8
opt.splitright = true
opt.splitbelow = true
opt.signcolumn = "yes"

-- Leader key
vim.g.mapleader = " "

-- Keymaps
local map = vim.keymap.set

-- General
map("i", "jk", "<Esc>")
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- Oil
map("n", "<leader>-", "<CMD>Oil<CR>")

-- LSP
map("n", "gd", vim.lsp.buf.definition)
map("n", "gr", vim.lsp.buf.references)
map("n", "K", vim.lsp.buf.hover)
map("n", "<leader>ca", vim.lsp.buf.code_action)
map("n", "<leader>rn", vim.lsp.buf.rename)
map("n", "<leader>d", vim.diagnostic.open_float)
map("n", "[d", vim.diagnostic.goto_prev)
map("n", "]d", vim.diagnostic.goto_next)

-- fzf
map("n", "<leader>ff", "<CMD>FzfLua files<CR>")
map("n", "<leader>fg", "<CMD>FzfLua live_grep<CR>")

-- Plugins
require("lazy").setup({

  -- File explorer
  {
    "stevearc/oil.nvim",
    config = function()
      require("oil").setup()
    end,
  },

  -- Mini plugins
  {
    "echasnovski/mini.nvim",
    config = function()
      require("mini.ai").setup()
      require("mini.surround").setup()
      require("mini.statusline").setup()
    end,
  },

  -- Fuzzy finder
  {
    "ibhagwan/fzf-lua",
    config = function()
      require("fzf-lua").setup()
    end,
  },

  -- Completion
  {
    "saghen/blink.cmp",
    version = "1.*",
    opts = {
      keymap = { preset = "default" },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
        modes = {
          cmdLine = { enabled = false},
      },
    },
  },

  -- LSP
-- LSP
  {
    "neovim/nvim-lspconfig",
    config = function()
      -- Go
      vim.lsp.enable("gopls")

      -- Lua
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
          },
        },
      })
      vim.lsp.enable("lua_ls")

      -- Bash (custom local install)
      vim.lsp.config("bashls", {
        cmd = { vim.fn.expand("~/bash-lsp/node_modules/.bin/bash-language-server"), "start" },
      })
      vim.lsp.enable("bashls")
    end,
  },
})
