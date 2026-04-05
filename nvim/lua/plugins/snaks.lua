return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		bigfile = { enabled = true },
		dim = { enabled = true },
		indent = { enabled = true },
		dashboard = {
			enabled = true,
			preset = {
				header = [[
  ██████╗ ███╗   ███╗ ██████╗
 ██╔════╝ ████╗ ████║██╔═══██╗
 ██║  ███╗██╔████╔██║██║   ██║
 ██║   ██║██║╚██╔╝██║██║   ██║
 ╚██████╔╝██║ ╚═╝ ██║╚██████╔╝
  ╚═════╝ ╚═╝     ╚═╝ ╚═════╝ ]],
			},
		},
		gitbrowse = { enabled = true },
		input = { enabled = true },
		notifier = { enabled = true },
		quickfile = { enabled = true },
		rename = { enabled = true },
		scope = { enabled = true },
		scroll = { enabled = true },
		statuscolumn = { enabled = true },
		words = { enabled = true },
		explorer = { enabled = true },
		image = { enabled = true },
		zen = { enabled = true },
		picker = {
			enabled = true,
			sources = {
				explorer = {
					auto_close = true,
					reverse = true,
					layout = {
						preview = true,
						layout = {
							position = "float",
							height = 0.8,
							width = 0.8,
							border = "rounded",
							box = "horizontal",
							{
								box = "vertical",
								{ win = "list", title = " Results ", title_pos = "center", border = "rounded" },
								{
									win = "input",
									height = 1,
									border = "rounded",
									title = "{title} {live} {flags}",
									title_pos = "center",
								},
							},
							{
								win = "preview",
								title = "{preview:Preview}",
								width = 0.45,
								border = "rounded",
								title_pos = "center",
							},
							-- if you turned preview=true above, also add:
							-- { win = "preview", width = 0, border = "left" },
						},
					},
				},
			},
		},
	},
	keys = {
		{
			"<leader>gg",
			function()
				Snacks.lazygit()
			end,
			desc = "Lazygit",
		},

		{
			"<C-e>",
			function()
				Snacks.explorer()
			end,
			desc = "Explorer (float)",
		},
    { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
    { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
    { "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep" },
    { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
		{
			"<leader>ff",
			function()
				Snacks.picker.files()
			end,
			desc = "Find Files",
		},
		{
			"<leader>fb",
			function()
        Snacks.picker.buffers()
      end,
      desc = "Buffers"
		},
    { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
    { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
		{
			"<leader>fs",
			function()
				Snacks.picker.git_files()
			end,
			desc = "Find Git Files",
		},
		--Git
		{
			"<leader>gb",
			function()
				Snacks.picker.git_branches()
			end,
			desc = "Git Branches",
		},
		{
			"<leader>gl",
			function()
				Snacks.picker.git_log()
			end,
			desc = "Git Log",
		},
		{
			"<leader>gL",
			function()
				Snacks.picker.git_log_line()
			end,
			desc = "Git Log Line",
		},
		{
			"<leader>gs",
			function()
				Snacks.picker.git_status()
			end,
			desc = "Git Status",
		},
		{
			"<leader>gd",
			function()
				Snacks.picker.git_diff()
			end,
			desc = "Git Diff (Hunks)",
		},
		{
			"<leader>gf",
			function()
				Snacks.picker.git_log_file()
			end,
			desc = "Git Log File",
		},
		{
			"gd",
			function()
				Snacks.picker.lsp_definitions()
			end,
			desc = "Goto Definition",
		},
		{
			"gD",
			function()
				Snacks.picker.lsp_declarations()
			end,
			desc = "Goto Declaration",
		},
		{
			"gr",
			function()
				Snacks.picker.lsp_references()
			end,
			nowait = true,
			desc = "References",
		},
		{
			"gi",
			function()
				Snacks.picker.lsp_implementations()
			end,
			desc = "Goto Implementation",
		},
		{
			"gy",
			function()
				Snacks.picker.lsp_type_definitions()
			end,
			desc = "Goto T[y]pe Definition",
		},
		{
			"<leader>ss",
			function()
				Snacks.picker.lsp_symbols()
			end,
			desc = "LSP Symbols",
		},
		{
			"<leader>sS",
			function()
				Snacks.picker.lsp_workspace_symbols()
			end,
			desc = "LSP Workspace Symbols",
		},
		{
			"<F12>",
			function()
				Snacks.terminal()
			end,
			desc = "which_key_ignore",
		},
		{ "<leader>gB", function() Snacks.gitbrowse() end, desc = "Open in GitHub" },
		{ "<leader>z", function() Snacks.zen() end, desc = "Zen Mode" },
		{ "<leader>D", function() Snacks.dim() end, desc = "Dim" },
		{ "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File" },
	},
}

