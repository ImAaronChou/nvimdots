function ts_select_dir_for_grep(prompt_bufnr)
	local action_state = require("telescope.actions.state")
	local fb = require("telescope").extensions.file_browser
	local live_grep = require("telescope").extensions.live_grep_args.live_grep_args
	local current_line = action_state.get_current_line()

	fb.file_browser({
		files = false,
		depth = false,
		attach_mappings = function(prompt_bufnr)
			require("telescope.actions").select_default:replace(function()
				local entry_path = action_state.get_selected_entry().Path
				local dir = entry_path:is_dir() and entry_path or entry_path:parent()
				local relative = dir:make_relative(vim.fn.getcwd())
				local absolute = dir:absolute()

				live_grep({
					results_title = relative .. "/",
					cwd = absolute,
					default_text = current_line,
				})
			end)

			return true
		end,
	})
end

--telescope在配置里用了rg(ripgrep)来搜索文件，rg本身不支持模糊搜索(顶多加个空格做同一字符多段搜索)
--buildin.grep_string可能可以做模糊搜索，但速度会慢, 及fzf.nvim可能也可以用，但当前先不研究，凑合用
--rg默认尊重.gitignore,会不搜索里面的内容,可以在.gitignore的同级加一个.ignore去覆盖.gitignore的内容，让telescope搜索被.gitignore忽略的内容
--rg的具体覆盖规则可看github

return {
	defaults = {
		mappings = {
			n = {
				["<C-j>"] = require("telescope.actions").move_selection_next,
				["<C-k>"] = require("telescope.actions").move_selection_previous,
				["<C-d>"] = ts_select_dir_for_grep,
			},
			i = {
				["<C-j>"] = require("telescope.actions").move_selection_next,
				["<C-k>"] = require("telescope.actions").move_selection_previous,
				["<C-d>"] = ts_select_dir_for_grep,
			},
		},
	},
	extensions = {
		live_grep_args = {
			mappings = { -- extend mappings
				i = { --覆盖原配置
					["<C-k>"] = require("telescope.actions").move_selection_previous,
				},
			},
		},
	},
}
