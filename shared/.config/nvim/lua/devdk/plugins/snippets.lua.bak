return {
  "L3MON4D3/LuaSnip",
  tag = "v2.*",
  run = "make install_jsregexp",

  config = function()
    local ls = require("luasnip")

    local snip = ls.snippet
    local text = ls.text_node
    local insert = ls.insert_node

    ls.add_snippets("all", {})

    ls.add_snippets("lua", {
      snip("hello", {
        text('print("hello '),
        insert(1),
        text(' Youu")'),
      }),
    })

    ls.add_snippets("go", {
      snip({
        trig = "error",
        name = "myErrorSnip",
        dscr = "i made this snip myself",
      }, {
        text("if error != nil then"),
      }),
      snip({
        trig = "vv",
        name = "variable",
        dscr = "set a variable",
      }, {
        insert(1, "varName"),
        text(":="),
        insert(2, "variable"),
        insert(0),
      }),
    })

    --CTRL-J jump to the next parameter
    --CTRL-K jump backwards
    local keymap = vim.api.nvim_set_keymap
    local opts = { noremap = true, silent = true }
    keymap("i", "<c-j>", "<cmd>lua require'luasnip'.jump(1)<CR>", opts)
    keymap("s", "<c-j>", "<cmd>lua require'luasnip'.jump(1)<CR>", opts)
    keymap("i", "<c-k>", "<cmd>lua require'luasnip'.jump(-1)<CR>", opts)
    keymap("s", "<c-k>", "<cmd>lua require'luasnip'.jump(-1)<CR>", opts)
  end,
}
