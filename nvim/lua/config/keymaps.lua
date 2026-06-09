local map = vim.keymap.set
local opts = { noremap = true, silent = true }

--- Tabs
map("n", "<Tab>", ":bnext<CR>", opts)
map("n", "<S-Tab>", ":bprevious<CR>", opts)
map("n", "qq", ":bd<CR>", opts)

map("n", "sv", ":vsplit<Return>", opts)
map("n", "ss", ":split<Return>", opts)

--- Format file
map("n", "<leader>lf", function()
  vim.lsp.buf.format({ async = true })
end)

--- File explorer
map("n", "<space>fb", ":Telescope file_browser<CR>", opts)
map("n", "<leader>lg", ":Telescope live_grep<CR>", opts)
map("n", "<leader>ff", ":Telescope find_files<CR>", opts)
map("n", "<leader>bb", ":Telescope buffers<CR>", opts)
map("n", "gd", ":Telescope lsp_definitions<CR>", opts)
map("n", "gr", ":Telescope lsp_references<CR>", opts)
map("n", "<leader>f", ":Telescope current_buffer_fuzzy_find<CR>", opts)

--- Git
map("n", "<leader>gl", ":Gitsigns toggle_current_line_blame<CR>", opts)

--- Select all
map("n", "<C-a>", "ggVG")

--- Quit from insert to Normal mode using jj instead of Esc
map("i", "jj", "<Esc>")

map("n", "<leader>w", ":w<CR>")
map("n", "<leader>q", ":q<CR>")
map("n", "<leader>e", function()
  vim.diagnostic.open_float(nil, { border = "rounded" })
end, opts)
map("n", "<leader>a", vim.lsp.buf.code_action, opts)
map("n", "<leader>hf", ":HopWord<CR>", opts)

-- Show diagnostic
local function sonarlint_project_diagnostics()
  require("telescope.builtin").diagnostics({
    bufnr = 0,
    severity = vim.diagnostic.severity.WARN,
    layout_strategy = "vertical",
    layout_config = { height = 0.9, width = 0.9 },
    prompt_title = "SonarLint Diagnostics",
  })
end

-- Пример привязки к клавише
vim.keymap.set("n", "<leader>sd", sonarlint_project_diagnostics, { desc = "Show SonarLint Diagnostics" })

--- DB helpers
local function get_visual_lines()
  local s = vim.fn.line("'<")
  local e = vim.fn.line("'>")
  return vim.api.nvim_buf_get_lines(0, s - 1, e, false)
end

local function write_db_tmpfile(lines, prefix, suffix)
  local tmpfile = "/tmp/.db_query.sql"
  local f = io.open(tmpfile, "w")
  if f then
    if prefix then f:write(prefix .. "\n") end
    f:write(table.concat(lines, "\n"))
    if suffix then f:write("\n" .. suffix) end
    f:close()
  end
  return tmpfile
end

local function psql_run(tmpfile)
  vim.fn.system("tmux send-keys -t '{last}' '\\i " .. tmpfile .. "' Enter")
end

--- DB: send visual selection to psql in the right tmux pane
--- Requires an interactive `db <service>` session open in the right pane
map("v", "<leader>db", function()
  local tmpfile = write_db_tmpfile(get_visual_lines())
  psql_run(tmpfile)
end, { noremap = true, silent = true, desc = "Run selection in psql pane" })

--- DB: run selection in expanded (vertical) format
map("v", "<leader>dx", function()
  local tmpfile = write_db_tmpfile(get_visual_lines(), "\\x on", "\\x off")
  psql_run(tmpfile)
end, { noremap = true, silent = true, desc = "Run selection in psql expanded format" })

--- DB: run selection with pager
map("v", "<leader>dp", function()
  local tmpfile = write_db_tmpfile(get_visual_lines(), "\\pset pager always\n\\pset format wrapped\n\\pset columns 120", "\\pset pager off\n\\pset format aligned")
  psql_run(tmpfile)
end, { noremap = true, silent = true, desc = "Run selection in psql with pager" })

--- DB: send entire current file to psql in the right tmux pane
map("n", "<leader>dba", function()
  local file = vim.fn.expand("%:p")
  vim.fn.system("tmux send-keys -t '{last}' '\\i " .. file .. "' Enter")
end, { noremap = true, silent = true, desc = "Run current file in psql pane" })
