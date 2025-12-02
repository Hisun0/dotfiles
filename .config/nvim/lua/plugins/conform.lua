return {
  'stevearc/conform.nvim',
  opts = {
    formatters_by_ft = {
      typescript = { "eslint_d" },
      javascript = { "eslint_d" },
      typescriptreact = { "eslint_d" },
    },
    format_on_save = {
      timeout_ms = 3000,
      lsp_fallback = false,
    },
  },
}
