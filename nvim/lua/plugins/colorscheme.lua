return {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = function()
        require("catppuccin").setup({
            flavour = "mocha", -- latte | frappe | macchiato | mocha
            transparent_background = true,
            custom_highlights = function(colors)
                return {
                    -- Clear markdown heading highlights
                    markdownH1 = {},
                    markdownH2 = {},
                    markdownH3 = {},
                    markdownH4 = {},
                    markdownH5 = {},
                    markdownH6 = {},

                    -- Treesitter markdown headings
                    ["@markup.heading.1.markdown"] = {},
                    ["@markup.heading.2.markdown"] = {},
                    ["@markup.heading.3.markdown"] = {},
                    ["@markup.heading.4.markdown"] = {},
                    ["@markup.heading.5.markdown"] = {},
                    ["@markup.heading.6.markdown"] = {},

                    -- Ensure transparency
                    Normal = { bg = "none" },
                    NormalFloat = { bg = "none" },
                    SignColumn = { bg = "none" },
                }
            end,
        })

        vim.cmd("colorscheme catppuccin")
    end,
}

