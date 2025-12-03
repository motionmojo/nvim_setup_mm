-- bootstrap lazy.nvim, LazyVim and your plugins
-- Can't add 'gdscript' to servers because it is not listed in Mason. So :MasonInstall gdscript won't work

require("config.lazy")
-- In your init.lua
vim.keymap.set('n', '<BS>', '<C-w>h', { desc = 'Move to left window' })
vim.keymap.set('n', '<C-n>', '<Cmd>Neotree toggle<CR>', { desc = 'Toggle Neo-tree' })
--- 1. Godot LSP Configuration (gdscript) ---
local lspconfig = require("lspconfig")
local capabilities = vim.lsp.protocol.make_client_capabilities()
local on_attach = function(_, bufnr)
    -- You can add keymaps here that are specific to LSP-enabled buffers
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "LSP: Hover Documentation" })
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "LSP: Go to Definition" })
    vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = bufnr, desc = "LSP: Find References" })
end

local gdscript_config = {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {},
}
if is_windows then
    -- Windows specific. Requires ncat installed (`winget install nmap`)
    gdscript_config["cmd"] = { "ncat", "localhost", os.getenv("GDScript_Port") or "6005" }
end
lspconfig.gdscript.setup(gdscript_config)

local function find_godot_project_root()
    local cwd = vim.fn.getcwd()
    local search_paths = { '', '/..' }
    
    for _, relative_path in ipairs(search_paths) do
        local project_file = cwd .. relative_path .. '/project.godot'
        if vim.uv.fs_stat(project_file) then
            return cwd .. relative_path
        end
    end
    
    return nil
end

