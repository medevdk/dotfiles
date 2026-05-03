local M = {}

local function get_cheatsheet_path()
	return vim.fn.stdpath("config") .. "/cheatsheet.txt"
end

function M.open_cheatsheet()
	local filepath = get_cheatsheet_path()
	local f = io.open(filepath, "r")
	if not f then
		vim.notify("Cheatsheet not found at " .. filepath, vim.log.levels.WARN)
		return
	end

	local lines = {}
	for line in f:lines() do
		table.insert(lines, line)
	end
	f:close()

	-- Compute width from longest line, clamped to sane bounds
	local width = 30
	for _, line in ipairs(lines) do
		width = math.max(width, #line + 2)
	end
	width = math.min(width, vim.o.columns - 4)

	local height = math.min(#lines, vim.o.lines - 6)
	local ui = vim.api.nvim_list_uis()[1]

	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_set_option_value("buftype", "nofile", { buf = buf })
	vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.api.nvim_set_option_value("modifiable", false, { buf = buf })

	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		col = math.floor((ui.width - width) / 2),
		row = math.floor((ui.height - height) / 2),
		style = "minimal",
		border = "rounded",
	})

	-- Syntax highlighting
	vim.fn.matchadd("Title", [[^---.*---$]], 10, -1, { window = win })
	vim.fn.matchadd("Comment", [[: .*$]], 10, -1, { window = win }) -- dim descriptions
	vim.fn.matchadd("Special", [[<[^>]*>]], 10, -1, { window = win }) -- <leader> etc
	-- vim.fn.matchadd("Special", [[\b\(s[adrf]\|sh\)[^ ]*]], 10, -1, { window = win }) -- surround cmds
	vim.fn.matchadd("Special", [[\<\(s[adrf]\|sh\)[^ ]*]], 10, -1, { window = win })

	-- Close on q or <Esc>
	local close = function()
		if vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_close(win, true)
		end
	end
	for _, key in ipairs({ "q", "<Esc>" }) do
		vim.keymap.set("n", key, close, { buffer = buf, silent = true, nowait = true })
	end

	-- Auto close the float when focus left
	vim.api.nvim_create_autocmd("WinLeave", {
		buffer = buf,
		once = true,
		callback = close,
	})
end

function M.edit_cheatsheet()
	vim.cmd("vsplit " .. get_cheatsheet_path())
end

vim.keymap.set("n", "<leader>?", M.open_cheatsheet, { desc = "View keymaps cheatsheet" })
vim.keymap.set("n", "<leader>ec", M.edit_cheatsheet, { desc = "Edit cheatsheet.txt" })

return M
