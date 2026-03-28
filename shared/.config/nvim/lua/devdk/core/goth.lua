local M = {}

local server_job_id = nil

-- Run templ generate
M.generate = function()
	print("Generating Templ components...")
	vim.fn.jobstart({ "templ", "generate" }, {
		on_exit = function(_, code)
			if code == 0 then
				print("Templ generation complete")
				vim.cmd("checktime")
			else
				vim.api.nvim_err_writeln("Templ generation failed")
				vim.cmd("split | term templ generate")
			end
		end,
	})
end

M.build_css = function()
	print("Building Tailwind")
	vim.fn.jobstart({ "npx", "@tailwindcss/cli", "-i", "./ui/css/input.css", "-o", "./ui/css/output.css" }, {
		on_exit = function(_, code)
			if code == 0 then
				print("Tailwind build complete")
			else
				vim.api.nvim_err_writeln("Tailwind build failed")
			end
		end,
	})
end

-- Kill and Run the Go server
M.run_server = function()
	-- Kill the old server if it is running
	if server_job_id ~= nil then
		vim.fn.jobstop(server_job_id)
		server_job_id = nil
		print("Old server stopped")
	end

	print("Starting new server")
	vim.cmd("botright 5split | term go run .")
	-- Get the new job ID from the terminal buffer
	server_job_id = vim.b.terminal_job_id
	local term_buf = vim.api.nvim_get_current_buf()

	-- Scroll to bottom and then jump back to the code window
	vim.cmd("normal! G")
	vim.cmd("wincmd p")

	-- Close the terminal window if server started cleanly
	vim.defer_fn(function()
		local lines = vim.api.nvim_buf_get_lines(term_buf, 0, -1, false)
		local output = table.concat(lines, "\n")

		if string.find(output, "Error") or string.find(output, "error") then
			print("Server error - terminal kept open")
		else
			for _, win in ipairs(vim.api.nvim_list_wins()) do
				if vim.api.nvim_win_get_buf(win) == term_buf then
					vim.api.nvim_win_close(win, false)
					break
				end
			end
			print("Server started - terminal closed")
		end
	end, 2000) -- 2 sec gives go run . time to compile and bind to the port
end

-- Stop the server
M.stop_server = function()
	if server_job_id ~= nil then
		vim.fn.jobstop(server_job_id)
		server_job_id = nil
		print("Server stopped")
	else
		print("No server running at this moment")
	end
end

-- Refresh Firefox (MacOS only)
-- note: health poll script in Base() will auto-reload the browser when server restarts
M.firefox_refresh = function()
	local script = [[
        tell application "Firefox" to activate
        delay 0.1
        tell application "System Events" to keystroke "r" using command down
    ]]
	vim.fn.jobstart({ "osascript", "-e", script })
end

-- Refresh other Browser (Chrome etc)
M.browser_refresh = function()
	-- Change "Google Chrome" to "Safari" or "Arc"
	local browser = "Google Chrome"
	local cmd = string.format(
		"osascript -e 'tell application \"%s\" to tell the active tab of its first window to reload'",
		browser
	)
	vim.fn.jobstart(cmd)
end

-- Templ -> Tailwind -> Run -> Refresh
M.dev = function()
	vim.fn.jobstart({ "templ", "generate" }, {
		on_exit = function(_, code)
			if code == 0 then
				M.build_css()
				M.run_server()
				vim.defer_fn(M.firefox_refresh, 800)
				print("GoTH Sync: Templ Generated | CSS Built | Server Restarted")
			end
		end,
	})
end

-- Read the log in a split
M.logs = function()
	-- Open the log in a bottom split
	vim.cmd("botright 8split | view clog.log")
	local log_buf = vim.api.nvim_get_current_buf()
	local log_win = nil

	-- Jump to the end
	vim.cmd("normal! G")
	vim.cmd("wincmd p")

	vim.defer_fn(function()
		for _, win in ipairs(vim.api.nvim_list_wins()) do
			if vim.api.nvim_win_get_buf(win) == log_buf then
				log_win = win
				break
			end
		end

		if log_win == nil then
			return
		end

		-- Auto-tail: reload the file every 2 seconds
		local timer = vim.loop.new_timer()
		timer:start(
			0,
			2000,
			vim.schedule_wrap(function()
				-- Stop tailing if the buffer was closed
				if not vim.api.nvim_buf_is_valid(log_buf) then
					timer:stop()
					timer:close()
					return
				end

				-- Stop tailing if the log window was closed
				if not vim.api.nvim_win_is_valid(log_win) then
					timer:stop()
					timer:close()
					return
				end

				vim.cmd("checktime")

				-- Only scroll to bottom if cursor is already at the end
				local last_line = vim.api.nvim_buf_line_count(log_buf)
				local cursor = vim.api.nvim_win_get_cursor(log_win)
				if cursor[1] >= last_line - 1 then
					vim.api.nvim_win_set_cursor(log_win, { last_line, 0 })
				end
			end)
		)
	end, 100)
end

-- Keymaps
M.setup = function()
	vim.keymap.set("n", "<leader>tg", M.generate, { desc = "GoTH: [T]empl [G]enerate" })
	vim.keymap.set("n", "<leader>gr", M.run_server, { desc = "GoTH: [G]o [R]un/Restart Server" })
	vim.keymap.set("n", "<leader>tc", M.build_css, { desc = "GoTH: [T]ailwind [C]ompile" })
	vim.keymap.set("n", "<leader>gs", M.stop_server, { desc = "GoTH: [G]o [S]top Server" })
	vim.keymap.set("n", "<leader>gd", M.dev, { desc = "GoTH: [G]oTH [D]evelop" })
	vim.keymap.set("n", "<leader>gl", M.logs, { desc = "GoTH: [G]o [L]ogs" })
end

return M
