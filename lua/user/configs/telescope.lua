return {
	defaults = {
		mappings = {
			n = {
				["<C-j>"] = require("telescope.actions").move_selection_next,
				["<C-k>"] = require("telescope.actions").move_selection_previous,
			},
			i = {
				["<C-j>"] = require("telescope.actions").move_selection_next,
				["<C-k>"] = require("telescope.actions").move_selection_previous,
			},
		},
	},
	extensions = {
		live_grep_args = {
			mappings = { -- extend mappings
				i = {
					["<C-k>"] = require("telescope.actions").move_selection_previous,
				},
			},
		},
	},
}
