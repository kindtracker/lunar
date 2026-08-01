# Mengine

Mengine is a lightweight engine that uses Lua for scripting.

## Example
```lua
local gfx = mengine:getservice("gfx:2d");
local win = gfx:init("meow", 800, 600)
local ctx = win:getcontext()

for i = 1, 60 do
  ctx:clear()
  ctx:text("meow", 0, 0)
  ctx:end_frame()
end
win:free()
```

## Requirements

- C compiler
- Make
- Lua 5.5
- SDL2
- SDL2_ttf

## Installation
```sh
git clone https://github.com/kindtracker/mengine
cd mengine
make
# add the mengine executable (build/mengine) to your PATH
```

## Lua API
### Cheatsheet
```lua
mengine:getservice(service_name); -- example: gfx:2d

gfx:init(title, width, height)

win:getcontext()
win:quit()
win.width
win.height

ctx:clear()
ctx:text(text, x, y)
ctx:end_frame()
```

### Services
- **gfx:2d** used to make 2D graphics

### `mengine`
- `mengine:getservice(service_name)` returns a service object.

### `gfx`
- `gfx:init(title, width, height)` creates a window and returns an object (called "win").

### `win`
- `win:getcontext()` gets the rendering context (called "ctx").
- `win:quit()` closes the window and free memory.
- `win.width` the width of window.
- `win.height` the height of window.

### `ctx`
- `ctx:clear()` clear the window with #000000
- `ctx:text(text, x, y)` draw text
- `ctx:end_frame()` end the frame

## Contributing
Contributing will be accepted

## Credits

- **Lua** — used as Mengine's scripting language.

- **SDL2** — used as Mengine's rendering backend.

## License

This project is licensed under the GNU General Public License v3.0 or later.
See the [LICENSE](LICENSE) file for details.
