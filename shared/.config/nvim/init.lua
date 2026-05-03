-- As config is symlinked:
vim.opt.backupcopy = "yes"

require("devdk.core.init")
require("devdk.core.keymaps")
require("devdk.utils")
require("devdk.core.cheatsheet")
require("devdk.core.goth").setup()
require("devdk.core.sql").setup()
require("devdk.lazy")
