return {
  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
      require("mason").setup()

      require("mason-lspconfig").setup({
        automatic_installation = true,
        ensure_installed = {
          "cssls",
          "eslint",
          "html",
          "jsonls",
          "tsserver",
          "pyright",
          "tailwindcss",
        },
      })

      require("mason-tool-installer").setup({
        ensure_installed = {
          "prettier",
          "stylua",
          "isort",
          "black",
          "pylint",
          "eslint_d",
        },
      })
    end,
  },

  -- ──────────────────────────────────────────────────────────────────────────────
  -- nvim-lspconfig itself (wire up all the servers you just installed)
  {
    "neovim/nvim-lspconfig",
    -- make sure it loads after mason-lspconfig
    dependencies = { "williamboman/mason-lspconfig.nvim" },
    config = function()
      -- load default settings from any plugin you already have
      require("config.lspconfig")
    end,
  },
}

