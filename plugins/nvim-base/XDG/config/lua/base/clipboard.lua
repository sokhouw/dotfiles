local path = "/tmp/clipboard-" .. os.getenv("USER")
vim.cmd("cabbrev wb w! " .. path) -- copy [w]rite [b]lock
vim.cmd("cabbrev rb r " .. path) -- paste [r]ead [b]lock
