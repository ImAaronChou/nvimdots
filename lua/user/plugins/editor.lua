local editor = {}

editor["ojroques/nvim-bufdel"] = {
	lazy = true,
	cmd = { "BufDel", "BufDelAll", "BufDelOthers" },
	config = require("user.configs.editor.bufdel"),
}
editor["danymat/neogen"] = {
	lazy = true,
	dependencies = "nvim-treesitter/nvim-treesitter",
	config = require("user.configs.editor.neogen"),
	event = { "CursorMoved", "InsertEnter" },
}

return editor
