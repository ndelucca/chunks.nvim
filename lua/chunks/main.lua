local Config = require("chunks.config")
local Utils = require("chunks.utils")

local M = {
    files = {}
}

-- Reads a file and returns a List of lines.
--
-- @param filepath string: Path to the snippet file
function M:read_file(filepath)
    local lines = vim.fn.readfile(filepath)
    if not lines then
        return nil, "Could not read file: " .. filepath
    end
    return lines
end

-- Write a chunk of lines in the current buffer.
--
--@param text string: Text to be written in the current buffer
function M:write_chunk_to_buffer(text)
    local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
    vim.api.nvim_buf_set_lines(0, row, row, false, text)
end

function M:main(opts)
    local fargs = assert(opts.fargs)
    local chunkname = fargs[1]

    -- TODO: Probably should be a command option rather than a general configuration
    if Config.filter_lsp then
        Config:ensure_language_chunks_dir()
        self.files = Utils.traverse_dir(Config:language_chunks_dir())
    else
        self.files = Utils.traverse_dir(Config.chunks_dir)
    end
    local chunkfile = self.files[chunkname]
    assert(chunkfile, "The snippet file " .. chunkname .. " does not exists")

    local snippet_content = assert(self:read_file(chunkfile))
    self:write_chunk_to_buffer(snippet_content)
end

return M
