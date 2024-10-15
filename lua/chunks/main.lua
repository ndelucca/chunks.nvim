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

-- Reads all snippet files available
function M:fetch_snippets()
    -- TODO: Probably should be a command option rather than a general configuration
    if Config.filter_lsp then
        Config:ensure_language_chunks_dir()
        self.files = Utils.traverse_dir(Config:language_chunks_dir())
    else
        self.files = Utils.traverse_dir(Config.chunks_dir)
    end

    assert(self.files, "No files available")

    return self.files
end

-- Reads the contents of a chunk file
--
-- @param chunkname string: Path to a text file
function M:fetch_snippet_content(chunkname)
    local chunkfile = self.files[chunkname]
    assert(chunkfile, "The snippet file " .. chunkname .. " does not exists")

    local snippet_content = assert(self:read_file(chunkfile))
    return table.concat(snippet_content, "\n")
end

-- Locates the cursor in insert mode and presents a completion list with all available chunks
function M:trigger_completions()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local files = self:fetch_snippets()
    local completion_options = {}

    for name in pairs(files) do
        table.insert(completion_options, { word = self:fetch_snippet_content(name), abbr = name })
    end

    vim.fn.complete(col + 1, completion_options)
end

return M
