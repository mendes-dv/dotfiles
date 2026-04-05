return {
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.nvim" },
	opts = {
		render_modes = { "n", "c", "t" },
		completions = { lsp = { enabled = false } },
		heading = { icons = { "󰼏 ", "󰎨 " }, sign = false },
		paragraph = { enabled = false },
		code = { enabled = true, style = "full", border = "thin", sign = false, render_modes = { "i", "v", "V" } },
		signs = { enabled = false },
		checkbox = { 
      unchecked = { highlight = 'RenderMarkdownTodo' },
            checked = { highlight = 'RenderMarkdownTodo' },
            custom = {
              pending = { raw = '[-]', rendered = '󰥔 ', highlight = 'RenderMarkdownTodo' },
              important = { raw = '[!]', rendered = ' ', highlight = 'RenderMarkdownWarning' },
              cancel = { raw = '[/]', rendered = '󱋬 ', highlight = 'RenderMarkdownTodo' },
            },
      },
		bullet = { enabled = true },
		dash = { enabled = true },
	},
}
