local editor = {}

editor["ojroques/nvim-bufdel"] = {
	lazy = true,
	cmd = { "BufDel", "BufDelAll", "BufDelOthers" },
	config = require("user.configs.editor.bufdel"),
}

return editor
