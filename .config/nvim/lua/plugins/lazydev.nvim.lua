return {
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    dependencies = {
      {
        "DrKJeff16/wezterm-types",
        lazy = true,
        version = false, -- Get the latest version
      },
    },
    integrations = {
      lspconfig = true,
    },
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = "wezterm-types", modes = { "wezterm" } },
        { path = "lazy.nvim", words = { "lazy", "LazyVim" } },
        { path = "snacks.nvim", words = { "snacks", "Snacks" } },
        { path = vim.fn.stdpath("config") },
      },
    },
  },
}
