-- Dashboard
vim.keymap.set("n", "<leader>D", Dashboard.open, { desc = "Dashboard"} )
-- Diffview
vim.keymap.set('n', '<leader>dv', ":DiffviewOpen<CR>", { desc = "Open Diff View" })
vim.keymap.set('n', '<leader>df', ":DiffviewFileHistory<CR>", { desc = "Open File History" })
