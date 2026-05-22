return {
    "oribarilan/lensline.nvim",
    branch = "release/2.x",
    event = "LspAttach",
    config = function()
        require("lensline").setup({
            limits = {
                -- For C# we use Roslyn's native LSP code lens (set up in
                -- plugins/roslyn.lua + lspconfig LspAttach), which gives the
                -- same accurate reference counts Rider/VS show. Keep lensline
                -- out of cs files so the two don't render side-by-side.
                exclude_append = { "*.cs" },
                exclude_gitignored = true,
            },
        })
    end,
}
