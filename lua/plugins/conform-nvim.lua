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
        lua = { "stylua" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
      formatters = {
        black = {
          args = { "--line-length", "88", "--quiet", "-" },
        },
        isort = {
          args = { "--profile", "black", "--quiet", "-" },
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
