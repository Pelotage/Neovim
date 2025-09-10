-- Create this file: ~/.config/nvim/lua/plugins/nvim-jdtls.lua
-- This ensures nvim-jdtls gets loaded properly

return {
  'mfussenegger/nvim-jdtls',
  lazy = false, -- Force load immediately instead of waiting for filetype
  dependencies = {
    'mfussenegger/nvim-dap',
  },
}
