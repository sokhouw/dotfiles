local M = {}

M.log = require("toolkit.log")
M.mason = require("toolkit.mason")
M.treesitter = require("toolkit.treesitter")

_G.Toolkit = M

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
