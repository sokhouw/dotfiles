local M = {}

M.config = function(_, opts)
  require("mason").setup(opts)
  for _, name in pairs(opts.ensure_installed) do
    M.install(name)
  end
end

M.install = function(name, callback)
  callback = callback or function() end
  local mr = require("mason-registry")
  mr.refresh(function()
    local p = mr.get_package(name)
    if not p:is_installed() then
      p:install(
        nil,
        vim.schedule_wrap(function(success)
          if success then
            Toolkit.log.info("Installed `" .. name .. "` with `mason`.")
            callback()
          else
            Toolkit.log.error("Failed to install `" .. name .. "` with `mason`.")
          end
        end)
      )
    else
      callback()
    end
  end)
end

return M
