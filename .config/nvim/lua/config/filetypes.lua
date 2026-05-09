vim.filetype.add({
  filename = {
    ["rebar.config"] = "erlang",
    ["rebar.config.script"] = "erlang",
    ["erlang_ls.config"] = "yaml",
    ["dfg.config"] = "gitconfig",
    ["git.config"] = "gitconfig",
  },
  pattern = {
    [".*%.app%.src"] = "erlang",
  }
})
