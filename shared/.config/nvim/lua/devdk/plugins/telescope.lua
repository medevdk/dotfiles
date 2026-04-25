return {
  --in insert mode <C-/> and in normal mode ?
  --will give info for available keys
  --
  "nvim-telescope/telescope.nvim",
  enabled = true,
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "folke/todo-comments.nvim",
    "nvim-telescope/telescope-ui-select.nvim",
  },

  config = function()
    local telescope = require("telescope")
    local telescopeConfig = require("telescope.config")
    local builtin = require("telescope.builtin")

    --Clone the default Telescope configuration
    local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }
    --I want to search in hidden / dot files
    table.insert(vimgrep_arguments, "--hidden")
    table.insert(vimgrep_arguments, "--no-ignore")
    --I do not want to search in the.git directory
    table.insert(vimgrep_arguments, "--glob")
    table.insert(vimgrep_arguments, "!**/.git/*")

    telescope.setup({
      defaults = {
        vimgrep_arguments = vimgrep_arguments,
        path_display = { "smart" },
        -- path_display = path_display,
        layout_strategy = "horizontal",
        file_ignore_patterns = {
          "node_modules",
          ".git/",
          "_templ.go",
        },
        mappings = {
          i = {
            ["<C-k>"] = require("telescope.actions").move_selection_previous,
            ["<C-j>"] = require("telescope.actions").move_selection_next,
            ["<C-q>"] = require("telescope.actions").send_to_qflist
                + require("telescope.actions").open_qflist,
            ["<ESC>"] = require("telescope.actions").close,
          },
        },
      },
      pickers = {
        find_files = {
          --ensure find_files also sees hidden files but ignores .git
          find_command = { "rg", "--files", "--hidden", "--no-ignore", "--glob", "!**/.git/*" },
        },
      },
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown({}),
        },
      },
    })

    -- Keymaps
    vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "[F]ind [Files]" })
    vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "[F]ind with [G]rep" })
    vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "[F]ind in [B]uffer" })
    vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "[F]ind in [H]elp" })
    vim.keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "[F]ind [T]odos" })

    -- Usefull for GoTH: Search specifically for Templ Components
    vim.keymap.set("n", "<leader><fc>", function()
      builtin.live_grep({ default_text = "templ " })
    end, { desc = "[F]ind [C]omponents" })

    telescope.load_extension("ui-select")
  end,
}
