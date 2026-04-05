local M = {}

-- local function safe_require(path)
--   local status, lib = pcall(require, path)
--   if status then
--     return lib
--   else
--     print("Could not load module: " .. path)
--     return nil
-- end
--

-- Load sub-modules
M.os = require("devdk.utils.which-os")
M.notes = require("devdk.utils.zettelkasten")

return M
