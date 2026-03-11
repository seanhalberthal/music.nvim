local M = {}
local cache = {}

function M.get_lines(url, width)
  if not url then return {} end
  if cache[url] then return cache[url] end

  if vim.fn.executable('chafa') == 0 then
    return { '  [install chafa for album art]' }
  end

  local tmp = (vim.fn.tempname() .. '.jpg'):gsub('\\', '/')
  vim.fn.system(('curl -s -o "%s" "%s"'):format(tmp, url))

local lines = vim.fn.systemlist(
    ('chafa --size %dx12 --symbols braille --colors none --format symbols "%s" 2>nul')
  :format(width - 4, tmp)
)

for i, line in ipairs(lines) do
  line = line:gsub('\r$', '')
  lines[i] = '  ' .. line
end

  vim.fn.delete(tmp)
  cache[url] = #lines > 0 and lines or { '  [art unavailable]' }
  return cache[url]
end

function M.clear_cache()
  cache = {}
end

return M
