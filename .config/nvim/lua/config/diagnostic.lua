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

local orig_progress = vim.lsp.handlers["$/progress"]
local pending = {}

local function refresh_buffers(client, ft)
  for bufnr, attached in pairs(client.attached_buffers or {}) do
    if attached and vim.api.nvim_buf_is_valid(bufnr) then
      if vim.bo[bufnr].filetype == ft then
        vim.schedule(function()
          vim.api.nvim_buf_call(bufnr, function()
            vim.cmd("edit")
            vim.diagnostic.show()
          end)
        end)
      end
    end
  end
end

vim.lsp.handlers["$/progress"] = function(err, result, ctx, config)
  local client = vim.lsp.get_client_by_id(ctx.client_id)
  if client and client.name == "lua_ls" then
    local v = result.value
    if v.kind == "begin" and v.title == "Loading workspace" then
      pending[result.token] = true
    elseif v.kind == "end" and pending[result.token] then
      pending[result.token] = nil
      refresh_buffers(client, "lua")
    end
  end
  if orig_progress then
    orig_progress(err, result, ctx, config)
  end
end
