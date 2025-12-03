return {
  cmd = { "postgres-language-server", "lsp-proxy" },
  filetypes = { "sql" },
  root_markers = { ".git", "package.json", "init.sql", "postgres-language-server.jsonc" },
  settings = {
    postgres = {
      connections = {
        {
          host = "localhost",
          port = 5432,
          user = "postgres",
          password = "postgres",
          database = "database",
          ssl = false,
        },
      },
    },
  },
}
