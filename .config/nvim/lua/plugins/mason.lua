return {
  "williamboman/mason.nvim",
  build = ":MasonUpdate",
  lazy = false,
  cmd = 'Mason',
  config = function()
    return {
      ensure_installed = {
        -- LSP servers (matching your vim.lsp.enable() config)
        "lua-language-server",        -- Lua LSP
        "typescript-language-server", -- TypeScript LSP
        "html-lsp",                   -- HTML LSP
        "css-lsp",                    -- CSS LSP
        "postgres-language-server",

        -- Linters and diagnostics
        "eslint_d",
        "luacheck", -- Lua linting

        -- Optional but useful additions
        -- "markdownlint", -- Markdown linting
        -- "yamllint",     -- YAML linting
        "jsonlint", -- JSON linting
      }
    }
  end,
}
