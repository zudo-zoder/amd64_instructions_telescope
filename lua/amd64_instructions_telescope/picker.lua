-- felixcloutier assembly picker

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local make_entry = require "telescope.make_entry"
local previewers = require("telescope.previewers")

local M = {}

local amd64_map = {}
local amd64_data = {}

local function read_amd64_instructions()
	local lines = {}

	local path = debug.getinfo(1, "S").source:sub(2):match("(.*/)")

	local file_path = path .. "../../amd64_instructions.json"
	local json_text = table.concat(vim.fn.readfile(file_path), "\n")

	amd64_data = vim.fn.json_decode(json_text)

	for _, instr in ipairs(amd64_data) do
		table.insert(lines, instr.mnemonic);
		amd64_map[instr.mnemonic] = instr;
	end

	return lines
end

local amd64_instructions = read_amd64_instructions();

function M.picker()
	pickers.new({}, {
		prompt_title = "amd64 instruction docs",
		finder = finders.new_table { 
			results = amd64_instructions, 
			entry_maker = function(entry)
				return make_entry.set_default_entry_mt({
					value = entry,
					display = entry .. " - " .. amd64_map[entry].description,
					ordinal = entry .. " - " .. amd64_map[entry].description,
					--action = null,
				});
			end
		},
		sorter = conf.generic_sorter({}),
		attach_mappings = function(prompt_bufnr, map)
			local function open_url()
				local selection = action_state.get_selected_entry().value
				local instr = amd64_map[selection];
				actions.close(prompt_bufnr)
				local url = instr.link
				vim.fn.jobstart({ "xdg-open", url }, { detach = true })  -- Linux
				-- vim.fn.jobstart({ "open", selection }, { detach = true })   -- macOS
			end

			map("i", "<CR>", open_url)
			map("n", "<CR>", open_url)
			return true
		end,
	}):find()
end

return M
