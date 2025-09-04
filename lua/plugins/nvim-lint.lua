-- Code Linting
return {
  -- https://github.com/mfussenegger/nvim-lint
  'mfussenegger/nvim-lint',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local lint = require('lint')
    
    lint.linters_by_ft = {
      python = { 'flake8' },
      -- You can add other file types here
      -- javascript = { 'eslint' },
      -- typescript = { 'eslint' },
    }
    
    -- Configure flake8
    lint.linters.flake8.args = {
      '--format=%(path)s:%(row)d:%(col)d:%(code)s:%(text)s',
      '--max-line-length=88',
      '--extend-ignore=E203,W503',
    }
    
    -- Create autocommand to run linter
    local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
    
    vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
      group = lint_augroup,
      callback = function()
        lint.try_lint()
      end,
    })
    
    -- Keymap for manual linting
    vim.keymap.set("n", "<leader>cl", function()
      lint.try_lint()
    end, { desc = "Trigger linting for current file" })
  end,
}
