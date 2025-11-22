vim.diagnostic.config({
  -- Displays diagnostic messages inline at the end of the relevant line.
  virtual_text = {
    enabled = true,
    -- Prefix diagnostic text with it
    prefix = "🡄 ",
    -- How far away from EOL diagnostic gets displayed
    spacing = 10,
  },

  float = {
    focusable = true,
    style = "minimal",
    border = "rounded",
    source = true,
    header = "H",
    prefix = "P",
  },

  severity_sort = true,

  -- Underlines the problematic text directly in the buffer
  underline = true,

  -- Enable diagnostics updates while you are in insert mode
  update_in_insert = false,

  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "󰅙",
      [vim.diagnostic.severity.WARN]  = "",
      [vim.diagnostic.severity.INFO]  = "󰋼",
      [vim.diagnostic.severity.HINT]  = "󰌵",
    },
  },
})
