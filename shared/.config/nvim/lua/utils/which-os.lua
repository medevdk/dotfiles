local M = {}

local uname = vim.uv.os_uname()
M.is_mac = uname.sysname == "Darwin"
M.is_linux = uname.sysname == "Linux"
M.is_pi = M.is_linux and uname.machine == "aarch64"

--Get home directory
M.home = os.getenv("HOME"):gsub("/$", "")

return M
