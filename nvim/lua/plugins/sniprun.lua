return {
    "michaelb/sniprun",
    branch = "master",
    build = "sh install.sh",
    
    config = function()
        require("sniprun").setup({
            interpreter_options = {
                OrgMode_original = { 
                    default_filetype = 'bash'
                },
                Python3_original = {
                    interpreter = 'python3'
                },
                GDScript_original = {
                    interpreter = 'godot',
                    -- You may need to specify the full path to Godot executable
                    -- interpreter = '/path/to/godot'
                }
            }
        })
    end,
}