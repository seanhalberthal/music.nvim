local M = {}

function M.setup(opts)
  require('spotui.config').apply(opts)
  require('spotui.ui').init()

  local api = require('spotui.api')

  vim.keymap.set('n', '<leader>sp', require('spotui.ui').toggle,
    { desc = 'SpotUI: toggle now playing' })

  vim.keymap.set('n', '<leader>sn', function()
    api.next_track()
  end, { desc = 'SpotUI: next track' })

  vim.keymap.set('n', '<leader>sb', function()
    api.prev_track()
  end, { desc = 'SpotUI: previous track' })

  vim.keymap.set('n', '<leader>ss', function()
    api.toggle_play()
  end, { desc = 'SpotUI: play/pause' })
end

return M
