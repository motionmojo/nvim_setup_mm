return {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    config = function()
        require("neo-tree").setup({
            filesystem = {
                filtered_items = {
                    visible = false,  -- Hide filtered items by default
                    hide_dotfiles = false,  -- Keep showing .gitignore, etc.
                    hide_gitignored = false,
                    hide_hidden = true,  -- Hide hidden files (Windows)
                    hide_by_name = {
                        ".git",
                        ".DS_Store",
                        "thumbs.db",
                    },
                    hide_by_pattern = {
                        "*.gd.uid",      -- Hide all .gd.uid files
                        "*.import",      -- Also hide Godot import files
                        "*.remap",       -- Hide remap files
                    },
                    never_show = {
                        ".git",
                        ".godot",        -- Hide Godot's internal folder
                    },
                },
            },
        })
    end,
}