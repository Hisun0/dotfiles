return {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
    -- "vue"
  },

  root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },

  init_options = {
    preferences = {
      importModuleSpecifierPreference = 'relative',
      importModuleSpecifierEnding = 'minimal',
      quotePreference = "single",
    },
  },

  settings = {
    typescript = {
      tsserver = {
        useSyntaxServer = false,
      },
    },
  },
}
