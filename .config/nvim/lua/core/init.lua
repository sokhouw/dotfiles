-- TODO prevent multi require

local M = {
  log = {
    info = function(msg)
      vim.notify(msg, vim.log.levels.INFO, { title = "core" })
    end,
    error = function(msg)
      vim.notify(msg, vim.log.levels.INFO, { title = "core" })
    end,
  },
  mason = {
    opts = {}
  },
  treesitter = {
    opts = {}
  }
}

_G.Core = M

M.mason.setup = function(opts)
  require("mason").setup(opts)
  M.mason.opts = opts
end

M.treesitter.setup = function(opts)
  require("nvim-treesitter").setup(opts)
  M.treesitter.opts = opts
end

M.mason.init = function(callback)
  local mr = require("mason-registry")
  for _, name in pairs(M.mason.opts.ensure_installed) do
    if mr.has_package(name) then
      local p = mr.get_package(name)
      if not p:is_installed() then
        p:install(
          nil,
          vim.schedule_wrap(function(success)
            if success then
              M.log.info("Installed mason/" .. name)
              if name == "tree-sitter-cli" then
                callback()
              end
            else
              M.log.error("Failed to install mason/" .. name)
            end
          end)
        )
      else
        if name == "tree-sitter-cli" then
          callback()
        end
      end
    else
      M.log.info("Not found: mason/" .. name)
    end
  end
end

M.treesitter.init = function()
  local ts = require("nvim-treesitter")
  ts.install(M.treesitter.opts.ensure_installed, { summary = true }):await(function()
    return true
  end)
end

M.init = function() 
  Core.mason.init(function()
    Core.treesitter.init()
  end)
end

-- vim.api.nvim_create_autocmd("User", {
--   pattern = "VeryLazy",
--   callback = function()
--     Core.mason.init(function()
--       Core.treesitter.init()
--     end)
--   end
-- })

return M
