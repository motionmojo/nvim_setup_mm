  return {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim", "lua", "vimdoc",
        "html", "css",
        "python", "c_sharp", "gdscript",
        "bash", "json", "yaml", "markdown",
      },
    },
  }