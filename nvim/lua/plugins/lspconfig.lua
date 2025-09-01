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
		local nvim_lsp = require("lspconfig")
		local capabilities = require("cmp_nvim_lsp").default_capabilities()
		require("neodev").setup({}) -- sets up lua_ls better
		vim.api.nvim_create_autocmd("LspAttach", {
			desc = "LSP actions",
			callback = function(event)
				local opts = { buffer = event.buf }

				vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
				vim.keymap.set("n", "go", "<cmd>Telescope lsp_type_definitions<cr>", opts)
				vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
				vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
				vim.keymap.set(
					"n",
					"<leader>vd",
					"<cmd>lua vim.diagnostic.open_float()<cr>",
					{ desc = "View Diagnostics" }
				)
				-- Diagnostics
				vim.keymap.set(
					"n",
					"<leader>ed",
					"<cmd>lua vim.diagnostic.open_float()<cr>",
					{ buffer = event.buf, desc = "View Diagnostics" }
				)
				vim.keymap.set(
					"n",
					"ne",
					"<cmd>lua vim.diagnostic.goto_next()<cr>",
					{ buffer = event.buf, desc = "Next Diagnostic" }
				)
				vim.keymap.set(
					"n",
					"np",
					"<cmd>lua vim.diagnostic.goto_prev()<cr>",
					{ buffer = event.buf, desc = "Previous Diagnostic" }
				)

				-- Actions
				vim.keymap.set("n", "<leader>re", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
				vim.keymap.set({ "n", "x" }, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
				vim.keymap.set("n", "<leader>.", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
			end,
		})

		vim.lsp.config("basedpyright", {
			settings = {
				basedpyright = {
					disableOrganizeImports = true,
					analysis = {
						typeCheckingMode = "basic",
						diagnosticMode = "workspace",
						autoSearchPath = true,
					},
				},
			},
		})
		vim.lsp.config("ruff", {
			init_options = {
				settings = {
					configurationPreference = "filesystemFirst",
					fixAll = true,
					organizeImports = true,
					lint = {
						enable = true,
						preview = true,
					},
					format = {
						preview = true,
					},
				},
			},
		})

		vim.lsp.config("vtsls", {
			root_dir = nvim_lsp.util.root_pattern(
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

		-- Ensure LSP servers are installed
		require("mason-lspconfig").setup({
			ensure_installed = {
				"lua_ls",
				"ts_ls",
				"eslint",
				"vtsls",
				"jsonls",
				"html",
				"cssls",
				"gopls",
				"basedpyright",
			},
			automatic_installation = true,
			automatic_enable = true,
		})

		-- Setup handlers manually
		local servers = {
			"lua_ls",
			"ts_ls",
			"eslint",
			"jsonls",
			"html",
			"cssls",
			"gopls",
			"roslyn",
		}

		for _, lsp in ipairs(servers) do
			nvim_lsp[lsp].setup({
				capabilities = capabilities,
			})
		end
	end,
}
