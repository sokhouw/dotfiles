return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    "mason-org/mason.nvim"
  },
  branch = "main",
  version = false,
  build = Toolkit.treesitter.build,
  opts = {
    auto_install = true,
    ensure_installed = {
      "bash",
      "c",
      "diff",
      "erlang",
      "json",
      "lua",
      "markdown",
      "markdown_inline",
      "vim",
      "yaml",
    },
  },
}
