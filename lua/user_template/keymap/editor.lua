local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_cmd = bind.map_cmd

return {
	["n|<S-h>"] = map_cr("bp"):with_noremap():with_silent():with_desc("tab: Create a new tab"),
	["n|<S-l>"] = map_cr("bn"):with_noremap():with_silent():with_desc("tab: Create a new tab"),
	["n|<S-q>"] = map_cr("BufDel"):with_noremap():with_silent():with_desc("tab: Create a new tab"),
	["nv|<leader>cc"] = map_cmd("<Plug>(comment_toggle_linewise_visual)")
		:with_silent()
		:with_noremap()
		:with_desc("edit: Toggle comment for line with selection"),
}
