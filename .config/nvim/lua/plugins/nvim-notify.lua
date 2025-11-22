return {
  "rcarriga/nvim-notify",
  opts = {
    stages = "fade_in_slide_out",
    timeout = 3000,
    render = "default",
  },
  config = function(_, opts)
    local notify = require("notify")
    notify.setup(opts)
    vim.notify = notify
  end,
}
