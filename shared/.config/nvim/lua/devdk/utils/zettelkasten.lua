local M = {}

local utils_os = require("devdk.utils.which-os")
local NOTES_DIR = utils_os.home .. "notes/zettelkasten/"

local function get_current_project()
	-- 1. Get the current directory name as a starting fallback
	local cwd = vim.fn.getcwd()
	local folder_name = vim.fn.fnamemodify(cwd, ":t")

	-- 2. Try to find a project root (git, go.mod, etc.)
	local project_root = vim.fs.root(0, { ".git", "go.mod", "Makefile" })

	local final_name = ""

	if project_root then
		final_name = vim.fn.fnamemodify(project_root, ":t")
	else
		final_name = folder_name
	end

	-- 3. Clean up the result (Ensure it is a string and not nil)
	final_name = tostring(final_name or "Inbox")

	-- 4. Filter out common system/config folders
	if final_name == "" or final_name == "." or final_name == ".config" or final_name == "nvim" then
		return "General"
	end

	return final_name
end

function M.open_floating_note(filename)
	local screen_w = vim.o.columns
	local screen_h = vim.o.lines
	local width = math.floor(screen_w * 0.8)
	local height = math.floor(screen_h * 0.8)

	-- Create an normal buffer
	local buf = vim.api.nvim_create_buf(false, false)
	vim.api.nvim_buf_set_option(buf, "bufhidden", "hide")

	-- Open the window
	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		col = math.floor((screen_w - width) / 2),
		row = math.floor((screen_h - height) / 2),
		style = "minimal",
		border = "rounded",
	})

	if filename and filename ~= "" then
		vim.cmd("edit " .. vim.fn.fnameescape(filename))
		buf = vim.api.nvim_get_current_buf()
	end

	vim.bo[buf].filetype = "markdown"
	vim.bo[buf].bufhidden = "hide"

	-- Float window options
	vim.wo[win].wrap = true
	vim.wo[win].cursorline = true

	-- Auto-save on leaving and quit with 'q'
	vim.api.nvim_buf_set_keymap(buf, "n", "q", ":x<CR>", { noremap = true, silent = true })
	vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", ":x<CR>", { noremap = true, silent = true })

	-- Toggle checkbox with <leader>x when in the note
	vim.keymap.set("n", "<leader>x", function()
		local line = vim.api.nvim_get_current_line()
		if line:match("%[ %]") then
			line = line:gsub("%[ %]", "[x]")
		elseif line:match("%[x%]") then
			line = line:gsub("%[x%]", "[ ]")
		end
		vim.api.nvim_set_current_line(line)
	end, { buffer = buf, desc = "Toggle Checkbox" })
end

function M.daily_log()
	local dir = NOTES_DIR
	local date_id = os.date("%Y-%m-%d")
	local filename = dir .. date_id .. "-daily.md"
	local project_name = get_current_project()

	-- Check if file exists
	local file_exists = vim.fn.filereadable(filename) == 1

	-- Only insert the template if the file not exist or is empty
	local lines = vim.api.nvim_buf_get_lines(0, 0, 1, false)
	local is_empty = #lines <= 1 and (lines[1] == "" or lines[1] == nil)

	if not file_exists or is_empty then
		-- 1. Get recent git commits
		local git_lines = { "- No recent git activity" }
		local handle = io.popen("git log -5 --pretty=format:'- %s' 2>/dev/null")
		if handle then
			local result = handle:read("*a")
			handle:close()
			if result and result ~= "" then
				-- Split the string by newlines into a table
				git_lines = {}
				for line in result:gmatch("[^\r\n]+") do
					table.insert(git_lines, line)
				end
			end
		end

		-- 2. Open the floating window first
		M.open_floating_note(filename)

		-- 2. Build the template table correctly
		local template = {
			"---",
			"id: " .. os.date("%Y%m%d"),
			"type: daily-log",
			"project: " .. project_name,
			"---",
			"",
			"# 📅 Daily Log: " .. date_id .. " (" .. project_name .. ")",
			"",
			"## 🪵 Recent Activity (Git)",
		}

		-- 3. Insert the Git lines into the template table
		for _, line in ipairs(git_lines) do
			table.insert(template, line)
		end

		-- 4. Add the rest of the template
		table.insert(template, "")
		table.insert(template, "## 🎯 Today's Focus")
		table.insert(template, "- [ ] ")
		table.insert(template, "")
		table.insert(template, "## 📝 Notes & Reminders")
		table.insert(template, "> ")

		-- 5. NOW set the lines (no more newline errors!)
		vim.api.nvim_buf_set_lines(0, 0, -1, false, template)

		-- Tell Nvim this buffer IS the file on disk
		vim.api.nvim_buf_set_name(0, filename)

		-- Force a initial save so the file exists
		vim.cmd("silent! write!")
	end

	-- Move cursor to the bottom and start insert mode
	vim.cmd("normal! G")
	vim.cmd("startinsert!")
