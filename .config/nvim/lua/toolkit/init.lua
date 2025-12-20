local M = {}

M.log = require("toolkit.log")
M.mason = require("toolkit.mason")
M.treesitter = require("toolkit.treesitter")
M.diagnostic = require("toolkit.diagnostic")

_G.Toolkit = M

M.open_dashboard = function()
  Toolkit.manual_dashboard = true
  Snacks.dashboard.open({})
end

M.close_dashboard = function()
  if Toolkit.manual_dashboard then
    Toolkit.manual_dashboard = false
    Snacks.dashboard.close()
  else
    vim.cmd("qa!")
  end
end

M.tostring = function(o)
  if type(o) == 'table' then
    local s = '{ '
    for k,v in pairs(o) do
       if type(k) ~= 'number' then k = '"'..k..'"' end
       s = s .. '['..k..'] = ' .. M.tostring(v) .. ','
    end
    return s .. '} '
  else
    return tostring(o)
  end
end

M.tablelen = function(t)
  local count = 0
  for _ in pairs(t) do count = count + 1 end
  return count
end

return M
