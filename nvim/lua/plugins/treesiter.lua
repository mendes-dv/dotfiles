return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = function()
        require("nvim-treesitter").update()
    end,
    dependencies = {
        "windwp/nvim-ts-autotag",
    },
    config = function()
        require("nvim-treesitter").setup({})

        require("nvim-treesitter").install({
            "json",
            "javascript",
            "typescript",
            "tsx",
            "svelte",
            "yaml",
            "html",
            "css",
            "markdown",
            "markdown_inline",
            "bash",
            "lua",
            "vim",
            "vimdoc",
            "dockerfile",
            "gitignore",
            "c",
            "rust",
            "c_sharp",
        })

        local disabled_highlight = { markdown = true }
        -- Languages without a working treesitter indents.scm — let their
        -- ftplugin (or LSP on-type formatting) own indentation instead.
        local disabled_indent = { cs = true }

        vim.api.nvim_create_autocmd("FileType", {
            callback = function(args)
                if disabled_highlight[args.match] then return end
                local ok = pcall(vim.treesitter.start, args.buf)
                if ok and not disabled_indent[args.match] then
                    pcall(function()
                        vim.bo[args.buf].indentexpr =
                            "v:lua.require'nvim-treesitter'.indentexpr()"
                    end)
                end
            end,
        })

        require("nvim-ts-autotag").setup({})
    end,
}
