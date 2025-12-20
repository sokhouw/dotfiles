local M = {}

function M.refresh()
  vim.cmd("edit")
  -- local refreshed = false
  -- for _, client in ipairs(vim.lsp.get_clients({bufnr = vim.api.nvim_get_current_buf()})) do
  --   if client.name == "lua_ls" then
  --     vim.notify("lua_ls reload")
  --     -- local event = "workspace/didChangeConfiguration"
  --     -- local event = "textDocument/diagnostic"
  --     local event = "workspace/diagnostic/refresh"
  --     if client:notify(event, { settings = client.config.settings }) then
  --       refreshed = true
  --     end
  --   end
  -- end
  -- if refreshed then
  --   Toolkit.log.info("LSP refreshed")
  -- end
end

-- vim.api.nvim_create_user_command(
--   "RefreshDiagnostic",
--   function()
--     Toolkit.diagnostic.refresh()
--   end,
--   { desc = "Refresh LSP diagnostics" }
-- )

return M
