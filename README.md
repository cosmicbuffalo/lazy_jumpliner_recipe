# Lazy Jump-liner Recipe

This `Lazy.nvim` recipe provides a simple way to integrate both `mini.jump` and `eyeliner.nvim` into your Neovim config.

# 📦 Installation

[Lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
return {
    "cosmicbuffalo/lazy_jumpliner_recipe",
    opts = {
        enable_eyeliner_by_default = true, -- when this is false, you can enable it with the keymap `<leader>uf`
        enable_mini_jump = true, -- set to false if you don't want mini.jump
    },
}
```
