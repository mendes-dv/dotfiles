return {
	"stevearc/conform.nvim",
	dependencies = { "mason.nvim" },
	event = { "BufWritePre" },
	keys = {
		{
			"<leader>cf",
			function()
				require("conform").format({ async = true })
			end,
			mode = "",
			desc = "Format buffer",
		},
	},
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				lua = { "stylua" },
				javascript = { "prettierd" },
				javascriptreact = { "prettierd" },
				typescript = { "prettierd" },
				typescriptreact = { "prettierd" },
				json = { "prettierd" },
				yaml = { "prettierd" },
				markdown = { "prettierd" },
				html = { "prettierd" },
				cs = { "csharpier" },
				csproj = { "xmlformat" },
				python = { "ruff_format" },
			},
			formatters = {
				csharpier = {
					command = "csharpier",
					args = { "format", "--write-stdout" },
				},
				ruff_format = {
					command = "ruff",
					args = { "format", "-" },
					stdin = true,
				},
			},
		})
	end,
}
