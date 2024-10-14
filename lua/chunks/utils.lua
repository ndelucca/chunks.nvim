local M = {}
local files = {}

-- Reads and chaches all available files in a directory
--
-- @param basepath string: base directory
local function traverse_dir(basepath)
    for _, name in ipairs(vim.fn.readdir(basepath)) do
        local filepath = basepath .. "/" .. name
        if vim.fn.isdirectory(filepath) ~= 0 then
            traverse_dir(filepath)
        else
            files[name] = filepath
        end
    end
end

M.traverse_dir = function(path)
    traverse_dir(path)
    return files
end

return M
