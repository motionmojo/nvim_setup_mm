return   -- Mason for easy LSP/DAP/formatter installation
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        -- LSP servers
        "pyright",
        "omnisharp",
        "lua-language-server",
        "vim-language-server",
        
        -- Formatters
        "black",
        "isort",
        "stylua",
        "csharpier",
        
        -- Linters
        "ruff",
        
        -- DAP
        "debugpy",
        "netcoredbg",
      },
    },
  }