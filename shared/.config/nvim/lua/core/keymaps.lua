vim.g.mapleader = " " -- Keep at top file

local keymap = vim.keymap
local notes = require("utils.zettelkasten") -- for Zettelkasten keymappings

local opts = { noremap = true, silent = true }

-- in Insert and Visual mode map Esc to jk
keymap.set("i", "jk", "<esc>", { desc = "Exit insert mode with jk" })
keymap.set("v", "jk", "<esc>", { desc = "Exit visual mode with jk " })

-- in Visual mode move text with J and K
keymap.set("v", "J", ":m '>+1<CR>gv=gv", vim.tbl_extend("force", opts, { desc = "Move selection down" }))
keymap.set("v", "K", ":m '<-2<CR>gv=gv", vim.tbl_extend("force", opts, { desc = "Move selection up" }))

--Clear search high lights -> not needed, in options hlsearch is off
keymap.set("n", "<leader>nh", ":noh<CR>", { desc = "Clear search highlights" })

--Choose a theme
keymap.set("n", "<leader>th", ":Themery<CR>", { desc = "Choose Theme" })

--Pane Navigation is handled by vim-tmux-navigator (<C-h/j/k/l>, see plugins/tmux.lua)

--Window Management
keymap.set("n", "<leader>sv", ":vsplit<CR>", opts) --Split Vertical
keymap.set("n", "<leader>sh", ":split<CR>", opts) --Split Horizontal
keymap.set("n", "<leader>sm", ":MaximizerToggle<CR>", opts) --Toggle Minimize

--Toggle spell checker
keymap.set("n", "<leader>sp", ":set spell!<cr>", { desc = "Toggle spell checker" })

-- Terminal mode escape. Jump back to code
keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })

-- CUSTOM COMMAND: open floating terminal
keymap.set("n", "<leader>fp", function()
	require("utils").terminal.open_floating_zsh()
end, { desc = "Floating popup terminal with tmux" })

-- CUSTOM COMMAND for Zettelkasten Notes
keymap.set("n", "<leader>zb", function()
	-- Ensure 'notes' is available in this scope
	-- local notes = require("utils.zettelkasten")

	require("telescope.builtin").find_files({
		prompt_title = "Zettelkasten Notes",
		cwd = vim.fn.expand("~/notes/zettelkasten"), -- expand the ~ to a full path
		attach_mappings = function(prompt_bufnr, map)
			local actions = require("telescope.actions")
			local action_state = require("telescope.actions.state")

			map("i", "<CR>", function()
				local selection = action_state.get_selected_entry()
				actions.close(prompt_bufnr)

				-- Use selection.path for the absolute path to the file
				notes.open_floating_note(selection.path)
			end)
			return true
		end,
	})
end, { desc = "Notes Search" })

keymap.set("n", "<leader>zw", notes.quick_capture, { desc = "Notes Write Note" })
keymap.set("n", "<leader>zl", notes.insert_link, { desc = "Notes: Insert Link" })
keymap.set("n", "<leader>zc", notes.discover_connections, { desc = "Notes: Discover Connections" })
keymap.set("n", "<leader>zf", notes.follow_link, { desc = "Notes: Follow Link" })
keymap.set("n", "<leader>zr", notes.rename_note, { desc = "Notes: Rename Note" })
keymap.set("n", "<leader>zd", function()
	require("utils.zettelkasten").daily_log()
end, { desc = "Open daily Zettel log" })
keymap.set("n", "]n", function()
	require("utils.zettelkasten").navigate_notes(1)
end, { desc = "Next Note" })
keymap.set("n", "[n", function()
	require("utils.zettelkasten").navigate_notes(-1)
end, { desc = "Previous Note" })
