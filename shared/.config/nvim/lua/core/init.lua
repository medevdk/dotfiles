-- Languages not in use, avoid clutter in :checkhealth
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0

-- force backupcopy to get rid op E13 error
vim.opt.backupcopy = "yes"

require("core.options")
-- Dadbod UI Setting
vim.g.db_ui_use_nerd_fonts = 1
vim.g.db_ui_win_width = 35
