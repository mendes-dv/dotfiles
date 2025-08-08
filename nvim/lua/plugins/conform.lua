return {
	"stevearc/conform.nvim",
	opts = {
		asyn = true,
		format_on_save = {
			timeout_ms = 1000,
			lsp_fallback = true,
		},
		formatters_by_ft = {
			lua = { "stylua" },
			javascript = { "prettierd" },
			typescript = { "prettierd" },
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
				to_stdin = true,
			},
			ruff_format = {
				command = "ruff",
				args = { "format", "-" },
				stdin = true,
			},
		},
	},
}
