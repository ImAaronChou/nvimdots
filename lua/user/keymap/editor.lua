local bind = require("keymap.bind")
local map_cr = bind.map_cr

return {
	["n|<S-h>"] = map_cr("bp"):with_noremap():with_silent():with_desc("tab: Create a new tab"),
	["n|<S-l>"] = map_cr("bn"):with_noremap():with_silent():with_desc("tab: Create a new tab"),
	["n|<S-q>"] = map_cr("BufDel"):with_noremap():with_silent():with_desc("tab: Create a new tab"),
}
