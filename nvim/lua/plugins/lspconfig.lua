return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },
    { "folke/neodev.nvim", opts = {} },
  },
  config = function()
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    require("neodev").setup({}) -- Better setup for lua_ls

    -- Attach keymaps
    vim.api.nvim_create_autocmd("LspAttach", {
      desc = "LSP actions",
      callback = function(event)
        local opts = { buffer = event.buf }

        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "go", "<cmd>Telescope lsp_type_definitions<cr>", opts)
        vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, opts)
        vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, { desc = "View Diagnostics" })
        vim.keymap.set("n", "<leader>ed", vim.diagnostic.open_float, { buffer = event.buf, desc = "View Diagnostics" })
        vim.keymap.set("n", "<leader>ne", vim.diagnostic.goto_next, { buffer = event.buf, desc = "Next Diagnostic" })
        vim.keymap.set("n", "<leader>np", vim.diagnostic.goto_prev, { buffer = event.buf, desc = "Previous Diagnostic" })
        vim.keymap.set("n", "<leader>re", vim.lsp.buf.rename, opts)
        vim.keymap.set({ "n", "x" }, "<F3>", function() vim.lsp.buf.format({ async = true }) end, opts)
        vim.keymap.set("n", "<leader>.", vim.lsp.buf.code_action, opts)
      end,
    })

    -- Modern LSP config using vim.lsp.config
    vim.lsp.config("pylsp", {
      capabilities = capabilities,
      settings = {
        pylsp = {
          plugins = {
            pycodestyle = { enabled = false },
            pyflakes = { enabled = false },
            mccabe = { enabled = false },
            pylint = { enabled = false },
            yapf = { enabled = false },
            black = { enabled = false },
            autopep8 = { enabled = false },
            ruff = { enabled = true }, -- use ruff-lsp instead
            pylsp_mypy = { enabled = true, live_mode = false },
          },
        },
      },
    })

    vim.lsp.config("vtsls", {
      capabilities = capabilities,
      root_dir = require("lspconfig.util").root_pattern(
        ".git",
        "pnpm-workspace.yaml",
        "pnpm-lock.yaml",
        "yarn.lock",
        "package-lock.json",
        "bun.lockb"
      ),
      typescript = {
        tsserver = {
          maxTsServerMemory = 12288,
        },
      },
      experimental = {
        completion = {
          entriesLimit = 3,
        },
      },
    })

    -- Setup Mason to ensure LSPs are installed
    require("mason-lspconfig").setup({
      ensure_installed = {
        "lua_ls",
        "ts_ls", -- NOTE: not `ts_ls`, check spelling
        "eslint",
        "vtsls",
        "jsonls",
        "html",
        "cssls",
        "gopls",
        "pylsp",
      },
      automatic_installation = true,
      automatic_enable = true,
    })

    -- Setup standard LSPs
    local basic_servers = {
      "lua_ls",
      "tsserver",
      "eslint",
      "jsonls",
      "html",
      "cssls",
      "gopls",
    }

    for _, lsp in ipairs(basic_servers) do
      vim.lsp.config(lsp, {
        capabilities = capabilities,
      })
    end
  end,
}


