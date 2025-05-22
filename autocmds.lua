-- Add these autocommands to improve diagnostic display

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Diagnostic display improvements
local diagnostic_group = augroup('DiagnosticDisplay', { clear = true })

-- Show line diagnostics automatically in hover window
autocmd({ 'CursorHold', 'CursorHoldI' }, {
  group = diagnostic_group,
  callback = function()
    vim.diagnostic.open_float(nil, {
      focusable = false,
      close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
      border = 'rounded',
      source = 'always',
      prefix = ' ',
      scope = 'cursor',
    })
  end,
})

-- Highlight the line number for errors and warnings
autocmd('DiagnosticChanged', {
  group = diagnostic_group,
  callback = function()
    vim.diagnostic.config({
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = "✘",
          [vim.diagnostic.severity.WARN] = "▲",
          [vim.diagnostic.severity.HINT] = "⚑",
          [vim.diagnostic.severity.INFO] = "»",
        },
        linehl = {
          [vim.diagnostic.severity.ERROR] = 'DiagnosticLineError',
          [vim.diagnostic.severity.WARN] = 'DiagnosticLineWarn',
        },
        numhl = {
          [vim.diagnostic.severity.ERROR] = 'DiagnosticLineNumberError',
          [vim.diagnostic.severity.WARN] = 'DiagnosticLineNumberWarn',
        },
      },
    })
  end,
})

-- LSP attach autocommand for additional diagnostic setup
local lsp_group = augroup('LspDiagnostics', { clear = true })

autocmd('LspAttach', {
  group = lsp_group,
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local bufnr = args.buf

    -- Enable inlay hints if available (Neovim 0.10+)
    if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end

    -- Set up buffer-local keymaps for LSP functions
    local opts = { buffer = bufnr }
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'go', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, opts)
    vim.keymap.set({'n', 'x'}, '<F3>', function() vim.lsp.buf.format({async = true}) end, opts)
    vim.keymap.set('n', '<F4>', vim.lsp.buf.code_action, opts)
  end,
})

-- Format on save for specific file types
local format_group = augroup('FormatOnSave', { clear = true })

autocmd('BufWritePre', {
  group = format_group,
  pattern = { '*.lua', '*.py', '*.js', '*.ts', '*.jsx', '*.tsx', '*.json' },
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

-- Highlight diagnostic line numbers
autocmd('ColorScheme', {
  callback = function()
    -- Define highlight groups for diagnostic line numbers
    vim.api.nvim_set_hl(0, 'DiagnosticLineNumberError', { fg = '#FF6B70', bold = true })
    vim.api.nvim_set_hl(0, 'DiagnosticLineNumberWarn', { fg = '#FFB855', bold = true })
    vim.api.nvim_set_hl(0, 'DiagnosticLineError', { bg = '#43242B' })
    vim.api.nvim_set_hl(0, 'DiagnosticLineWarn', { bg = '#49443C' })
  end,
})
