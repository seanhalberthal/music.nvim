local M = {}

function M.setup(opts)
  require('spotui.config').apply(opts)
  require('spotui.ui').init()

  vim.keymap.set('n', '<leader>sp', require('spotui.ui').toggle,
    { desc = 'SpotUI: toggle now playing' })
end

return M