end

function M.navigate_notes(direction)
	local dir = NOTES_DIR
	local current_file = vim.fn.expand("%:p")
	local files = vim.fn.glob(dir .. "*.md", false, true)
	table.sort(files)

	for i, file in ipairs(files) do
		if file == current_file then
			local target_index = i + direction
			if files[target_index] then
				vim.cmd("edit " .. vim.fn.fnameescape(files[target_index]))
				return
			end
		end
	end
	print("No more notes in that direction")
end
--
function M.quick_capture()
	local project_name = get_current_project()

	vim.ui.input({ prompt = "Note Title: " }, function(input)
		if input == nil or input == "" then
			return
		end

		local date_id = os.date("%Y%m%d%H%M")
		local slug = input:gsub("%s+", "-"):lower()
		local dir = NOTES_DIR

		-- Check if slug exists
		local check_cmd = string.format('find "%s" -name "*-%s.md"', dir, slug)
		local handle = io.popen(check_cmd)
		local result = handle:read("*a")
		handle:close()

		if result ~= "" then
			vim.notify("Error: A note with the title '" .. input .. "' already exists", vim.log.levels.ERROR)
			return
		end

		if vim.fn.isdirectory(dir) == 0 then
			vim.fn.mkdir(dir, "p")
		end

		local filename = dir .. date_id .. "-" .. slug .. ".md"

		local f = io.open(filename, "w")
		if f then
			f:close()
		end

		M.open_floating_note(filename)

		local template = [[---
id: ${1:]] .. date_id .. [[}
title: "${2:]] .. input .. [[}"
tags: [$3]
project: "${4:]] .. project_name .. [[}"
---

# ${5:]] .. input .. [[}
      
>$0]]

		vim.schedule(function()
			vim.snippet.expand(template)
		end)
	end)
end

function M.rename_note()
	local old_path = vim.api.nvim_buf_get_name(0)
	local old_filename = vim.fn.fnamemodify(old_path, ":t")
	local dir = NOTES_DIR

	local timestamp, old_slug = old_filename:match("^(%d+)%-(.+)%.md$")

	if not timestamp or not old_slug then
		print("Not a valid Zettelkasten file", vim.log.levels.WARN)
		return
	end

	vim.ui.input({ prompt = "New Title/Slug: ", default = old_slug }, function(input)
		if input == nil or input == "" or input == old_slug then
			return
		end

		-- Format the new slug (lowercase and hyphens)
		local new_slug = input:gsub("%s+", "-"):lower()
		local new_filename = timestamp .. "-" .. new_slug .. ".md"
		local new_path = dir .. new_filename

		-- check if exists
		if vim.fn.filereadable(new_path) == 1 then
			vim.notify("Error: Target filename already exists", vim.log.levels.ERROR)
			return
		end

		-- Save the current buffer to ensure no pending changes are lost
		vim.cmd("silent! write")

		-- 2. Rename the physical file
		local success, err = os.rename(old_path, new_path)
		if not success then
			print("Error renaming file: " .. err, vim.log.levels.ERROR)
			return
		end

		-- 3. Switch buffer to the new file path
		vim.cmd("edit " .. vim.fn.fnameescape(new_path))
		--4. Force wipe out the old buffer
		vim.cmd("bwipeout! " .. vim.fn.fnameescape(old_path))

		-- 3. Update the YAML title and H1 header in the current buffer
		-- This replaces the first 'title: "..."' and the first '# ...'
		pcall(function()
			vim.cmd('silent! %s/title: ".*"/title: "' .. input .. '"/e')
			vim.cmd("silent! %s/# .*/# " .. input .. "/e")
			vim.cmd("write")
		end)

		-- 4. Global Search & Replace for [[links]]
		-- Note: Mac 'sed' requires -i ''
		local old_link = "[[" .. old_slug .. "]]"
		local new_link = "[[" .. new_slug .. "]]"

		-- Escape brackets for the shell command
		local escaped_old = old_link:gsub("%[", "\\%["):gsub("%]", "\\%]")
		local escaped_new = new_link:gsub("%[", "\\%["):gsub("%]", "\\%]")

		-- for MacOS and Linux
		local sed_i = "sed -i"
		if utils_os.is_mac then
			sed_i = "sed -i ''"
		end

		local sed_cmd = string.format("%s 's/%s/%s/g' %s/*.md", sed_i, escaped_old, escaped_new, dir)
		vim.fn.system(sed_cmd)

		vim.notify("Renamed to " .. new_filename .. " and updated all links.")
	end)
