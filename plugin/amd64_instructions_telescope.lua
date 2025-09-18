local picker = require("amd64_instructions_telescope")

vim.api.nvim_create_user_command("ListAmd64", function() 
	picker.picker()
end, {})
