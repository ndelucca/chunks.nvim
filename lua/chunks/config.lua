-- Default options
local M = {
    chunks_dir = vim.fn.stdpath("config") .. "/chunks"
}

-- Creates the snippets directory if it does not exists.
--
function M:ensure_snippets_dir()
    local stat = vim.loop.fs_stat(self.chunks_dir)
    local exists = stat and stat.type == "directory"

    if not exists then
        vim.fn.mkdir(self.chunks_dir, "p")
    end
end

function M:setup(opts)
    if opts and opts.chunks_dir then
        self.chunks_dir = opts.chunks_dir
    end
    self:ensure_snippets_dir()
end

return M
