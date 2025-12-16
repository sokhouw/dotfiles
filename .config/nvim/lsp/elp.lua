---@type vim.lsp.Config
return {
  cmd = { "elp", "server" },
  filetypes = { "erlang" },
  root_markers = { "rebar.config", "rebar.config.script", ".git" },
}
