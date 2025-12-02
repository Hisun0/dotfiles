return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    lint.linters.pint = {
      stdin = false,
      args = { "--test" },
      stream = "stderr", -- Pint outputs diagnostics to stderr
      ignore_exitcode = true,
      parser = function(output)
        local diagnostics = {}

        if not output or output == "" then
          return diagnostics
        end

        -- Check if output contains style issues
        -- Pint outputs human-readable format by default when there are issues
        if string.find(output, "FAIL") or string.find(output, "differs") then
          table.insert(diagnostics, {
            lnum = 0,
            col = 0,
            message = "Code style issues found - run formatter to fix",
            severity = vim.diagnostic.severity.WARN,
            source = "pint"
          })
        end

        return diagnostics
      end
    }

    -- Configure linters by filetype (using Mason-managed tools)
    lint.linters_by_ft = {
        -- JavaScript/TypeScript
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescriptreact = { "eslint_d" },

        -- Lua
        lua = { "luacheck" },

        -- Shell
        sh = { "shellcheck" },
        bash = { "shellcheck" },
        zsh = { "shellcheck" },

        -- You can add more linters here as needed
        -- python = { "flake8", "mypy" },
        -- rust = { "clippy" },
    }

    -- Auto-lint on save and text changes
    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = lint_augroup,
        callback = function()
            -- Only lint if linters are available for this filetype
            local linters = lint.linters_by_ft[vim.bo.filetype]
            if linters and #linters > 0 then
                lint.try_lint()
            end
        end
    })

    -- Manual linting command
    vim.keymap.set("n", "<leader>ll", function()
        lint.try_lint()
        vim.notify("Linting...", vim.log.levels.INFO, { title = "nvim-lint" })
    end, { desc = "Trigger linting for current file" })

    -- Show linter status
    vim.keymap.set("n", "<leader>li", function()
        local linters = lint.linters_by_ft[vim.bo.filetype] or {}
        if #linters == 0 then
            print("No linters configured for filetype: " .. vim.bo.filetype)
        else
            print("Linters for " .. vim.bo.filetype .. ": " .. table.concat(linters, ", "))
        end
    end)
  end
}
