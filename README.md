# Odools x Neovim

Neovim client for the [Odools](https://github.com/odoo/odoo-ls) language server

![screenshot](https://i.imgur.com/wuqsF9q.png)

## Important ⚠️
This plugin is still in its early development stage. Don't hesitate to submit bugs, issues and/or
feedbacks to improve the user experience.

## Installation
### requirement
We recommend using nvim version `0.9.0` or later. This plugin is using
[lspconfig](https://github.com/neovim/nvim-lspconfig) to connect communicate with the language
server in your beloved editor.

### downloads
 1. Install the plugin

Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  'whenrow/odoo-ls.nvim',
   requires = { {'neovim/nvim-lspconfig'} }
}
```

Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
-- init.lua:
    {
    'whenrow/odoo-ls.nvim',
    dependencies = { 'neovim/nvim-lspconfig' }
    }

-- plugins/odoo.lua:
return {
    'whenrow/odoo-ls.nvim',
      dependencies = { 'neovim/nvim-lspconfig' }
    }
```

 2. Download the server executable from the release assets
 ```bash
 wget -O ~/.local/share/nvim/odoo/odoo_ls_server https://github.com/odoo/odoo-ls/releases/download/0.4.0/odoo_ls_server
 ```

 3. downloads python [typeshed](https://github.com/python/typeshed) to enrich the server with builtin python package stubs

 (2. and 3. can be done automatically via the `Odools` [command](https://github.com/Whenrow/odoo-ls.nvim#usage))


## Configuration
The plugin needs different local path and executable to be working. Here is the mandatory config
keys.

```lua
local odools = require('odools')
local h = os.getenv('HOME')
odools.setup({
    -- mandatory
    odoo_path = h .. "/src/odoo/",
    python_path = h .. "/.pyenv/shims/python3",

    -- optional
    server_path = h .. "/.local/share/nvim/odoo/odoo_ls_server",
    addons = {h .. "/src/enterprise/"},
    additional_stubs = {h .. "/src/additional_stubs/", h .. "/src/typeshed/stubs"},
    root_dir = h .. "/src/", -- working directory, odoo_path if empty
    settings = {
        autoRefresh = true,
        autoRefreshDelay = nil,
        diagMissingImportLevel = "none",
    },
})
```

## Usage
Try the command `:Odools install` to fetch the language server executable from Github as well as the
python typesheds

