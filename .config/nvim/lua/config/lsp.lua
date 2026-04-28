-- Uncomment LSPs that are to be installed manually outside mason
-- vim.lsp.enable({"erlangls"})
-- ELP (Erlang Language Platform) is manually enabled here as it's not configured via mason-lspconfig.
-- Ensure the 'elp' binary is available in your PATH.
vim.lsp.enable({"elp"})
