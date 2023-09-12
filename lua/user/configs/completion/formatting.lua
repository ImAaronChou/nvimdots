--当前该文件暂时废弃，直接使用\=快捷键做全局格式化
--当前的选中格式化无法自动获得最小语法单元，因此如果未框选最小语法单元，不会进行格式化，所以暂时直接用全局格式化替换
local settings = require("core.settings")
local format_notify = settings.format_notify

local M = {}

vim.api.nvim_create_user_command("FormatRange", function()
	M.format_range({ timeout_ms = 1000 })
end, {})

--该函数原本想通过treesitter获取最小语法单元，但为尝试成功，当前保留中间代码，通过nvim-treesitter写稍微复杂点应该仍能实现选中块format
-- local function GetSelectedRows()
-- 	return { start_row = vim.api.nvim_buf_get_mark(0, "<")[1], vim.api.nvim_buf_get_mark(0, ">")[1] }
-- end

-- local function GetTSNode(st_row, ed_row)
-- 	local bufnr = vim.api.nvim_get_current_buf() -- 获取当前缓冲区号
-- 	-- 解析当前缓冲区的语法树
-- 	local syntax_tree = vim.treesitter.get_parser(bufnr):parse()

-- 	-- 获取语法树的根节点
-- 	local root_node = syntax_tree:root()

-- 	-- 获取行号对应的范围
-- 	local selected_range = {
-- 		start_row = st_row - 1, -- 行号从 0 开始，需要减去 1
-- 		end_row = ed_row - 1,
-- 		start_col = 0,
-- 		end_col = -1, -- 结束列设为 -1 表示到行尾
-- 	}
-- 	local selected_node = root_node:descendant_for_range(selected_range)
-- 	local node_range = selected_node:range()

-- 	return { start_row = node_range.start.row + 1, end_row = node_range.end.row + 1 }
-- end

function M.format_range(opts)
	local bufnr = opts.bufnr or vim.api.nvim_get_current_buf()
	local clients = vim.lsp.buf_get_clients(bufnr)
	clients = vim.tbl_filter(function(client)
		return client.supports_method("textDocument/rangeFormatting") and client.name == "null-ls"
	end, clients)

	if #clients == 0 then
		vim.notify(
			"[LSP] Format request failed, no matching language servers.",
			vim.log.levels.WARN,
			{ title = "Formatting Failed" }
		)
	end

	--取当前行+上一行，才可format当前行
	--结束行需要涵盖整个语法单元才会触发format, 当前formatter不支持行号找语法单元,因此暂不支持该功能
	local selected_st_row = math.max(vim.api.nvim_buf_get_mark(0, "<")[1] - 1, 1)
	local selected_ed_row = vim.api.nvim_buf_get_mark(0, ">")[1]

	local range = {
		["start"] = {
			line = selected_st_row,
			character = 0,
		},
		["end"] = {
			line = selected_ed_row,
			character = 0,
		},
	}

	local timeout_ms = opts.timeout_ms
	for _, client in pairs(clients) do
		local params = vim.lsp.util.make_formatting_params(opts.formatting_options)
		params.range = range
		local result, err = client.request_sync("textDocument/rangeFormatting", params, timeout_ms, bufnr)

		if result and result.result then
			vim.lsp.util.apply_text_edits(result.result, bufnr, client.offset_encoding)
			if format_notify then
				vim.notify(
					string.format("[LSP] Format successfully with %s!", client.name),
					vim.log.levels.INFO,
					{ title = "LSP Format Success" }
				)
			end
		elseif err then
			vim.notify(
				string.format("[LSP][%s] %s", client.name, err),
				vim.log.levels.ERROR,
				{ title = "LSP Format Error" }
			)
		end
	end
end

return M
