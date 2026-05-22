return {
    "f-person/auto-dark-mode.nvim",
    lazy = false,
    priority = 1001,
    opts = {
        update_interval = 3000,
        set_dark_mode = function()
            vim.o.background = "dark"
            pcall(vim.cmd.colorscheme, "catppuccin")
        end,
        set_light_mode = function()
            vim.o.background = "light"
            pcall(vim.cmd.colorscheme, "github_light_high_contrast")
        end,
    },
}
