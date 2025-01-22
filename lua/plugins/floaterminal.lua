return {
  "floaterminal",
  name = "floaterminal",
  dev = true,
  dir = vim.fn.stdpath("config") .. "/lua/plugins",
  config = function()
    -- Map terminal escape key
    vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>")

    local M = {}
    M.state = {
      buf = nil,
      win = nil
    }

    function M.create_floating_window()
      local width = math.floor(vim.o.columns * 0.8)
      local height = math.floor(vim.o.lines * 0.8)
      local col = math.floor((vim.o.columns - width) / 2)
      local row = math.floor((vim.o.lines - height) / 2)

      local buf = M.state.buf
      if not buf or not vim.api.nvim_buf_is_valid(buf) then
        buf = vim.api.nvim_create_buf(false, true)
        M.state.buf = buf
      end

      local win_config = {
        relative = "editor",
        width = width,
        height = height,
        col = col,
        row = row,
        style = "minimal",
        border = "rounded"
      }

      local win = vim.api.nvim_open_win(buf, true, win_config)
      M.state.win = win

      if vim.bo[buf].buftype ~= "terminal" then
        vim.fn.termopen(vim.o.shell)
      end

      return win
    end

    function M.toggle_terminal()
      if M.state.win and vim.api.nvim_win_is_valid(M.state.win) then
        vim.api.nvim_win_hide(M.state.win)
        M.state.win = nil
      else
        M.create_floating_window()
      end
    end

    vim.api.nvim_create_user_command("Floaterminal", M.toggle_terminal, {})
    vim.keymap.set("n", "<leader>ft", M.toggle_terminal, { noremap = true, silent = true })
  end
}