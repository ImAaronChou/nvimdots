return function()
	require("modules.utils").load_plugin("bufdel", {
		next = "alternate",
		quit = false, -- quit Neovim when last buffer is closed
	})
end
