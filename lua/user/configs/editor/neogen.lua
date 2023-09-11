vim.api.nvim_create_user_command("Dox", function()
	vim.cmd("Neogen")
end, {})

return function()
	require("modules.utils").load_plugin("neogen", {})
end
