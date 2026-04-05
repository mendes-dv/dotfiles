return {
	"GustavEikaas/easy-dotnet.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local dotnet = require("easy-dotnet")
		dotnet.setup({
			lsp = {
				enabled = false,
			},
			external_terminal = {
				command = "tmux",
				args = { "split-window", "-h" },
			},
			debugger = {
				console = "externalTerminal",
				auto_register_dap = true,
				apply_value_converters = true,
			},
			test_runner = {
				viewmode = "float",
				auto_start_testrunner = true,
			},
			auto_bootstrap_namespace = {
				type = "block_scoped",
				enabled = true,
			},
			picker = "snacks",
			background_scanning = true,
		})

		-- Keymaps
		vim.keymap.set("n", "<leader>nr", "<cmd>Dotnet run<cr>", { desc = ".NET: Run project" })
		vim.keymap.set("n", "<leader>nq", "<cmd>Dotnet stop<cr>", { desc = ".NET: Stop project" })
		vim.keymap.set("n", "<leader>nb", "<cmd>Dotnet build<cr>", { desc = ".NET: Build" })
		vim.keymap.set("n", "<leader>nt", "<cmd>Dotnet testrunner<cr>", { desc = ".NET: Test runner" })
		vim.keymap.set("n", "<leader>ns", "<cmd>Dotnet secrets<cr>", { desc = ".NET: User secrets" })
		vim.keymap.set("n", "<leader>np", "<cmd>Dotnet project view<cr>", { desc = ".NET: Project view" })
		vim.keymap.set("n", "<leader>no", "<cmd>Dotnet outdated<cr>", { desc = ".NET: Outdated packages" })
		vim.keymap.set("n", "<leader>cL", vim.lsp.codelens.run, { desc = "Run CodeLens" })
	end,
}
