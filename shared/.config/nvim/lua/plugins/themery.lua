return {
  { "folke/tokyonight.nvim" },
  { "catppuccin/nvim" },
  { "rebelot/kanagawa.nvim" },
  { "rose-pine/neovim" },
  { "EdenEast/nightfox.nvim" },
  {
    "zaldih/themery.nvim",
    config = function()
      require("themery").setup({
        themes = {
          { name = "Catppuccin Frappe", colorscheme = "catppuccin-frappe" },
          { name = "TokyoNight Night", colorscheme = "tokyonight-night" },
          { name = "Kanagawa Wave", colorscheme = "kanagawa-wave" },
          { name = "Kanagawa Dragon", colorscheme = "kanagawa-dragon" },
          { name = "Catppuccin Mocha", colorscheme = "catppuccin-mocha" },
          { name = "Rose Pine", colorscheme = "rose-pine-main" },
          { name = "TokyoNight Storm", colorscheme = "tokyonight-storm" },
          { name = "Catppuccin Latte", colorscheme = "catppuccin-latte" },
          { name = "TokyoNight Day", colorscheme = "tokyonight-day" },
          { name = "Kanagawa Lotus", colorscheme = "kanagawa-lotus" },
          {
            name = "Carbonfox",
            colorscheme = "carbonfox",
            before = [[
              require('nightfox').setup({
                options = {
                  transparent = false,
                  styles = { comments = "italic" }
                }
              })
            ]],
          },
          { name = "Nvim Default", colorscheme = "default" },
        },
      })
    end,
  },
}
