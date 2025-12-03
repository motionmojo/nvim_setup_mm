-- lua/plugins/lspconfig.lua
return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "saghen/blink.cmp",
    },
    config = function()
      -- Local function to set up general LSP keymaps
      local on_attach = function(client, bufnr)
        -- Enable default format-on-save for some languages
        if client.name == "lua_ls" or client.name == "pyright" or client.name == "html" or client.name == "cssls" then
          client.server_capabilities.documentFormattingProvider = true
        end

        -- Keymaps for the current buffer
        local opts = { noremap = true, silent = true }
        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<Cmd>lua vim.lsp.buf.implementation()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<Cmd>lua vim.lsp.buf.references()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<Cmd>lua vim.lsp.buf.rename()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<Cmd>lua vim.lsp.buf.code_action()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>f', '<Cmd>lua vim.lsp.buf.format()<CR>', opts)

        -- Optional: Auto format on save
        vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.format()")
      end

      local lspconfig = require("lspconfig")

      -- Get capabilities from blink
      local capabilities = require('blink.cmp').get_lsp_capabilities()
      -- vim.lsp.enable(servers) -- This line is no longer necessary/correct here

      -- List of LSP servers to enable
      local servers = {
        "html",
        "cssls",
        "pyright",
        "omnisharp",
        "lua_ls",
        "vimls",
      }

      -- Simple setup for most servers
      for _, lsp in ipairs(servers) do
        if lsp == "omnisharp" then
          -- C# specific config
          lspconfig.omnisharp.setup({
            capabilities = capabilities,
            cmd = { "omnisharp" },
            enable_roslyn_analyzers = true,
            organize_imports_on_format = true,
            enable_import_completion = true,
            on_attach = on_attach, -- Add on_attach
          })
        elseif lsp == "lua_ls" then
          -- Lua specific config (Neovim optimized)
          lspconfig.lua_ls.setup({
            capabilities = capabilities,
            on_attach = on_attach, -- Add on_attach
            settings = {
              Lua = {
                diagnostics = {
                  globals = { "vim" },
                },
                workspace = {
                  library = {
                    vim.fn.expand("$VIMRUNTIME/lua"),
                    vim.fn.expand("$VIMRUNTIME/lua/vim/lsp"),
                    vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy",
                  },
                  maxPreload = 100000,
                  preloadFileSize = 10000,
                },
              },
            },
          })
        else
          -- Default setup for other servers
          lspconfig[lsp].setup({
            capabilities = capabilities,
            on_attach = on_attach, -- Add on_attach
          })
        end
      end

      -- GDScript LSP (requires Godot running)
      lspconfig.gdscript.setup({
        capabilities = capabilities,
        on_attach = on_attach, -- Add on_attach
        cmd = { "nc", "localhost", "6005" },
        filetypes = { "gd", "gdscript", "gdscript3" },
        root_dir = lspconfig.util.root_pattern("project.godot", ".git"),
      })

      -- Diagnostic configuration (Kept as-is)
      vim.diagnostic.config({
        virtual_text = {
          prefix = "●",
        },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = "rounded",
          source = "always",
        },
      })

      -- Diagnostic signs (Kept as-is)
      local signs = {
        Error = "✘",
        Warn = "▲",
        Hint = "⚑",
        Info = "»",
      }

      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end
    end,
  },
}