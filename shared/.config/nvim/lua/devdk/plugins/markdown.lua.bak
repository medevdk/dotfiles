return {
  "iamcco/markdown-preview.nvim",
  cmd = {
    "MarkdownPreviewToggle",
    "MarkdownPreview",
    "MarkdownPreviewStop"
  },
  ft = {
    "markdown"
  },
  build = function()
    vim.fn["mkdp#util#install"]()
  end,
  config = function()
    vim.cmd([[do FileType]])

    vim.keymap.set("n", "<leader>cp", ":MarkdownPreviewToggle<cr>", { desc = "Markdown Preview" })
    -- vim.keymaop.set("n", "<leader>mv, MarkdownPreview, desc = {Preview Markdown}")
    -- vim.keymaop.set("n", "<leader>ms, MarkdownPreviewStop, desc = {Stop Preview Markdown}")
  end
}
