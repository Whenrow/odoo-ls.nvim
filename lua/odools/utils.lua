local util = {}

util.path_exists = function(file)
    local ok, err, code = os.rename(file, file)
    if not ok then
        if code == 13 then
            -- Permission denied, but it exists
            return true
        end
    end
    return ok, err
end

util.get_server_path = function()
    local bin_dir_path = vim.fn.stdpath('data') .. '/odoo'
    local bin_path = bin_dir_path .. '/odoo_ls_server'
    if not util.path_exists(bin_path) then
        vim.api.nvim_out_write("[Odools] You should download the server executable\n")
    end
    return bin_path
end

---Get the user config to assert basic values
---@param conf {[string]: string}
util.check_config = function(conf)
    if not conf then
        vim.api.nvim_err_writeln("You should give a minimal configuration")
    end

    if not conf.odoo_path or type(conf.odoo_path) ~= 'string' or not util.path_exists(conf.odoo_path) then
        vim.api.nvim_err_writeln("You should give a valid odoo path")
end
    if not conf.python_path or type(conf.python_path) ~= 'string' or not util.path_exists(conf.python_path) then
        vim.api.nvim_err_writeln("You should give a valid python path")
    end
    if not conf.server_path or type(conf.server_path) ~= 'string' or not util.path_exists(conf.server_path) then
        vim.api.nvim_err_writeln("You should give a valid server path or download it")
    end
end

return util
