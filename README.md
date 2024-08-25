# Silicon

A very simple wrapper for [silicon] in [neovim].

[silicon]: https://github.com/Aloxaf/silicon
[neovim]: https://github.com/neovim/neovim/

> [!NOTE]
> For WSL support and more extended behavior, please see 
> [michaelrommel/nvim-silicon] as this plugin is heavily inspired by his.

[michaelrommel/nvim-silicon]: https://github.com/michaelrommel/nvim-silicon

## Index
<!--toc:start-->
- [Silicon](#silicon)
  - [How it works](#how-it-works)
  - [Installing](#installing)
    - [Lazy](#lazy)
  - [Configuring](#configuring)
    - [Example: Catppuccin](#example-catppuccin)
<!--toc:end-->

## How it works
The plugin uses neovim's `vim.bo.filetype` and visual mode markers when 
available to automatically get the language and the code to send it to 
silicon.


## Installing
### Lazy
To install this plugin using [Lazy]:
```lua
{
    "kenielf/silicon.nvim",
    event = "VeryLazy",
    config = function()
        local silicon = require("silicon")
        silicon.setup({options})

        vim.keymap.set({"n", "v"}, silicon.screenshot, { desc = "Take a screenshot of your code" })
    end,
},
```

[Lazy]: https://github.com/folke/lazy.nvim

## Configuring
All configurations passed to this plugin are sent straight to `silicon`,
and any `_`s in the configuration keys are replaced with `-`s.

For arguments without a parameter, such as `--no-round-corner`, simply 
setting them to `true` is enough.
*`false` is not supported, comment the option instead*.

### Example: Catppuccin
This is an example of a full configuration using catppuccin:
```lua
local mocha = require("catppuccin.palettes").get_palette("mocha")
local flavour = require("catppuccin").flavour

local options = {
    font = "Iosevka Term=24;Noto Color Emoji=24",
    theme = "Catppuccin-" .. flavour,
    background = mocha.base,
    pad_horiz = 40,
    pad_vert = 40,
    shadow_blur_radius = 0,
    shadow_offset_x = 0,
    shadow_offset_y = 0,
    no_round_corner = true,
    no_window_controls = true,
    to_clipboard = true,
}

local silicon = require("silicon")
silicon.setup(options)

vim.keymap.set(
    "v", "<leader>sc", silicon.screenshot,
    { desc = "Take a screenshot of the code", silent = true }
)
```

> [!WARNING]
> Silicon themes follow the [bat] format, so any non default themes must be 
> added and refreshed with `silicon --build-cache` manually!
> 
> Since "Catppuccin-mocha" is not a default flavour, it was saved and renamed
> from [catppuccin/bat] as a file inside of `~/.config/silicon/themes`!

[bat]: https://github.com/sharkdp/bat
[catppuccin/bat]: https://github.com/catppuccin/bat
