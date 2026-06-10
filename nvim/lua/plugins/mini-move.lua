return {
    "echasnovski/mini.move",
    version = "*",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        mappings = {
            -- Visual mode (move selected blocks)
            left  = "<M-h>",
            right = "<M-l>",
            down  = "J",
            up    = "K",
            -- Normal mode (move current line)
            line_left  = "<M-h>",
            line_right = "<M-l>",
            line_down  = "<M-j>",
            line_up    = "<M-k>",
        },
    },
}
