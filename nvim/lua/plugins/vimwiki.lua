return {
  "vimwiki/vimwiki",
  -- The event that triggers the plugin
  event = "BufEnter *.md",
  -- The keys that trigger the plugin
  keys = { "<leader>ww", "<leader>wt" },
  -- The configuration for the plugin
  init = function()
    vim.g.vimwiki_list = {
      {
        -- Here will be the path for your wiki
        path = "~/vimwiki/",
        -- The syntax for the wiki
        syntax = "markdown",
        ext = "md",
      },
    }
    vim.g.vimwiki_ext2syntax = { }
  end,
}
