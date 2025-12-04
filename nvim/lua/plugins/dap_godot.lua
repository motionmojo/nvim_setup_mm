return {
  {
    "neovim/nvim-lspconfig",

    dependencies = {
      "Byte-Labs-Project/gdscript-extended-lsp.nvim",
      "neovim/nvim-treesitter",
      "hrsh7th/nvim-cmp",
      "L3MON4D3/LuaSnip",
    },

    ft = { "gdscript", "godot_resource" },

    config = function()
      local is_windows = vim.fn.has("win32") == 1
      local lspconfig = require("lspconfig")

      --------------------------------------------------------------------
      -- 1. Setup gdscript-extended-lsp
      --------------------------------------------------------------------
      require("gdscript_extended_lsp").setup({
        lsp = {
          enable = true,
          port = 6005,
          bin = "nc", -- On Windows this becomes ncat automatically
        },
      })

      --------------------------------------------------------------------
      -- 2. Godot LSP Setup
      --------------------------------------------------------------------
      local capabilities = vim.lsp.protocol.make_client_capabilities()

      lspconfig.gdscript.setup({
        capabilities = capabilities,
        on_attach = function(_, bufnr)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr })
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr })
          vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = bufnr })
        end,
      })

      --------------------------------------------------------------------
      -- 3. CMP Setup
      --------------------------------------------------------------------
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-y>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_next_item()
            else fallback()
            end
          end, { "i", "s" }),
        }),
        sources = {
          { name = "nvim_lsp" },
        },
      })

      --------------------------------------------------------------------
      -- 4. Treesitter Setup
      --------------------------------------------------------------------
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "lua",
          "vim",
          "gdscript",
          "godot_resource",
        },
        highlight = { enable = true },
        indent = { enable = true },
      })

      --------------------------------------------------------------------
      -- 5. Neovim <-> Godot external editor bridge
      --------------------------------------------------------------------
      if vim.fn.filereadable(vim.fn.getcwd() .. "/project.godot") == 1 then
        if is_windows then
          vim.fn.serverstart("127.0.0.1:6005")
        else
          vim.fn.serverstart("./godot.pipe")
        end
      end
    end,
  },
}
