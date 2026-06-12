local map = vim.keymap.set
local opts = { noremap = true, silent = true }

--- Tabs
map("n", "<Tab>", ":bnext<CR>", opts)
map("n", "<S-Tab>", ":bprevious<CR>", opts)
map("n", "qq", ":bd<CR>", opts)

map("n", "sv", ":vsplit<Return>", opts)
map("n", "ss", ":split<Return>", opts)

--- Resize splits
map("n", "<M-l>", ":vertical resize -2<CR>", opts)
map("n", "<M-h>", ":vertical resize +2<CR>", opts)
map("n", "<M-j>", ":resize -2<CR>", opts)
map("n", "<M-k>", ":resize +2<CR>", opts)

--- Format file
map("n", "<leader>lf", function()
  vim.lsp.buf.format({ async = true })
end)

--- File explorer
map("n", "<leader>lg", ":Telescope live_grep<CR>", opts)
map("n", "<leader>ff", ":Telescope find_files<CR>", opts)
map("n", "<leader>bb", ":Telescope buffers<CR>", opts)
map("n", "gd", ":Telescope lsp_definitions<CR>", opts)
map("n", "gr", ":Telescope lsp_references<CR>", opts)

--- Git
map("n", "<leader>gl", ":Gitsigns toggle_current_line_blame<CR>", opts)

--- Select all
map("n", "<C-a>", "ggVG")

--- Quit from insert to Normal mode using jj instead of Esc
map("i", "jj", "<Esc>")

map("n", "<leader>w", ":w<CR>")

map("n", "<leader>a", vim.lsp.buf.code_action, opts)

