vim.g.mapleader = " " -- Keep at top file

local keymap = vim.keymap
local notes = require("devdk.utils.zettelkasten") -- for Zettelkasten keymappings

keymap.set("n", "-", vim.cmd.Ex)

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

--Pane Navigation
keymap.set("n", "<C-h>", "<C-w>h", opts) --Navigate Left
keymap.set("n", "<C-j>", "<C-w>j", opts) --Navigate Down
keymap.set("n", "<C-k>", "<C-w>k", opts) --Navigate Up
keymap.set("n", "<C-l>", "<C-w>l", opts) --Navigate Right

--Window Management
keymap.set("n", "<leader>sv", ":vsplit<CR>", opts) --Split Vertical
keymap.set("n", "<leader>sh", ":split<CR>", opts) --Split Horizontal
keymap.set("n", "<leader>sm", ":MaximizerToggle<CR>", opts) --Toggle Minimize

--Toggle spell checker
keymap.set("n", "<leader>sp", ":set spell!<cr>", { desc = "Toggle spell checker" })

-- Terminal mode escape. Jump back to code
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })

-- CUSTOM COMMAND: open floating terminal
vim.keymap.set("n", "<leader>fp", function()
	require("devdk.utils").terminal.open_floating_zsh()
end, { desc = "Floating popup terminal with tmux" })

-- CUSTOM COMMAND for Zettelkasten Notes
vim.keymap.set("n", "<leader>zb", function()
	-- Ensure 'notes' is available in this scope
	-- local notes = require("devdk.utils.zettelkasten")

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

vim.keymap.set("n", "<leader>zw", notes.quick_capture, { desc = "Notes Write Note" })
vim.keymap.set("n", "<leader>zl", notes.insert_link, { desc = "Notes: Insert Link" })
vim.keymap.set("n", "<leader>zc", notes.discover_connections, { desc = "Notes: Discover Connections" })
vim.keymap.set("n", "<leader>zf", notes.follow_link, { desc = "Notes: Follow Link" })
vim.keymap.set("n", "<leader>zr", notes.rename_note, { desc = "Notes: Rename Note" })
vim.keymap.set("n", "<leader>zd", function()
	require("devdk.utils.zettelkasten").daily_log()
end, { desc = "Open daily Zettel log" })
vim.keymap.set("n", "]n", function()
	require("devdk.utils.zettelkasten").navigate_notes(1)
end, { desc = "Next Note" })
vim.keymap.set("n", "[n", function()
	require("devdk.utils.zettelkasten").navigate_notes(-1)
end, { desc = "Previous Note" })
