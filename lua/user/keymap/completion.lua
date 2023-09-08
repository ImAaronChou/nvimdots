local formatting = require("user.configs.completion.formatting")

local mappings = {}

-- Place global keymaps here.
mappings["plug_map"] = {}

-- NOTE: This function is special! Keymaps defined here are ONLY effective in buffers with LSP(s) attached
-- NOTE: Make sure to include `:with_buffer(buf)` to limit the scope of your mappings.
---@param buf number @The effective bufnr
mappings["lsp"] = function(buf)
	return {
		-- Example
		["n|K"] = require("keymap.bind").map_cr("Lspsaga hover_doc"):with_buffer(buf):with_desc("lsp: Show doc"),
		["n|<leader>jd"] = require("keymap.bind")
			.map_cr("Lspsaga goto_definition")
			:with_buffer(buf)
			:with_desc("lsp: Goto definition"),
		-- 必须使用map_cu, 为获取visual选中内容，使用的'<' 和 '>'标志必须在visual模式结束才会生效，否则获取的是上一次visual模式的选中内容
		-- 因此使用map_cu进入命令模式就可以退出visual模式，获得当前选中代码块
		-- format 对选中的代码块有完整性要求, 如果想要达到选中任意块都可format需要做语法分析获取最小可format单元
		["nv|<leader>="] = require("keymap.bind").map_cu("FormatRange"):with_buffer(buf):with_desc("lsp: format range"),
		["nv|<leader>sw"] = require("keymap.bind")
			.map_cu("ClangdSwitchSourceHeader")
			:with_buffer(buf)
			:with_desc("switch btw h/cpp"),
	}
end

return mappings
