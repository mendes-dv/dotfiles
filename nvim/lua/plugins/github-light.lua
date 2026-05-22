return {
    "projekt0n/github-nvim-theme",
    name = "github-theme",
    lazy = false,
    priority = 999,
    config = function()
        require("github-theme").setup({})
    end,
}
