local M = {}

M.is_mac = vim.loop.os_uname().sysname == "Darwin"
M.is_linux = vim.loop.os_uname().sysname == "Linux"
M.is_pi = M.is_linux and vim.fn.system("uname -m"):match("aarch64") ~= nil

--Get home directory
M.home = os.getenv("HOME"):gsub("/$", "")

return M
