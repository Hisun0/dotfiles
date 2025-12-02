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
