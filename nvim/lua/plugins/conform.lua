return {
  "stevearc/conform.nvim",
  opts = {
		asyn = true,
    format_on_save = {
      timeout_ms = 500,
      lsp_fallback = true,
    },
    formatters_by_ft = {
      javascript = { "prettier" },
      typescript = { "prettier" },
      json = { "prettier" },
      cs = { "csharpier" },
      csproj = {"xmlformat"}
    },
    formatters = {
      csharpier = {
       command = "csharpier",
       args = { "format" , "--write-stdout" },
       to_stdin = true,
    },
  },
  },
}

