# Mengine

Mengine is a lightweight engine that uses Lua for scripting.

## Example
```lua
local gfx = mengine:getservice("gfx:2d");
local win = gfx:init("meow", 800, 600)
local ctx = win:getcontext()

while not ctx:end_frame() do
  ctx:color(0, 0, 0)
  ctx:clear()
  ctx:color(255, 255, 255)
  ctx:text("meow", 0, 0)
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
mengine:wait(sec)
mengine:time()

mengine.log(fornat, ...)
mengine.info(fornat, ...)
mengine.warn(format, ...)
mengine.error(format, ...)
mengine.fatal(format, ...)

gfx:init(title, width, height, target_fps?) -- default target fps is 60

win:getcontext()
win:quit()
win.width
win.height

ctx:color(r, g, b, a?) -- default alpha is 255
ctx:clear()
ctx:end_frame()
ctx:target_fps(target_fps?)
ctx:delta_time()
ctx:text(text, x, y)

ctx:thick(size)
ctx:rect(x, y, w, h)
ctx:rect_fill(x, y, w, h)
ctx:circ(x, y, r)
ctx:circ_fill(x, y, r)
ctx:arc(x, y, r, start_angle, end_angle);
ctx:arc_fill(x, y, r, start_angle, end_angle);
ctx:tri(x1, y1, x2, y2, x3, y3)
ctx:tri_fill(x1, y1, x2, y2, x3, y3)

input:init(backend, win) -- single backend is "sdl" (SDL2)

input:key_held(key)
input:held(key)
input:key_down(key)
input:down(key)
input:key_up(key)
input:up(key)
input:mouse() -- returns x, y, left, right, middle

-- TODO (this api is not implemented yet)
-- v v v v v v v v v v v v v v v v v v v

gfx:font(pathname)
ctx:font(font)

mengine.platform
mengine:quit()

mengine.log_callback(func)
```

### Services
- **gfx:2d** used to make 2D graphics
- **input** used to get input from window

### `mengine`
- `mengine:getservice(service_name)` returns a service object.

### `gfx`
- `gfx:init(title, width, height)` creates a window and returns an object (called "win").

### `win`
- `win:getcontext()` gets the rendering context (called "ctx").
- `win:quit()` closes the window and free memory.
- `win.width` the width of window.
- `win.height` the height of window.

### `input`
- `input:init(backend, win)` initalize the input, single backend is "sdl" (SDL2)

## Contributing
Contributing will be accepted

## Credits
- **Lua** — used as Mengine's scripting language.
- **SDL2** — used as Mengine's rendering backend.

## License
This project is licensed under the GNU General Public License v3.0 or later.
See the [LICENSE](LICENSE) file for details.
