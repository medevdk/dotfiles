return {
  "NvChad/nvim-colorizer.lua",
  config = function()
    require("colorizer").setup({
      filetypes = {
        "css",
        "scss",
        "sass",
        "stylus",
        "javascript",
        "html",
        "vim",
      },
      user_default_options = {
        rgb_fn = true,
        names = false,
      },
      filetypes_overwrites = {
        html = { mode = "foreground" },
        vim = { names = false },
      },
    })
  end,
}
