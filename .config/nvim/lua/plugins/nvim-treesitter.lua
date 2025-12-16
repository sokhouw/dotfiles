return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    "mason-org/mason.nvim"
  },
  branch = "main",
  version = false,
  build = ":TSUpdate",
  opts = {
    auto_install = true,
    ensure_installed = {
      "bash",
      "c",
      "diff",
      "html",
      "javascript",
      "jsdoc",
      "json",
      "jsonc",
      "lua",
      "luadoc",
      "luap",
      "markdown",
      "markdown_inline",
      "printf",
      "python",
      "query",
      "regex",
      "toml",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "xml",
      "yaml",
    },
  },
  config = function(_, opts)
    Core.treesitter.setup(opts)
  end
}
