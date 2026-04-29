---@type vim.lsp.Config
return {
  cmd = { "erlang_ls" },
  filetypes = { "erlang" },
  root_markers = { "rebar.config", "rebar.config.script", ".git" },
}
