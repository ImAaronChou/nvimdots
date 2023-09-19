local tool = {}

tool["nvim-tree/nvim-tree.lua"] = {
	cmd = {
		"NvimTreeFocus",
	},
	filters = {
		exclude = { "src/" },
	},
}

tool["nvim-telescope/telescope.nvim"] = {
	dependencies = {
		{
			"nvim-telescope/telescope-file-browser.nvim",
			dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
		},
	},
}

return tool
