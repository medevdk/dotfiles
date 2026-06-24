vim.g.mapleader = " " -- Keep at top file

local keymap = vim.keymap
local notes = require("utils.zettelkasten") -- for Zettelkasten keymappings

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

-- ~/.config/nvim/lua/config/keymaps.lua
local function run_with_ollama(model_name, prompt_name)
	return function()
		-- prepend a range in visual mode so $text gets the selection
		local m = vim.fn.mode()
		local range = (m == "v" or m == "V" or m == "\22") and "'<,'>" or ""
		local cmd = range .. "Gen" .. (prompt_name and (" " .. prompt_name) or "")

		local function fire()
			require("gen").model = model_name
			vim.cmd(cmd) -- ":Gen" => picker, ":Gen Name" => that prompt
		end

		vim.fn.system("curl -s -o /dev/null http://localhost:11434/api/tags")
		if vim.v.shell_error ~= 0 then
			vim.notify("Ollama is offline. Starting service...", vim.log.levels.INFO)
			vim.fn.jobstart({ "ollama", "serve" }, {
				on_exit = function(_, code)
					if code ~= 0 and code ~= 130 then
						vim.schedule(function()
							vim.notify("Failed to start Ollama server.", vim.log.levels.ERROR)
						end)
					end
				end,
			})
			vim.defer_fn(fire, 2000)
		else
			fire()
		end
	end
end
-- 1. Helper function to ensure Ollama is running and switch models
-- Qwen 14b (Everyday / Component Generation)
keymap.set({ "n", "v" }, "<leader>aq", run_with_ollama("qwen2.5-coder:14b"), { desc = "AI: Open Qwen Menu" })
keymap.set("n", "<leader>ac", run_with_ollama("qwen2.5-coder:14b", "Chat"), { desc = "AI: Quick Chat with Qwen" })
keymap.set(
	"v",
	"<leader>ag",
	run_with_ollama("qwen2.5-coder:14b", "Generate_Component"),
	{ desc = "AI: Qwen Gen Component" }
)

-- DeepSeek R1 14b (Architecture Reasoning & Project Mapping)
keymap.set({ "n", "v" }, "<leader>ad", run_with_ollama("deepseek-r1:14b"), { desc = "AI: Open DeepSeek Menu" })
keymap.set("v", "<leader>ar", run_with_ollama("deepseek-r1:14b", "Deep_Reasoning"), { desc = "AI: DeepSeek Reason" })
keymap.set(
	"n",
	"<leader>as",
	run_with_ollama("deepseek-r1:14b", "Analyze_Project_Structure"),
	{ desc = "AI: DeepSeek Project Structure" }
)
