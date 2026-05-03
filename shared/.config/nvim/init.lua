-- As config is symlinked:
vim.opt.backupcopy = "yes"

require("core.init")
require("core.keymaps")
require("utils")
require("core.cheatsheet")
require("core.goth").setup()
require("core.sql").setup()
require("pluginmanager")
