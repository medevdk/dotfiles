local M = {}

M.open_floating_zsh = function()
	local width = math.ceil(vim.o.columns * 0.8)
	local height = math.ceil(vim.o.lines * 0.8)
	local row = math.ceil((vim.o.lines - height) / 2)
	local col = math.ceil((vim.o.columns - width) / 2)

	local buf = vim.api.nvim_create_buf(false, true)
	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		title = "Terminal",
		style = "minimal",
		border = "rounded",
	})

	-- Start the terminal
	vim.fn.termopen("tmux new-session -A -s nvim_popup zsh")
	vim.cmd("startinsert")

	-- Instant Close keymap, ESC will work for this buffer only
	vim.keymap.set("t", "<ESC>", function()
		if vim.api.nvim_win_is_valid(win) then
			-- Detach tmux session before closing so it will persist
			vim.api.nvim_chan_send(vim.bo[buf].channel, "tmux detach\r")
			vim.defer_fn(function()
				vim.api.nvim_win_close(win, true)
				vim.schedule(function()
					if vim.api.nvim_buf_is_valid(buf) then
						vim.api.nvim_buf_delete(buf, { force = true })
					end
				end)
			end, 50) -- small delay to let tmux detach before buffer dies
		end
	end, { buffer = buf, desc = "Close terminal popup" })
end

return M
