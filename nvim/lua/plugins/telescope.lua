return {
  {
    'nvim-telescope/telescope.nvim',
    branch = 'master',
    dependencies = { 
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-fzf-native.nvim',
    },
    config = function()
      local telescope = require('telescope')
      
      telescope.setup({
        defaults = {
          file_ignore_patterns = { "node_modules", ".git/" },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          }
        }
      })
      
      -- Load extension AFTER setup
      pcall(telescope.load_extension, 'fzf')
    end,
  }
}