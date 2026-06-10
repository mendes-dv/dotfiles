return {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        enable = true,
        max_lines = 3,
        min_window_height = 20,
        trim_scope = "outer",
        mode = "cursor",
        separator = nil,
    },
    keys = {
        {
            "<leader>uc",
            function()
                require("treesitter-context").toggle()
            end,
            desc = "Toggle Treesitter Context",
        },
    },
}
