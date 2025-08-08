return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	lazy = false,
	config = function()
		require("neo-tree").setup({
			window = {
				position = "float", -- Use floating window
				popup = {
					size = {
						height = "80%", -- You can tweak this
						width = "60%",
					},
					position = "50%", -- center of screen
				},
			},
		})
	end,
}
