vim.api.nvim_create_autocmd("OptionSet", {
  pattern = "diff",
  callback = function()
    if vim.opt.diff:get() then
      vim.api.nvim_set_hl(0, "DiffAdd",    { bg = "#206020" })
      vim.api.nvim_set_hl(0, "DiffDelete", { bg = "#602020" })
      vim.api.nvim_set_hl(0, "DiffChange", { bg = "#202080" })
      vim.api.nvim_set_hl(0, "DiffText",   { bg = "#0000ff" })
      vim.opt.cursorline = false
      vim.opt.fillchars:append({ diff = " " })
    end
  end,
})
