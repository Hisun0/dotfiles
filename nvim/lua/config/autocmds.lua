--- Autosave
vim.cmd([[autocmd TextChanged,InsertLeave * silent! wall]])

--- Trim spaces
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  command = "silent! %s/\\s\\+$//e"
})

--- Check changes in buffer
-- vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
--   pattern = "*",
--   command = "checktime"
-- })

-- Delete highlight after search and replace
vim.api.nvim_create_autocmd("CmdlineLeave", {
  pattern = ":*",
  command = "nohlsearch"
})

--- Treesitter highlighting (native)
--- Disabled for html and files > 100KB
vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    if args.match == "html" then return end
    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(args.buf))
    if ok and stats and stats.size > 100 * 1024 then
      vim.notify("File >100KB, treesitter disabled", vim.log.levels.WARN)
      return
    end
    pcall(vim.treesitter.start)
  end,
})
