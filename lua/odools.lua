local M = {}
local lsp_config = require('lspconfig.configs')

if not lsp_config then
    error("lsp_config not available")
    return
end

local dir_exists = function(file)
    local ok, err, code = os.rename(file, file)
    if not ok then
        if code == 13 then
            -- Permission denied, but it exists
            return true
        end
    end
    return ok, err
end

---Get the user config to assert basic values
---@param conf {[string]: string}
local check_config = function(conf)
    if not conf then
        error("You should give a minimal configuration")
    end

    if not conf.odoo_path or type(conf.odoo_path) ~= 'string' or not dir_exists(conf.odoo_path) then
        error("You should give a valid odoo path")
    end
    if not conf.python_path or type(conf.python_path) ~= 'string' or not dir_exists(conf.python_path) then
        error("You should give a valid python path")
    end
    if not conf.server_path or type(conf.server_path) ~= 'string' or not dir_exists(conf.server_path) then
        error("You should give a valid server path")
    end
end

M.setup = function(opt)
    opt = opt or {}
    opt.python_path = opt.python_path or '/usr/bin/python3'
    check_config(opt)
    local odoo_path = opt.odoo_path
    opt.root = opt.root or odoo_path
    local odooConfig = {
        id = 1,
        name = "main config",
        validatedAddonsPaths = opt.addons or {},
        addons = opt.addons or {},
        odooPath = odoo_path,
        pythonPath = opt.python_path,
        additional_stubs = opt.additional_stubs or {},
    }
    local server_path = opt.server_path
    lsp_config.odools = {
        default_config = {
            name = 'odools',
            cmd = {server_path},
            root_dir = function() return vim.fn.fnamemodify(opt.server_path, ":h") end,
            workspace_folders = {
                {
                    uri = function() return opt.root end,
                    name = function() return "base_workspace" end,
                },
            },
            filetypes = { 'python' },
            settings = {
                Odoo = {
                    autoRefresh = opt.settings and opt.settings.autoRefresh or true,
                    autoRefreshDelay = opt.settings and opt.settings.autoRefreshDelay or nil,
                    diagMissingImportLevel = opt.settings and opt.settings.diagMissingImportLevel or "none",
                    configurations = { mainConfig = odooConfig },
                    selectedConfiguration = "mainConfig",
                },
            },
            capabilities = {
                textDocument = {
                    workspace = {
                        symbol = {
                            dynamicRegistration = true,
                        },
                    },
                },
            },
        },
    }
    lsp_config.odools.setup {}
end
return M
