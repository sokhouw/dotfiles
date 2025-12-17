local M = {}

M.info = function(msg, title)
  vim.notify(msg, vim.log.levels.INFO, { title = "toolkit" })
end

M.error = function(msg, title)
  vim.notify(msg, vim.log.levels.ERROR, { title = "toolkit" })
end

return M
