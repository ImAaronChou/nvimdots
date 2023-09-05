local bind = require("keymap.bind")
local map_cr = bind.map_cr

return {
	["n|<leader>lf"] = map_cr("luafile %"):with_noremap():with_silent():with_desc("config update: luafile %"),
}
