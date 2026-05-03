local M = {}

-- 1. Insert a multi-line SQL block with Treesitter injection
function M.insert_sql_block()
	local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
	local lines = {
		"// language=sql",
		"const query = `",
		"    ",
		"`",
	}
	vim.api.nvim_buf_set_lines(0, row, row, false, lines)
	-- Position cursor inside the backticks
	vim.api.nvim_win_set_cursor(0, { row + 3, 4 })
	vim.cmd("startinsert")
end

-- 2. Toggle the SQL result window (Execute or Close)
function M.toggle_sql_results()
	local result_win = -1
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)
		if vim.bo[buf].filetype == "dbout" then
			result_win = win
			break
		end
	end

	if result_win ~= -1 then
		vim.api.nvim_win_close(result_win, true)
	else
		-- Select inside backticks and execute via Dadbod
		-- Note: using \r or <CR> inside vim.cmd
		vim.cmd("normal! vi`:DB\r")
	end
end

-- 3. Custom highlighting the // language=sql string
function M.setup_highlights()
	vim.api.nvim_set_hl(0, "SqlLanguageMarker", { fg = "#FFA500", italic = true, bold = true })

	vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
		pattern = "*.go",
		callback = function()
			-- Standardize with a space to match the insert_sql_block function
			vim.fn.matchadd("SqlLanguageMarker", "// language=sql")
		end,
	})
end

-- 4. Logic for blink.cmp
function M.is_sql_context()
	if vim.tbl_contains({ "sql", "mysql", "plsql" }, vim.bo.filetype) then
		return true
	end
	local ok, node = pcall(vim.treesitter.get_node)
	return ok and node and node:language() == "sql"
end

-- 5. Consolidated Setup Function
M.setup = function()
	-- Run highlights
	M.setup_highlights()

	-- 2. Load Dotenv ONLY after plugins are loaded
	vim.api.nvim_create_autocmd("User", {
		pattern = "LazyVimStarted", -- Or simply "VimEnter" for general setups
		callback = function()
			if vim.fn.exists(":Dotenv") > 0 and vim.fn.filereadable(".env") == 1 then
				vim.cmd("Dotenv .env")
			end
		end,
	})

	-- Keymaps
	vim.keymap.set("n", "<leader>sq", M.insert_sql_block, { desc = "Insert SQL block" })
	vim.keymap.set("n", "<leader>st", M.toggle_sql_results, { desc = "Toggle SQL results" })
	vim.keymap.set("n", "<leader>du", "<cmd>DBUIToggle<cr>", { desc = "Toggle DBUI Sidebar" })
end

return M