end

function M.find_backlinks()
	local filename = vim.fn.expand("%:t:r")
	if filename == "" then
		return
	end

	require("telescope.builtin").live_grep({
		search = "%[%[" .. filename .. "%]%]",
		cwd = NOTES_DIR,
		prompt_title = "Backlinks for " .. filename,
	})
end

function M.discover_connections()
	local query = vim.fn.expand("<cword>")
	if query == "" then
		return
	end

	require("telescope.builtin").live_grep({
		search = query,
		cwd = NOTES_DIR,
		attach_mappings = function(prompt_bufnr, map)
			local actions = require("telescope.actions")
			local action_state = require("telescope.actions.state")

			actions.select_default:replace(function()
				local selection = action_state.get_selected_entry()
				actions.close(prompt_bufnr)
				-- Open the discovered note in the custom float
				local full_path = selection.cwd .. "/" .. selection.filename
				M.open_floating_note(full_path)
			end)
			return true
		end,
	})
end
function M.insert_link()
	require("telescope.builtin").find_files({
		prompt_title = "Insert link to Note",
		cwd = NOTES_DIR,
		attach_mappings = function(prompt_bufnr, map)
			local actions = require("telescope.actions")
			local action_state = require("telescope.actions.state")

			actions.select_default:replace(function()
				local selection = action_state.get_selected_entry()
				actions.close(prompt_bufnr)

				local filename = vim.fn.fnamemodify(selection.path, ":t:r")
				local clean_name = filename:gsub("^%d%d%d%d%d%d%d%d%d%d%d%d%-", "")

				-- Get current line and cursor column
				local line = vim.api.nvim_get_current_line()
				local col = vim.api.nvim_win_get_cursor(0)[2]

				-- Character logic:
				-- char_before: The character to the left of the cursor
				-- char_after: The character at the cursor (or to the right)
				local char_before = line:sub(col, col)
				local char_after = line:sub(col + 1, col + 1)

				local prefix = ""
				local suffix = ""

				-- If there is NO space before us, and we aren't at the start of the line:
				if col > 0 and char_before ~= " " and char_before ~= "" then
					prefix = " "
				end

				-- If there is NO space after us, and we aren't at the end of the line:
				if char_after ~= " " and char_after ~= "" then
					suffix = " "
				end

				local link = prefix .. "[[" .. clean_name .. "]]" .. suffix

				-- Insert the link
				vim.api.nvim_put({ link }, "c", true, true)

				-- Use schedule to handle the mode switch and cursor positioning
				vim.schedule(function()
					-- Start insert mode
					vim.cmd("startinsert")

					-- If we added a suffix space, we want the cursor ON that space
					-- so the next character typed is separated.
					local current_cursor = vim.api.nvim_win_get_cursor(0)
					local current_line_len = #vim.api.nvim_get_current_line()

					-- Ensure we are at the very end of what we just inserted
					vim.api.nvim_win_set_cursor(0, { current_cursor[1], current_line_len })
				end)
			end)
			return true
		end,
	})
end
--
function M.follow_link()
	local project_name = get_current_project()

	local line = vim.api.nvim_get_current_line()
	local _, _, link_text = line:find("%[%[(.-)%]%]")

	if link_text then
		local dir = NOTES_DIR
		local find_cmd = string.format('find "%s" -name "*%s.md"', dir, link_text)
		local handle = io.popen(find_cmd)
		local result = handle:read("*a")
		handle:close()

		local files = {}
		for s in result:gmatch("[^\r\n]+") do
			table.insert(files, s)
		end

		if #files > 0 then
			-- Save the old buffer ID before switching
			vim.cmd("silent! write")
			vim.cmd("edit " .. vim.fn.fnameescape(files[1]))
		else
			-- Create New Note
			-- 2. If not found, create it
			local confirm = vim.fn.confirm("Note does not exist. Create it?", "&Yes\n&No", 2)
			if confirm == 1 then
				local date_id = os.date("%Y%m%d%H%M")
				local final_filename = date_id .. "-" .. link_text .. ".md"
				local final_path = dir .. final_filename

				local input = link_text

				local f = io.open(final_path, "w")
				if f then
					f:close()
				end

				M.open_floating_note(final_path)

				local template = [[---
id: ${1:]] .. date_id .. [[}
title:"${2:]] .. input .. [[}"
tags: [$3]
project: "${4:]] .. project_name .. [[}"
---

# ${5:]] .. input .. [[}
      
>$0]]

				vim.schedule(function()
					vim.snippet.expand(template)
				end)
			end
		end
	else
		print("No link found under cursor.")
	end
end

return M
