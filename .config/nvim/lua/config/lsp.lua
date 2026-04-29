-- Uncomment LSPs that are to be installed manually outside mason
-- ELP (Erlang Language Platform) is manually enabled here as it's not configured via mason-lspconfig.
-- Ensure the 'erlang_ls' binary is available in your PATH.
vim.lsp.enable({"erlangls"})
--vim.lsp.enable({"elp"})
