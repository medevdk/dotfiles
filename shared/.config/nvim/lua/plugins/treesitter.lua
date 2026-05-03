return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    dependencies = { "windwp/nvim-ts-autotag" },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      -- Override Homebrew bundled parsers
      vim.opt.runtimepath:prepend(vim.fn.stdpath("data") .. "/treesitter")

      require("nvim-treesitter").setup({
        parser_install_dir = vim.fn.stdpath("data") .. "/treesitter",
        ensure_installed = {
          "lua", "vim", "markdown", "markdown_inline",
          "json", "css", "vimdoc", "go", "templ", "html",
          "gomod", "gowork", "gosum", "sql", "c", "cpp",
          "regex",
        },
        sync_install = false,
      })

      -- highlight and indent are now on by default in the new API
      -- autopairs and context_commentstring are handled by their own plugins

      require("nvim-ts-autotag").setup({
        opts = {
          enable_close = true,
          enable_rename = true,
          enable_close_on_slash = false,
        },
        per_filetype = {
          ["html"] = { enable_close = false },
          ["markdown"] = {
            enable_close = false,
            enable_rename = false,
            enable_close_on_slash = false,
          },
        },
      })

      vim.treesitter.language.register("templ", "templ")
    end,
  },
}
