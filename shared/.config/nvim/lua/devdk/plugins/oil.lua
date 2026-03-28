return {
  "stevearc/oil.nvim",
  opts = {
    float = {
      padding = 2,
      max_width = 80,
      max_height = 20,
      border = "rounded",
      win_options = {
        winblend = 0,
      }
    },
    confirmation = {
      border = "rounded",
      min_width = 40,
      max_width = 40,
    },
    keymaps = {
      ["q"] = "actions.close",
      ["<ESC>"] = "actions.close",
      ["<C-r"] = "actions.refresh", -- Refresh the file list if something changed externally
    },
    view_options = {
      show_hidden = true,
      is_visible = function(item)
        return not vim.endswith(item.name, "_templ.go")
      end,
    },

    --Delete to trashbin
    delete_to_trash = true,
    trash_command = "trash",
    default_file_explorer = true,
  },

  config = function(_, opts)
    require("oil").setup(opts)

    vim.keymap.set("n", "-", "<CMD>Oil --float<CR>", { desc = "Open Oil in float" })
  end,
}
