-- ============================================================================
-- LSP Server Definitions
-- ============================================================================
-- Each server config is loaded from lsp/<server-name>.lua
-- These configs are automatically managed by Mason (see lua/plugins/mason.lua)

local servers = {
  "lua-ls",  -- Lua language server
  "ts-ls",   -- TypeScript/JavaScript language server
  "html-ls", -- HTML language server
  "css-ls",  -- CSS language server
  "postgresls",
}

-- ============================================================================
-- LSP Capabilities Setup (blink.cmp integration)
-- ============================================================================

local function get_capabilities()
  -- Check if blink.cmp is available
  local has_blink, blink = pcall(require, "blink.cmp")

  if has_blink and blink.get_lsp_capabilities then
    -- Merge default capabilities with blink.cmp capabilities
    return vim.tbl_deep_extend(
      "force",
      vim.lsp.protocol.make_client_capabilities(),
      blink.get_lsp_capabilities(),
      {
        -- Additional capabilities can be added here
        workspace = {
          fileOperations = {
            didRename = true,
            willRename = true,
          },
        },
      }
    )
  else
    -- Fallback to default capabilities if blink.cmp is not available
    return vim.lsp.protocol.make_client_capabilities()
  end
end

-- ============================================================================
-- LSP Keymaps (set on attach)
-- ============================================================================

local function setup_keymaps(bufnr)
  local function map(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = "LSP: " .. desc, silent = true })
  end

  -- Navigation
  map("n", "gd", vim.lsp.buf.definition, "Go to definition")
  map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
  map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
  map("n", "gr", vim.lsp.buf.references, "Go to references")
  map("n", "gt", vim.lsp.buf.type_definition, "Go to type definition")

  -- Information
  map("n", "K", vim.lsp.buf.hover, "Hover documentation")
  map("n", "<C-k>", vim.lsp.buf.signature_help, "Signature help")
  map("i", "<C-k>", vim.lsp.buf.signature_help, "Signature help")

  -- Code actions
  map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
  map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
  map("n", "<leader>cf", function() vim.lsp.buf.format({ async = true }) end, "Format buffer")

  -- Diagnostics
  map("n", "[d", vim.diagnostic.goto_prev, "Previous diagnostic")
  map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
  map("n", "<leader>cd", vim.diagnostic.open_float, "Show diagnostic")
  map("n", "<leader>cl", vim.diagnostic.setloclist, "Diagnostics to loclist")

  -- Workspace
  map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, "Add workspace folder")
  map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "Remove workspace folder")
  map("n", "<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, "List workspace folders")
end

-- ============================================================================
-- LSP Attach Handler
-- ============================================================================

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    if not client then return end

    -- Setup keymaps for this buffer
    setup_keymaps(bufnr)

    -- Enable completion triggered by <c-x><c-o>
    vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

    -- Enable inlay hints if supported (Neovim 0.10+)
    if client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end

    -- Document highlight on cursor hold
    if client.server_capabilities.documentHighlightProvider then
      local highlight_group = vim.api.nvim_create_augroup("LspDocumentHighlight_" .. bufnr, { clear = true })
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = bufnr,
        group = highlight_group,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        buffer = bufnr,
        group = highlight_group,
        callback = vim.lsp.buf.clear_references,
      })
    end
  end,
})

-- ============================================================================
-- Diagnostic Configuration
-- ============================================================================

vim.diagnostic.config({
  virtual_text = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = true,
    header = "",
    prefix = "",
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "󰅚 ",
      [vim.diagnostic.severity.WARN] = "󰀪 ",
      [vim.diagnostic.severity.INFO] = "󰋽 ",
      [vim.diagnostic.severity.HINT] = "󰌶 ",
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = "ErrorMsg",
      [vim.diagnostic.severity.WARN] = "WarningMsg",
    },
  },
})

-- ============================================================================
-- LSP Server Setup
-- ============================================================================

local capabilities = get_capabilities()

for _, server_name in ipairs(servers) do
  -- Load server-specific config from lsp/<server-name>.lua
  local config_path = vim.fn.stdpath("config") .. "/lsp/" .. server_name .. ".lua"

  if vim.fn.filereadable(config_path) == 1 then
    -- Load the config file
    local ok, server_config = pcall(dofile, config_path)

    if ok and type(server_config) == "table" then
      -- Merge capabilities with server config
      server_config.capabilities = vim.tbl_deep_extend(
        "force",
        capabilities,
        server_config.capabilities or {}
      )

      -- Enable the LSP with the loaded config
      vim.lsp.enable(server_name, server_config)
    else
      -- If config load failed, enable with default config
      vim.notify(
        string.format("Failed to load config for %s, using defaults", server_name),
        vim.log.levels.WARN
      )
      vim.lsp.enable(server_name, { capabilities = capabilities })
    end
  else
    -- No config file, use default config
    vim.lsp.enable(server_name, { capabilities = capabilities })
  end
end

