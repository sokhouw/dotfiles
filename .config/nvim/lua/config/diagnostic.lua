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

-- This autocmd here tackles the issue with lua-language-server when diagnostics are not showing up on initial load of the file.
vim.api.nvim_create_autocmd("LspProgress", {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local value = ev.data.params.value

    if client and client.name == "lua_ls" and value.kind == "end" and value.title == "Loading workspace" then
      for bufnr, _ in ipairs(vim.lsp.get_client_by_id(client.id).attached_buffers) do
      -- for _, bufnr in ipairs(vim.lsp.get_buffers_by_client_id(client.id)) do
        if vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].filetype == "lua" then
          -- Do not mess with Diffview is running :edit breaks diffs
          local is_diff = vim.wo[0].diff or vim.bo[bufnr].filetype:match("Diffview") or vim.api.nvim_buf_get_name(bufnr):match("^diffview://")
          if not is_diff then
            vim.schedule(function()
              vim.api.nvim_buf_call(bufnr, function()
                vim.cmd("edit")
              end)
            end)
          end
        end
      end
    end
  end,
})
