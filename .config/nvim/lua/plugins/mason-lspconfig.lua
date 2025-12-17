return {
  "mason-org/mason-lspconfig.nvim",
  opts = {}, -- Important !!! Without this, lua-language-server never starts
  dependencies = {
    "mason-org/mason.nvim",
    "neovim/nvim-lspconfig",
  },
}
