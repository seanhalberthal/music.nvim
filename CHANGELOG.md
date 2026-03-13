# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

### Added
- Spotify AppleScript backend (`spotify_local`) for macOS — no API key or Spotify Premium required
- Automatic platform detection: Spotify uses AppleScript on macOS, Web API elsewhere
- `active_backend()` function on the backend module

### Changed
- Artwork extraction now uses the active backend instead of hardcoding Apple Music
