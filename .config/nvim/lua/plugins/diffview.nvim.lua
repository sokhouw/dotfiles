local git_cmd = function()
  if os.execute("git rev-parse --is-inside-work-tree 2>/dev/null") == 0 then
    return { "git" }
  else
    return { "git",
             "-c", "include.path=" .. vim.env.HOME .. "/.config/git/dfg.config",
             "--git-dir", vim.env.HOME .. "/.local/share/dotfiles/repo",
             "--work-tree=" .. vim.env.HOME }
  end
end

local dv_keymap = {
  { "n", "<leader>dv", ":DiffviewClose<CR>", { desc = "Close Diff View" } },
}

return {
  "sindrets/diffview.nvim",
  opts = {
    git_cmd = git_cmd(),
    view = {
      defaaadult = {
        disable_diagnostics = true,
      },
    },
    keymaps = {
      view               = dv_keymap,
      file_panel         = dv_keymap,
      file_history_panel = dv_keymap,
    },
  },
}
