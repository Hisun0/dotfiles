--- Autosave
vim.cmd([[autocmd TextChanged,InsertLeave * silent! wall]])

--- Trim spaces
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  command = "silent! %s/\\s\\+$//e"
})

--- Check changes in buffer
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
  pattern = "*",
  command = "checktime"
})

-- Delete highlight after search and replace
vim.api.nvim_create_autocmd("CmdlineLeave", {
  pattern = ":*",
  command = "nohlsearch"
})
