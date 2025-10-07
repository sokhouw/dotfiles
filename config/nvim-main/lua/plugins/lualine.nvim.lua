return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "bwpge/lualine-pretty-path",
  },
  opts = {
    options = {
      theme = "material",
      globalstatus = true,
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch", "diff",
        { "diagnostics",
          symbols = {
            error = " ",
            hint = " ",
            info = " ",
            warn = " ",
          },
        },
      },
      lualine_c = { "pretty_path" },
      lualine_x = { "encoding", "fileformat", "filetype" },
      lualine_y = { "lsp_status" },
      lualine_z = { "location" },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = { "branch" },
      lualine_c = { { "pretty_path", use_color = true, directories = { max_depth = 3 } } },
      lualine_x = {},
      lualine_y = {},
      lualine_z = {},
    },
  },
}
