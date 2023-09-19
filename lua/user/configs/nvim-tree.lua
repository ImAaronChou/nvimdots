--用于指定在第几个窗口打开指定文件
local function open_file_in_specify_window(filename, num)
	-- 获取当前窗口数量
	local windows = vim.tbl_filter(function(id)
		local config = vim.api.nvim_win_get_config(id)
		local bufnr = vim.api.nvim_win_get_buf(id)
		return config and config.relative == "" or require("nvim-tree.utils").is_nvim_tree_buf(bufnr)
	end, vim.api.nvim_list_wins())

	local target_window_id = 0
	-- 如果只有一个窗口，则创建一个新的窗口并打开文件
	if #windows <= num then
		vim.api.nvim_set_current_win(windows[#windows])
		vim.api.nvim_command("vnew") -- 在右侧创建一个垂直分割的窗口
		vim.api.nvim_command("edit " .. filename) -- 使用新窗口打开文件
		require("nvim-tree.view").resize()

		target_window_id = vim.api.nvim_get_current_win()
	else
		-- 获取从左数的第二个窗口ID
		target_window_id = windows[num + 1]

		-- 将光标切换到目标窗口
		vim.api.nvim_set_current_win(target_window_id)

		-- 使用目标窗口打开文件
		vim.api.nvim_command("edit " .. filename)
	end

	local eventignore = vim.opt.eventignore:get()
	vim.opt.eventignore:append({ "BufEnter" })
	vim.api.nvim_set_current_win(target_window_id)
	vim.opt.eventignore = eventignore
end

-- 绑定keymap函数
local function my_on_attach(bufnr)
	local api = require("nvim-tree.api")

	local function opts(desc)
		return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
	end

	local function open_file_in_right_side_handle()
		local node = api.tree.get_node_under_cursor()
		if node["type"] == "file" then
			open_file_in_specify_window(node["absolute_path"], 2)
		end
	end

	local function open_file_in_left_side_handle()
		local node = api.tree.get_node_under_cursor()
		if node["type"] == "file" then
			open_file_in_specify_window(node["absolute_path"], 1)
		else
			api.node.open.edit()
		end
	end

	-- default mappings
	api.config.mappings.default_on_attach(bufnr)

	-- custom mapping
	vim.keymap.set("n", "s", open_file_in_right_side_handle, opts("Open file in right side"))
	vim.keymap.set("n", "<CR>", open_file_in_left_side_handle, opts("Open file in left side"))
	vim.keymap.set("n", "<C-n>", api.tree.close, opts("Closes the tree"))
end

--当前nvim-tree对gitignore的渲染，需要改动explore.lua里的populate_children函数，判断是否是ignore类型及加载的相关逻辑
--当前时间不够，暂时不修改源码，先在本地的.gitignore里注释需要在nvim-tree里显示的文件(如workspace的src), 后续有时间再修改

return {
	renderer = {
		highlight_git = false, --屏蔽gitignore的灰色显示
		full_name = true, --显示全名
		icons = {
			git_placement = "before", --git图标在前
		},
	},
	on_attach = my_on_attach,
}
