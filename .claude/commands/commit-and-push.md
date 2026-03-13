---
description: Commit staged changes and create a PR, push on top if PR already exists.
---

# Commit and Push Changes

## Pre-Commit Validation

1. **Git Status Check**:
    - Run `git status` to see all modified, staged, and untracked files
    - Run `git diff --cached` to review staged changes
    - Run `git diff` to review unstaged changes
    - If nothing is staged or modified, stop and inform the user

2. **Run Tests**:
    - **CRITICAL**: Run `make test` and confirm all tests pass
    - If tests fail, stop immediately — do NOT commit broken code
    - Fix failing tests before proceeding

3. **README Update Check** (MANDATORY):
    - **STOP**: You MUST complete this step before proceeding to commit
    - **Read the README** to understand current documentation
    - **Compare changes against README content** — for each changed file, check if:
      - New commands, features, or functionality were added
      - Installation steps or prerequisites changed
      - Directory structure or file locations changed
      - Configuration options changed (check `lua/music/config.lua` defaults vs README)
      - Keymaps changed (check `lua/music/init.lua` vs README keymaps table)
      - Requirements changed (check `lua/music/health.lua` vs README requirements)
    - **If ANY documentation updates are needed**:
      - Update the README BEFORE creating the commit
      - Stage the README changes along with the other changes
    - **If unsure**: Ask the user whether README updates are needed
    - **Do NOT skip this step** — documentation drift causes confusion

4. **CHANGELOG Update** (for user-facing changes):
    - Check if the changes are user-facing (new features, bug fixes, behaviour changes, config changes)
    - If user-facing:
      - **First: tidy existing entries.** Check `CHANGELOG.md` for entries under `[Unreleased]` that belong to an already-released version. Cross-reference with `git tag --sort=-v:refname` and `git log --oneline` between tags. Move any misplaced entries into their correct `[x.y.z]` section (creating the section if needed).
      - Add a new entry under `[Unreleased]` describing the change
      - Format:
        ```
        ## [Unreleased]

        ### Added
        - New feature or capability

        ### Changed
        - Modified behaviour

        ### Fixed
        - Bug fix description

        ### Removed
        - Removed feature
        ```
      - Stage CHANGELOG.md with the other changes
    - If purely internal (refactoring, test-only, CI changes), CHANGELOG update is optional

## Commit Process

### Analyse Changes

- Run `git diff --cached` to review everything that will be committed
- Identify the nature of the changes: new feature, bug fix, refactor, test, etc.
- Run `git log --oneline -10` to check recent commit style

### Generate Commit Message

Follow the existing project conventions (informal, descriptive):
- Use lowercase sentence style
- Lead with the type of change when clear: `feat:`, `fix:`, `refactor:`, `test:`, `docs:`
- Keep the first line under 72 characters
- Add a blank line and body for larger changes

Examples from this repo:
```
feat: add Apple Music backend with auto-detection
fix: url encoding bug in get_token for macos
refactor: extract pure functions to utils.lua
test: add unit tests for all modules
```

**NEVER include**:
- `Co-Authored-By:` lines
- Any mention of Claude, Claude Code, or AI assistants
- Any AI attribution whatsoever

### Execute Commit and Push

1. **Branch Safety Check** (MANDATORY):
   - Run `git branch --show-current` to check the current branch
   - **If on `main`**: **STOP** — do NOT commit or push directly to main
   - Create a feature branch first:
     ```
     git checkout -b descriptive-branch-name
     ```
   - Branch naming: use lowercase with hyphens, e.g., `add-apple-music-backend`, `fix-parser-bug`
   - **NEVER push to `main`** — all changes go through feature branches and PRs

2. Stage files by name (avoid `git add -A` or `git add .`):
   ```
   git add lua/music/file.lua tests/unit/file_spec.lua
   ```
3. Create the commit using a HEREDOC for the message:
   ```
   git commit -m "$(cat <<'EOF'
   commit message here
   EOF
   )"
   ```
4. Push to the feature branch:
   ```
   git push origin HEAD
   ```
   If no upstream is set:
   ```
   git push -u origin $(git branch --show-current)
   ```

## Pull Request Creation

### Branch Check

- **CRITICAL**: You must already be on a feature branch at this point — never on `main`
- If somehow still on `main`, stop and go back to the branch safety check above

### Create Pull Request

Use `gh pr create` with a concise description:
```bash
gh pr create --title "Short descriptive title" --body "$(cat <<'EOF'
## Summary
- Bullet points describing changes

## Test plan
- [ ] Tests pass (`make test`)
- [ ] Manual verification steps
EOF
)"
```

**NEVER include** AI attribution or "Generated with Claude Code" in PR descriptions.

If a PR already exists for the branch, just push — no need to create a new one.

### Post-Push Verification

- Run `git status` to confirm clean working tree
- If a PR was created, return the PR URL to the user

## Key Directories

| Directory | Contents |
|-----------|----------|
| `lua/music/` | Core plugin modules |
| `tests/unit/` | Plenary-based unit tests |
| `plugin/` | Neovim plugin entry point |
| `scripts/` | Setup utilities (Python) |
| `assets/` | README screenshots |

## Notes

- This is a Neovim plugin — all Lua code lives under `lua/music/`
- Tests use plenary.nvim and run in headless Neovim via `make test`
- No CI/CD pipeline — tests are run locally
- The `vim` global is expected in Neovim Lua — LSP warnings about `undefined global vim` are normal
