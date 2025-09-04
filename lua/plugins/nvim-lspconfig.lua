-- LSP Support (Updated for Neovim 0.12 with Python Support)
return {
  -- LSP Configuration
  -- https://github.com/neovim/nvim-lspconfig
  'neovim/nvim-lspconfig',
  event = 'VeryLazy',
  dependencies = {
    -- LSP Management
    -- https://github.com/williamboman/mason.nvim
    { 'williamboman/mason.nvim' },
    -- https://github.com/williamboman/mason-lspconfig.nvim
    { 'williamboman/mason-lspconfig.nvim' },

    -- Useful status updates for LSP
    -- https://github.com/j-hui/fidget.nvim
    { 'j-hui/fidget.nvim',                opts = {} },

    -- Additional lua configuration, makes nvim stuff amazing!
    -- https://github.com/folke/neodev.nvim
    { 'folke/neodev.nvim',                opts = {} },
  },
  config = function()
    -- Require lspconfig at the beginning of the config function
    local lspconfig = require('lspconfig')

    -- Define capabilities and attach functions
    local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

    local lsp_attach = function(client, bufnr)
      -- Enable inlay hints if available (Neovim 0.10+)
      if client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
      end

      -- Disable formatting for pylsp (we'll use black/isort via conform.nvim instead)
      if client.name == 'pylsp' then
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
      end
    end

    -- Configure diagnostics display (Updated for 0.12)
    vim.diagnostic.config({
      virtual_text = {
        enabled = true,
        source = "if_many",
        prefix = "●", -- Could be '■', '▎', 'x', '●'
      },
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = "✘",
          [vim.diagnostic.severity.WARN] = "▲",
          [vim.diagnostic.severity.HINT] = "⚑",
          [vim.diagnostic.severity.INFO] = "»",
        },
      },
      underline = true,
      update_in_insert = false,
      severity_sort = true,
      float = {
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
        focusable = false,
      },
    })

    require('mason').setup({
      ensure_installed = {
        -- Python development tools
        'black',   -- Python code formatter
        'isort',   -- Python import sorter
        'flake8',  -- Python linter
        'debugpy', -- Python debugger adapter

        -- Lua development tools
        'stylua', -- Lua formatter

        -- C/C++ development tools
        'clang-format', -- C/C++ code formatter
        'codelldb',     -- Debugger

        -- Other formatters
        'prettier', -- JS/TS/JSON/YAML formatter
      },
    })

    require('mason-lspconfig').setup({
      -- Install these LSPs automatically
      ensure_installed = {
        -- 'bashls', -- requires npm to be installed
        -- 'cssls', -- requires npm to be installed
        -- 'html', -- requires npm to be installed
        'lua_ls',
        'pylsp', -- Python LSP server (python-lsp-server)
        -- 'jsonls', -- requires npm to be installed
        'lemminx',
        'marksman',
        'quick_lint_js',
        'clangd', -- C/C++ LSP server
        -- 'tsserver', -- requires npm to be installed
        -- 'yamlls', -- requires npm to be installed
      },
      handlers = {
        function(server_name)
          lspconfig[server_name].setup({
            on_attach = lsp_attach,
            capabilities = lsp_capabilities,
          })
        end
      }
    })

    -- Lua LSP settings
    lspconfig.lua_ls.setup {
      on_attach = lsp_attach,
      capabilities = lsp_capabilities,
      settings = {
        Lua = {
          diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = { 'vim' },
          },
          workspace = {
            -- Make the server aware of Neovim runtime files
            library = vim.api.nvim_get_runtime_file("", true),
            checkThirdParty = false,
          },
          telemetry = {
            enable = false,
          },
        },
      },
    }

    -- Python LSP settings (python-lsp-server)
    lspconfig.pylsp.setup {
      on_attach = lsp_attach,
      capabilities = lsp_capabilities,
      settings = {
        pylsp = {
          plugins = {
            -- Enable/disable plugins
            pycodestyle = { enabled = true, maxLineLength = 88 },
            pydocstyle = { enabled = false },
            pyflakes = { enabled = true },
            pylint = { enabled = false },
            rope_completion = { enabled = true },
            yapf = { enabled = false },
            autopep8 = { enabled = false },
            -- Note: black and isort will be handled by conform.nvim
            black = { enabled = false },
            isort = { enabled = false },
            flake8 = { enabled = false }, -- We'll use nvim-lint for this
          }
        }
      },
    }

    -- C/C++ LSP settings (clangd)
    lspconfig.clangd.setup {
      on_attach = lsp_attach,
      capabilities = lsp_capabilities,
      cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--completion-style=detailed",
        "--header-insertion=iwyu",
        "--suggest-missing-includes",
      },
      init_options = {
        clangdFileStatus = true,
      },
    }

    -- Globally configure all LSP floating preview popups (like hover, signature help, etc)
    local open_floating_preview = vim.lsp.util.open_floating_preview
    function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
      opts = opts or {}
      opts.border = opts.border or "rounded" -- Set border to rounded
      return open_floating_preview(contents, syntax, opts, ...)
    end
  end
}
