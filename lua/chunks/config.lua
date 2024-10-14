-- Default options
local M = {
    chunks_dir = vim.fs.joinpath(vim.fn.stdpath("config"), "/chunks"),
    filter_lsp = true,

}

function M:language_chunks_dir()
    local language = vim.api.nvim_get_option_value('filetype', { buf = 0 })
    return vim.fs.joinpath(M.chunks_dir, "/", language)
end

-- Creates the snippets directory if it does not exists.
--
function M:ensure_chunks_dir()
    local stat = vim.loop.fs_stat(self.chunks_dir)
    local exists = stat and stat.type == "directory"
    if not exists then
        vim.fn.mkdir(self.chunks_dir, "p")
    end
end

function M:ensure_language_chunks_dir()
    local stat = vim.loop.fs_stat(self:language_chunks_dir())
    local exists = stat and stat.type == "directory"
    if self.filter_lsp and not exists then
        vim.fn.mkdir(self:language_chunks_dir(), "p")
    end
end

function M:setup(opts)
    if not opts then
        opts = {}
    end

    for key, val in ipairs(opts) do
        self[key] = val
    end

    self:ensure_chunks_dir()
end

return M
