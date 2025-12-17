local M = {}

local ensure_treesitter_cli = function(callback)
  callback = callback or function() end
  if vim.fn.executable("tree-sitter") == 1 then
    -- good, tree-sitter already installed
    callback()
  else
    -- bad, try if require will trigger install
    if pcall(require, "mason") then
      if vim.fn.executable("tree-sitter") == 1 then
        -- good, it worked (don't know how and why)
        callback()
      else
        -- bad, try installing forcibly
        Toolkit.mason.install("tree-sitter-cli", function()
          callback()
        end)
      end
    else
      -- bad, tree-siter still not installed, give up
      Toolkit.log.error("`mason' is not installed")
    end
  end
end

M.build = function(spec)
  Toolkit.log.info("build treesitter 1")
  ensure_treesitter_cli(function()
    Toolkit.log.info("build treesitter 1")
    local ts = require("nvim-treesitter")
    ts.install(spec.opts.ensure_installed, { summary = true }):await(function()
      ts.update(nil, { summary = true })
      local tsc = require("nvim-treesitter.config")
      local user_data = { install_dir = tsc.get_install_dir("") }
      tsc.setup(user_data)
    end)
  end)
end

M.config = function(_, opts)
  require("nvim-treesitter").setup(opts)
end

return M
