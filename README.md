# LazyVim

![Neovim Configuration Preview](preview.png)

My personalized Neovim configuration built on top of [LazyVim](https://github.com/LazyVim/LazyVim).

## 🌟 Features

### 🎨 Theme & Appearance

- Dynamic theme system supporting multiple colorschemes:
  - Tokyo Night
  - Gruvbox
  - Rose Pine
- Automatic theme synchronization with terminal (Ghostty)
- Light/Dark mode toggle support
- Transparent background options

### 🛠️ Customizations

- Enhanced winbar configuration
- Custom icons and symbols
- Optimized editor settings
- Language-specific configurations
- Custom keymaps for improved workflow

### 🔌 Plugin Management

- Organized plugin structure:
  - UI enhancements
  - Editor improvements
  - LSP configurations
  - Additional extras

## 📁 Structure

```
.
├── colors/              # Custom colorschemes
├── lua/
│   ├── config/          # Core configurations
│   │   ├── autocmds.lua # Automatic commands
│   │   ├── keymaps.lua  # Custom keybindings
│   │   ├── lazy.lua     # Lazy.nvim configuration
│   │   └── options.lua  # Neovim options and settings
│   ├── jswent/          # Personal customizations
│   │   ├── colorscheme.lua
│   │   ├── transparent.lua
│   │   ├── winbar.lua
│   │   └── ...
│   └── plugins/         # Plugin configurations
│       ├── editor.lua
│       ├── lsp.lua
│       ├── ui.lua
│       └── ...
├── init.lua            # Entry point
└── preview.png         # Configuration preview image
```

## 🚀 Getting Started

1. Make sure you have Neovim >= 0.9.0 installed
2. Clone this repository to your configuration directory

   ```bash
   git clone https://github.com/jswent/LazyVim.git ~/.config/LazyVim
   ```

3. Backup your Neovim directory and create a symlink

   ```bash
   ln -s ~/.config/LazyVim ~/.config/nvim
   ```

4. Start Neovim and let Lazy.nvim install all plugins

## ⚙️ Configuration

### Core Settings

The configuration is organized into several key files in the `lua/config/` directory:

- `options.lua`: Core Neovim options and settings
- `keymaps.lua`: Custom keybindings for improved workflow
- `autocmds.lua`: Automatic commands for file types
- `lazy.lua`: Lazy.nvim plugin manager configuration

### Theme Settings

The configuration supports automatic theme synchronization with my terminal (Ghostty) and allows manual theme switching. You can override the theme in `lua/config/options.lua`:

```lua
-- set the colorscheme to gruvbox
vim.g.jswent_colorscheme = "gruvbox"
```

### Transparency Settings

The configuration includes built-in transparency support with automatic detection for popular terminal emulators:

- Ghostty
- WezTerm
- Kitty

You can manually control transparency through:

1. Global setting in `lua/config/options.lua`:

   ```lua
   -- Override default transparency detection
   vim.g.jswent_transparent = true -- or false
   ```

2. Commands during runtime:
   - `:EnableTransparent` - Enable transparency
   - `:DisableTransparent` - Disable transparency
   - `:ToggleTransparent` - Toggle transparency state

The transparency settings automatically reload affected plugins and colorschemes to ensure consistent appearance.

### Plugin Management

All plugins are managed through Lazy.nvim and can be configured in the `lua/plugins/` directory:

- `ui.lua`: UI-related plugins
- `editor.lua`: Editor enhancement plugins
- `lsp.lua`: Language Server Protocol configurations
- `extras.lua`: Additional plugin configurations

## 📝 License

This configuration is licensed under the same terms as LazyVim. See the [LICENSE](LICENSE) file for details.
