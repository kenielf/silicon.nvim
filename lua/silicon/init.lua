local M = {}
--

M.options = {}

M.setup = function(opts)
    M.options = vim.deepcopy(opts, true)
end

M.get_options = function(opts)
    local opts_arr = {}

    -- Parse options
    for key, value in pairs(opts) do
        local opt_str = "--" .. key
        opt_str = opt_str:gsub("_", "-")
        table.insert(opts_arr, opt_str)

        if value ~= true then
            if type(value) == string then
                table.insert(opts_arr, "'" .. value .. "'")
            else
                table.insert(opts_arr, value)
            end
        end
    end

    -- Add filetype
    table.insert(opts_arr, "--language")
    table.insert(opts_arr, vim.bo.filetype)

    -- Return
    return opts_arr
end

M.get_lines = function()
    -- Get mode
    local mode = vim.api.nvim_get_mode().mode

    -- Define starting and end lines
    local l_start
    local l_end

    -- Parse mode
    if mode == "n" then
        -- Set markers to the entire file
        l_start = 0
        l_end = -1
    elseif mode == "v" or mode == "V" then
        -- Set markers to the selected area
        l_start = vim.fn.getpos("v")[2]
        l_end = vim.api.nvim_win_get_cursor(0)[1]
        if l_start > l_end then
            local temp = l_start
            l_start = l_end
            l_end = temp
        end
    end

    local lines = vim.api.nvim_buf_get_lines(0, l_start - 1, l_end, false)

    -- Return lines
    return lines
end

M.check_command = function(cmd)
    local result = vim.fn.exepath(cmd)
    if result ~= "" then
        return true
    end
    return false
end

M.screenshot = function()
    local executable = "silicon"
    local opts = M.get_options(M.options)
    local lines = M.get_lines()

    local command = { executable, unpack(opts) }
    if M.check_command(executable) then
        local output = vim.system(command, { stdin = lines }):wait()
        if output.code ~= 0 then
            vim.notify("Command failed with code " .. output.code .. "!", vim.log.levels.ERROR)
        else
            vim.notify("Took a screenshot of the code!")
        end
    else
        vim.notify("Executable '" .. executable .. "' does not exist!", vim.log.levels.ERROR)
    end
end

--
return M
