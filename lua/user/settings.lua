-- Please check `lua/core/settings.lua` to view the full list of configurable settings
local settings = {}

-- 默认不使用ssh下载插件
settings["use_ssh"] = false

-- 不启用的插件(原配置的插件不好用)
settings["disabled_plugins"] = {
	"goolord/alpha-nvim", -- 欢迎页
	"romainl/vim-cool", -- 搜索时光标离开，高亮自动取消
}

settings["treesitter_deps"] = {
	"proto",
}

settings["colorscheme"] = "onedark"

return settings
