require("toolkit")

require("config/clipboard")
require("config/diagnostic")
require("config/filetypes")
require("config/options")
require("config/lsp")
require("config/lazy")

if vim.api.nvim_get_option_value("diff", { win = 0 }) then
  vim.cmd("colorscheme catppuccin-mocha")
else
  vim.cmd("colorscheme vague")
end
