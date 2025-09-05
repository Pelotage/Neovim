-- Code Formatting
return {
  -- https://github.com/stevearc/conform.nvim
  'stevearc/conform.nvim',
  event = { 'BufWritePre', 'BufNewFile' },
  config = function()
    local conform = require('conform')

    conform.setup({
      formatters_by_ft = {
        python = { "black", "isort" },
        java = { "google-java-format" },
        lua = { "stylua" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
      },
      format_on_save = function(bufnr)
        -- Don't format if there are LSP errors (like syntax errors)
        local diagnostics = vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.ERROR })
        if #diagnostics > 0 then
          return false
        end

        return {
          timeout_ms = 500,
          lsp_fallback = true,
        }
      end,
      formatters = {
        black = {
          args = { "--line-length", "88", "--quiet", "-" },
        },
        isort = {
          args = { "--profile", "black", "--quiet", "-" },
        },
        ["google-java-format"] = {
          args = { "--aosp", "-" }, -- Use AOSP style (4-space indentation)
        },
      },
    })

    -- Keymap for manual formatting
    vim.keymap.set("n", "<leader>cf", function()
      conform.format({ async = true, lsp_fallback = true })
    end, { desc = "Format buffer" })

    -- Keymap for format selection in visual mode
    vim.keymap.set("v", "<leader>cf", function()
      conform.format({ async = true, lsp_fallback = true })
    end, { desc = "Format selection" })
  end,
}
