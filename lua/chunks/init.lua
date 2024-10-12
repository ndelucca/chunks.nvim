-- Returns the plugin snippets directory.
local chunks_config_dir = function()
    return vim.fn.stdpath("config") .. "/chunks"
end

-- Creates the snippets directory if it does not exists.
--
-- @param config_dir string: Path to the users neovim configuration directory.
local ensure_snippets_dir = function(config_dir)
    local stat = vim.loop.fs_stat(config_dir)
    local exists = stat and stat.type == "directory"

    if not exists then
        vim.fn.mkdir(config_dir, "p")
    end
end

-- Reads a file and returns a List of lines.
--
-- @param filepath string: Path to the snippet file
local read_file = function(filepath)
    local lines = vim.fn.readfile(filepath)
    if not lines then
        return nil, "Could not read file: " .. filepath
    end
    return lines
end

-- Write a chunk of lines in the current buffer.
--
--@param text string: Text to be written in the current buffer
local write_text = function(text)
    local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
    vim.api.nvim_buf_set_lines(0, row, row, false, text)
end

local main = function(opts)
    ensure_snippets_dir(chunks_config_dir())
    local fargs = opts.fargs
    local snippet_path = chunks_config_dir() .. "/" .. fargs[1]

    local stat = vim.loop.fs_stat(snippet_path)
    assert(stat, "The snippet file " .. snippet_path .. " does not exists")

    local snippet_content = assert(read_file(snippet_path))
    write_text(snippet_content)
end

local setup = function()
    vim.api.nvim_create_user_command('Chunks', main, {
        nargs = "+",
    })
end

return { setup = setup }
