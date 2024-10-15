local Chunks = require("chunks.main")
local Config = require("chunks.config")

local M = {}

M.setup = function()
    Config:setup()
    vim.keymap.set("i", "<C-s>", function() Chunks:trigger_completions() end, { noremap = true })
end

return M
