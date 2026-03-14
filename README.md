# music.nvim

Because alt-tabbing to a music player is for people who don't use Neovim.

![expanded-ui](assets/full-ss.png)

## What it does

When you toggle it open, a window pops up in your chosen corner with the album
art and current track. After a few seconds it shrinks down to a compact bar
showing the song, artist, and timestamp. It expands again automatically on every
song change.

![mini-ui](assets/mini-ss.png)

## Requirements

- Neovim 0.8+
- [chafa](https://hpjansson.org/chafa/) — for album art rendering
- curl — for Spotify API calls (non-macOS platforms)
- osascript — for Apple Music/Spotify control (macOS only)
- A Spotify or Apple Music account

**Installing chafa:**
```bash
# macOS
brew install chafa

# Ubuntu/Debian
sudo apt install chafa

# Windows
scoop install chafa
```

## Supported Music Apps

- **Spotify/Apple Music (macOS)** — uses AppleScript to talk to Spotify.app/Music.app directly, no API keys needed, full playback controls available
- **Spotify (other platforms)** — uses the Spotify Web API, requires API credentials and Spotify Premium for playback controls

The plugin defaults to Apple Music. You can also set it to `'spotify'` or `'auto'` to detect which is running. When set to `'spotify'`, the plugin automatically picks the right backend for your platform.

## Setup

**1. Spotify setup (only if using Spotify on non-macOS platforms)**

On macOS, Spotify works out of the box via AppleScript — no API credentials needed.

On other platforms, create a Spotify app at [developer.spotify.com/dashboard](https://developer.spotify.com/dashboard),
create a new app, and set the redirect URI to `http://127.0.0.1:8888/callback`.
Grab your Client ID and Client Secret.

Create a `.env` file in the project root:
```
SPOTIFY_CLIENT_ID=your_client_id
SPOTIFY_CLIENT_SECRET=your_client_secret
```

Then run the setup script once:
```bash
pip install requests python-dotenv
python scripts/get_token.py
```

This opens a browser window, asks you to authorize the app, and saves a token
file to `~/.spotify_nvim_tokens.json`. You only need to do this once.

**2. Install the plugin**

With [lazy.nvim](https://github.com/folke/lazy.nvim):
```lua
{
  'seanhalberthal/music.nvim',
  config = function()
    require('music').setup({
      position = 'bottom-left',
      poll_interval = 1000,
      window = {
        width = 30,
        expand_duration = 1500,
      }
    })
  end
}
```

## Keymaps

| Key | Action |
|-----|--------|
| `<leader>kp` | Toggle the window |
| `<leader>ks` | Play / pause |
| `<leader>kn` | Next track |
| `<leader>kb` | Previous track |

## Configuration

These are the defaults:
```lua
require('music').setup({
  poll_interval = 1000,      -- how often to check for track changes (ms)
  preferred_backend = 'apple_music', -- 'apple_music' | 'spotify' | 'auto'
  position = 'bottom-left',  -- 'top-right', 'top-left', 'bottom-right', 'bottom-left'
  window = {
    width = 30,
    expanded_height = 16,    -- height when album art is visible
    compact_height = 3,      -- height after minimizing
    expand_duration = 1500,  -- ms before shrinking to compact view
  },
  highlights = {
    background = 'Normal',       -- window background highlight group
    border = 'FloatBorder',      -- border highlight group
    text = 'NormalFloat',        -- text highlight group
  }
})
```

To force a specific backend:
```lua
preferred_backend = 'spotify',  -- or 'apple_music'
```

To make the window use float-style colours that stand out from normal buffers:
```lua
highlights = {
  background = 'NormalFloat',
  border = 'FloatBorder',
  text = 'NormalFloat',
}
```

Any valid Neovim highlight group works here. Run `:Telescope highlights` or
`:highlight` to browse what's available in your current theme.


## How it works

music.nvim polls the active music app every `poll_interval` milliseconds:
- **macOS**: uses osascript to talk to Spotify.app or Music.app directly
- **Other platforms**: uses the Spotify Web API via async curl calls

Album art is downloaded once per track and cached for the session, then
rendered as Unicode block characters using chafa.

## Notes

- Album art rendering requires a terminal with Unicode support (most modern
  terminals work fine eg. Windows Terminal, Ghostty, WezTerm, Kitty, iTerm2, Alacritty)
- Spotify Web API playback controls require Spotify Premium (macOS AppleScript backend has no such restriction)
- Apple Music requires macOS
- The Spotify token file is stored at `~/.spotify_nvim_tokens.json` and refreshes
  automatically when it expires
