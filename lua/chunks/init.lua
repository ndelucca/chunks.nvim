local Chunks = require("chunks.main")
local Config = require("chunks.config")

local M = {}

M.setup = function()
    Config:setup()
    vim.api.nvim_create_user_command('Chunks', function(opts)
        return Chunks:main(opts)
    end, {
        nargs = "+",
    })
end

return M
