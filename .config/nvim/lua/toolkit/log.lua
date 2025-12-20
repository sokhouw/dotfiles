local M = {}

local function log(level, msg, title)
  vim.notify(msg, level, { title = title or "Toolkit" })
end

function M.info(msg, title)
  log(vim.log.levels.INFO, msg, title)
end

function M.warn(msg, title)
  log(vim.log.levels.WARN, msg, title)
end

function M.error(msg, title)
  log(vim.log.levels.ERROR, msg, title)
end

return M
