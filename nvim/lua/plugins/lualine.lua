local icons = {
	diagnostics = { Error = " ", Warn = " ", Info = " ", Hint = " " },
	git = { added = " ", modified = " ", removed = " " },
}

vim.o.laststatus = vim.g.lualine_laststatus

local function pretty_path()
	local path = vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.")
	if path == "" then return "[No Name]" end
	return path
end

return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  init = function()
    vim.g.lualine_laststatus = vim.o.laststatus
    if vim.fn.argc(-1) > 0 then
      -- set an empty statusline till lualine loads
      vim.o.statusline = " "
    else
      -- hide the statusline on the starter page
      vim.o.laststatus = 0
    end
  end,
  opts = {
    options = {
		theme = "auto",
		globalstatus = vim.o.laststatus == 3,
		disabled_filetypes = { statusline = { "dashboard", "alpha", "starter" } },
	},

	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch" },

		lualine_c = {
			{ function() return vim.fn.getcwd():gsub(vim.env.HOME, "~") end, icon = "" },
			{
				"diagnostics",
				sources = { "nvim_diagnostic" },
				symbols = {
					error = icons.diagnostics.Error,
					warn = icons.diagnostics.Warn,
					info = icons.diagnostics.Info,
					hint = icons.diagnostics.Hint,
				},
			},
			{ "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
			{ pretty_path },
		},

		lualine_x = {
			{
				function()
					if package.loaded["noice"] and require("noice").api.status.command.has() then
						return require("noice").api.status.command.get()
					end
				end,
				cond = function()
					return package.loaded["noice"] and require("noice").api.status.command.has()
				end,
			},
			{
				function()
					if package.loaded["noice"] and require("noice").api.status.mode.has() then
						return require("noice").api.status.mode.get()
					end
				end,
				cond = function()
					return package.loaded["noice"] and require("noice").api.status.mode.has()
				end,
			},
			{
				function()
					if package.loaded["dap"] and require("dap").status() ~= "" then
						return "  " .. require("dap").status()
					end
				end,
				cond = function()
					return package.loaded["dap"] and require("dap").status() ~= ""
				end,
			},
			{
				"diff",
				symbols = {
					added = icons.git.added,
					modified = icons.git.modified,
					removed = icons.git.removed,
				},
				source = function()
					local gitsigns = vim.b.gitsigns_status_dict
					if gitsigns then
						return {
							added = gitsigns.added,
							modified = gitsigns.changed,
							removed = gitsigns.removed,
						}
					end
				end,
			},
		},

		lualine_y = {
			{ "progress", separator = " ",                  padding = { left = 1, right = 0 } },
			{ "location", padding = { left = 0, right = 1 } },
		},

		lualine_z = {
			function()
				return " " .. os.date("%R")
			end,
		},
	},

	extensions = { "fzf" },
  }
}
