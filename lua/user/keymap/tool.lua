local bind = require("keymap.bind")
local map_callback = bind.map_callback
local map_cu = bind.map_cu

--打开nvimtree的函数
--有别于原有NvimTreeFocus, 当只有一个blank buffer时，会打开tree后再创建一个blank buffer并刷新窗口大小
--写该函数的原因是因为nvimtree有bug, 无法很好解决初次打开的问题，该问题在nerdtree中不存在
function FocusNvimTree()
	local buffers = vim.api.nvim_list_bufs()
	local only_blank = #buffers == 1 and vim.api.nvim_buf_get_name(buffers[1]) == ""

	if only_blank then
		-- 创建新的空白缓冲区
		local buf = vim.api.nvim_create_buf(false, true)
		-- 将新缓冲区放置在右侧
		vim.api.nvim_command("vert rightbelow sb " .. buf)
	end

	require("nvim-tree.api").tree.focus()
end

return {
	["n|<C-n>"] = map_callback(FocusNvimTree):with_noremap():with_silent():with_desc("filetree: Toggle"),
	["n|<C-p>"] = map_cu("Telescope find_files"):with_noremap():with_silent():with_desc("find: File in project"),
	["n|<leader>p"] = map_callback(function()
			_command_panel()
		end)
		:with_noremap()
		:with_silent()
		:with_desc("tool: Toggle command panel"),
}
