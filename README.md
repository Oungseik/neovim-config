# Neovim Configuration

A modern, modular Neovim configuration built with Lua and [lazy.nvim](https://github.com/folke/lazy.nvim) plugin manager.

## Overview

This configuration transforms Neovim into a full-featured IDE with:
- **Modern plugin manager** (lazy.nvim) with lazy loading for fast startup
- **LSP support** for 15+ languages (Rust, Go, TypeScript, Python, PHP, etc.)
- **Intelligent completion** with blink.cmp (Rust-based engine)
- **Powerful debugging** with nvim-dap and custom adapters
- **AI assistant integration** with opencode.nvim
- **Git workflow** integration (gitsigns, neogit, lazygit, diffview)
- **File navigation** with harpoon and snacks.nvim picker

## Requirements

- Neovim 0.10+ (uses modern LSP features)
- Git
- A [Nerd Font](https://www.nerdfonts.com/) for icons

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
│       ├── harpoon.lua         # File marking
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
- `<leader>sg` - Grep search
- `<leader>m` - Harpoon marks

#### LSP
- `<leader>lr` - Rename symbol
- `<leader>la` - Code action
- `<leader>lf` - Format document
- `gd` - Go to definition
- `gr` - Find references
- `K` - Hover documentation

#### Git
- `<leader>gg` - Open Neogit
- `<leader>gl` - Open LazyGit
- `<leader>gd` - Diff view
- `<leader>gc` - Git conflicts

#### Debugging
- `<leader>db` - Toggle breakpoint
- `<leader>dc` - Continue/start debugging
- `<leader>di` - Step into
- `<leader>do` - Step over
- `<leader>dt` - Terminate

#### Testing
- `<leader>tt` - Run test under cursor
- `<leader>tf` - Run tests in file
- `<leader>ts` - Toggle test summary
- `<leader>td` - Debug test

#### AI Assistant
- `<leader>ac` - Open chat
- `<leader>ai` - Inline edit
- `<leader>ae` - Explain code

### 3. Plugins

**Core:**
- [catppuccin](https://github.com/catppuccin/nvim) - Color scheme
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
- [harpoon](https://github.com/ThePrimeagen/harpoon) - File marking
- [opencode.nvim](https://github.com/opencode-ai/opencode) - AI assistant
- [hurl.nvim](https://github.com/jellydn/hurl.nvim) - HTTP testing

**Git:**
- [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) - Git signs
- [neogit](https://github.com/NeogitOrg/neogit) - Git interface
- [lazygit.nvim](https://github.com/kdheepak/lazygit.nvim) - LazyGit integration

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
