local git_cmd = function()
  if os.execute("git rev-parse --is-inside-work-tree") == 0 then
    -- Toolkit.log.info("using git", "dfg")
    return { "git" }
  else
    -- Toolkit.log.info("using dfg", "dfg")
    return { "git",
             "-c", "include.path=" .. vim.env.HOME .. "/.config/git/dfg.config",
             "--git-dir", vim.env.HOME .. "/.local/share/dotfiles/repo",
             "--work-tree=" .. vim.env.HOME }
  end
end

return {
  "sindrets/diffview.nvim",
  opts = {
    git_cmd = git_cmd(),
    view = {
      default = {
        disable_diagnostics = true,
      },
    },
  },
}
