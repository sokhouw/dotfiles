vim.filetype.add({
  filename = {
    ["rebar.config"] = "erlang",
    ["rebar.config.script"] = "erlang",
    ["erlang_ls.config"] = "yaml",
  },
  pattern = {
    [".*%.app%.src"] = "erlang",
  }
})
