# Neovim Configuration

A modern, modular Neovim configuration built with Lua and [lazy.nvim](https://github.com/folke/lazy.nvim) plugin manager.

## Overview

This configuration transforms Neovim into a full-featured IDE with:
- **Modern plugin manager** (lazy.nvim) with lazy loading for fast startup
- **LSP support** for 15+ languages (Rust, Go, TypeScript, Python, PHP, etc.)
- **Intelligent completion** with blink.cmp (Rust-based engine)
- **Powerful debugging** with nvim-dap and custom adapters
- **AI mentoring and review** with CodeCompanion and OpenCode
- **Git workflow** integration (gitsigns, neogit, diffview)
- **File navigation** with snacks.nvim picker
- **Image viewing** with snacks.nvim for directly opened PNG, JPG, WebP, and other supported formats

## Requirements

- Neovim 0.10+ (uses modern LSP features)
- Git
- A [Nerd Font](https://www.nerdfonts.com/) for icons
- For image viewing: a Kitty graphics protocol-compatible terminal such as Kitty or Ghostty; ImageMagick for formats other than PNG. Use `:checkhealth snacks` to diagnose rendering issues.

## Installation

```bash
# Backup existing config
mv ~/.config/nvim ~/.config/nvim.bak

# Clone this repository
git clone <repo-url> ~/.config/nvim

# Start Neovim - plugins will auto-install
nvim
```

## Structure

```
~/.config/nvim/
├── init.lua                    # Entry point
├── lua/
│   ├── options.lua             # Vim settings
│   ├── keymaps.lua             # Global keymaps
│   ├── config/lazy.lua         # Plugin manager setup
│   ├── debugging/              # Modular debugging config
│   │   ├── adapters.lua
│   │   ├── configurations.lua
│   │   └── layouts.lua
│   └── plugins/                # Plugin configurations
│       ├── core.lua            # UI & essential plugins
│       ├── lsp.lua             # Language servers
│       ├── completion.lua      # Autocompletion
│       ├── debugging.lua       # DAP debugger
│       ├── ai.lua              # AI assistant
│       ├── git.lua             # Git integration
│       ├── testing.lua         # Test runner
│       ├── formatting.lua      # Code formatting
│       ├── snack.lua           # Picker, explorer, dashboard
│       └── ...                 # More specialized plugins
└── snippets/                   # Custom snippets
```

## Key Features

### 1. Language Support

| Language | LSP | Formatting | Debugging | Testing |
|----------|-----|------------|-----------|---------|
| Lua | lua_ls | stylua | - | - |
| Rust | rust-analyzer | rustfmt | rust-gdb | native |
| Go | gopls | gofmt | delve | gotestsum |
| TypeScript/JavaScript | tsgo/ts_ls | biome/prettier | pwa-node | vitest |
| Svelte | svelte | prettier/biome | pwa-node | - |
| Python | ruff | ruff_format | - | - |
| PHP | intelephense | php_cs_fixer | custom | - |

### 2. Key Mappings

**Leader key:** `<Space>`

#### File Navigation
- `<leader>e` - File explorer
- `<leader>f` - Find files
- `<leader>sb` - Search buffers
- `<leader>sg` - Search Git status
- `<leader>st` - Search text (grep)

The file explorer opens as a float and closes when a file is selected or focus
moves to another window, including when opening a directory from Neogit.

#### Editing
- `<leader>/` - Toggle line comments in normal or visual mode (native Neovim)
- `<leader>c` - Close buffer while preserving window layout (Snacks)
- `<M-3>` - Toggle floating terminal in normal, insert, or terminal mode (Snacks)

#### LSP
- `<leader>lr` - Rename symbol
- `<leader>la` - Code action
- `<leader>lf` - Format document
- `gd` - Go to definition
- `gr` - Find references
- `K` - Hover documentation

#### Git
- `<leader>gg` - Open Neogit
- `<leader>gD` - Open side-by-side diff (file list on the left; conflicts use one editable pane)
- `<leader>gd` - Close Diffview
- `<leader>gI` - Open single-pane unified diff of unstaged changes; `:q` closes it
- Inside Diffview: `<leader>b` toggles the file list; `g<C-x>` cycles layouts
- Inside Diffview conflicts: `<leader>co` accepts current, `<leader>ct` accepts incoming,
  `<leader>ca` accepts both; `[x` / `]x` jump between conflicts. Save with `<leader>w`.
- In ordinary conflict buffers: `co` accepts current, `ct` accepts incoming, `cb` accepts both

#### Debugging
- `<leader>db` - Toggle breakpoint
- `<leader>dc` - Continue/start debugging
- `<leader>di` - Step into
- `<leader>do` - Step over
- `<leader>dt` - Terminate
- `<leader>du` - Toggle the debugger UI globally: close all managed debugger panes
  if any tab has them open; otherwise open in the current tab using the sizes and
  proportions in `lua/debugging/layouts.lua`. Before closing panes in a tab with
  no editor window, restore the first listed non-DAP buffer in an editor split,
  or create an empty `[No Name]` buffer if none exists. The active tab is preserved.
  Partially closed debugger layouts close together on the next toggle.
  Standalone `:DapToggleRepl` windows stay open and do not count as editor windows
  when deciding whether to restore an editor.
- `<leader>dR` - Close debugger panes across tabs and rebuild the complete
  configured layout in the current tab, repairing missing panes and resized splits.

Starting or attaching a debug session preserves existing pane sizes and does not
insert editor splits into UI-only tabs. Editor restoration happens only when
closing the debugger panes.

#### Testing
- `<leader>tt` - Run test under cursor
- `<leader>tf` - Run tests in file
- `<leader>ts` - Toggle test summary
- `<leader>td` - Debug test

#### AI Assistant

[CodeCompanion](https://github.com/olimorris/codecompanion.nvim) opens OpenCode
as a programming mentor in a Neovim chat. Install OpenCode and connect the
model provider you want to use; CodeCompanion uses OpenCode's existing account
and model settings. Open Neovim from the project root so the agent can inspect
the relevant files and dependencies.

- `<leader>ac` - Toggle the last AI chat
- `<leader>an` - Start a new AI chat
- `<leader>ah` - Pick an existing OpenCode session, then open its chat; cancelling creates no session
- `<leader>as` in visual mode - Add the selection to the current chat
- `<C-s>` in the chat - Send your question
- `ga` in the chat's normal mode - Select the OpenCode adapter and change the model
- `gh` in a new chat's normal mode, before sending a message - Resume an OpenCode session

The mentor explains and reviews your code and can search the web. It cannot use
OpenCode's file-editing tools; shell commands and MCP tools ask for approval.
Only the `general` and `explore` subagents are available from this chat, with
the same edit and command restrictions. These permissions apply to OpenCode
started by CodeCompanion and do not change standalone OpenCode settings.
Shell commands and MCP tools can still write files if you approve them. Save
other modified files before asking the agent to read them from disk.

#### AI Completion

[Minuet](https://github.com/milanglacier/minuet-ai.nvim) provides AI completions
as ghost text alongside blink.cmp. Codestral FIM is the default; set
`MISTRAL_API_KEY` in your shell before launching Neovim. To also use
[Granite 4.2 8B through OpenRouter](https://openrouter.ai/ibm-granite/granite-4.2-8b),
set `OPENROUTER_API_KEY` before launching Neovim, then select a configured model:

- `:Minuet change_preset granite` - Use Granite through OpenRouter's chat API,
  with reasoning disabled for faster completions
- `:Minuet change_preset codestral` - Use Codestral through Mistral's FIM API

Use Tab after `:Minuet change_preset ` to complete preset names. Selection lasts
for the current session; restarting Neovim restores Codestral. The built-in
`:Minuet change_model` picker uses Minuet's model catalog, which may omit newer
models; use the presets above to switch between these configured models.

Insert mode uses the bindings from Minuet's
[virtual text quick start](https://github.com/milanglacier/minuet-ai.nvim#virtual-text-setup):

- `<A-A>` (Alt+Shift+a) - Accept the entire suggestion
- `<A-a>` (Alt+a) - Accept one line
- `<A-z>` (Alt+z) - Choose how many lines to accept
- `<M-y>` (Alt+y) - Request completion, or cycle to the next suggestion
- `<A-[>` / `<A-]>` (Alt+[ / Alt+]) - Previous/next suggestion, or request completion
- `<A-e>` (Alt+e) - Dismiss the suggestion

AI requests are manual only, including after the first request. Typing, pausing,
and moving the cursor do not request new AI completions.
Blink uses its default keybindings, plus `<C-j>` / `<C-k>` to navigate its completion
menu. With the menu closed, `<C-k>` toggles signature help. AI ghost text remains
visible while the menu is open.

#### Markdown
- `<M-x>` (Alt+x) - Add an unchecked checkbox to a list item, or toggle an existing
  task checkbox between `[ ]` and `[x]`.
  The buffer-local mapping loads only for Markdown via `after/ftplugin/markdown.lua`.
  Uses Neovim's native Tree-sitter API and the Markdown parser; code blocks and
  non-list text are left unchanged.

### 3. Plugins

**Core:**
- [kanagawa](https://github.com/rebelot/kanagawa.nvim) - Color scheme
- [snacks.nvim](https://github.com/folke/snacks.nvim) - Picker, explorer, dashboard
- [bufferline.nvim](https://github.com/akinsho/bufferline.nvim) - Buffer tabs
- [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) - Status line
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) - Syntax highlighting

**Development:**
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) - LSP configuration
- [blink.cmp](https://github.com/Saghen/blink.cmp) - Autocompletion
- [conform.nvim](https://github.com/stevearc/conform.nvim) - Code formatting
- [nvim-dap](https://github.com/mfussenegger/nvim-dap) - Debugging
- [neotest](https://github.com/nvim-neotest/neotest) - Testing

**Productivity:**
- [CodeCompanion.nvim](https://github.com/olimorris/codecompanion.nvim) and [OpenCode](https://opencode.ai/) - AI mentoring and code review
- [hurl.nvim](https://github.com/jellydn/hurl.nvim) - HTTP testing

**Git:**
- [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) - Git signs
- [neogit](https://github.com/NeogitOrg/neogit) - Git interface

## Tips and Tricks

See [IDE Tips and Tricks](TIPS_AND_TRICKS.md) for search workflows and useful picker syntax.

## Customization

### Adding a Language Server

Edit `lua/plugins/lsp.lua`:

```lua
vim.lsp.config['myserver'] = {
  cmd = { 'myserver', '--stdio' },
  root_markers = { '.git', 'package.json' },
  filetypes = { 'myfiletype' },
}
vim.lsp.enable('myserver')
```

### Adding Formatters

Edit `lua/plugins/formatting.lua`:

```lua
formatters_by_ft = {
  mylang = { 'myformatter' },
}
```

## License

MIT License - Feel free to use and modify as needed.
