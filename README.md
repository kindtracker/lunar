# Lunar Engine

Lunar is a lightweight 2D engine for building applications, headless programs, and games with Lua. It is distributed as a single-header C library.

## Example
```lua
local gfx = lunar:getservice("gfx:2d")
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
- SDL2_image

## Installation
```sh
git clone https://github.com/kindtracker/lunar
cd lunar
make
# add the lunar executable (build/lunar) to your PATH
```

## Lua API
### Cheatsheet
```lua
 -- the only supported backend is "sdl" (SDL2) for now

lunar:getservice(service_name) -- example: gfx:2d
lunar:wait(sec)
lunar:time()

lunar.log(format, ...)
lunar.info(format, ...)
lunar.warn(format, ...)
lunar.error(format, ...)
lunar.fatal(format, ...)

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
ctx:image(image, x, y, w?, h?) -- if w or h is not set, it will use original size
ctx:image_part(tiles,
    sx, sy, sw, sh,
    dx, dy, dw?, dh?) -- s: source d: destination

ctx:line_width(size)
ctx:pixel(x, y)
ctx:line(x1, y1, x2, y2)
ctx:rect(x, y, w, h)
ctx:rect_fill(x, y, w, h)
ctx:circ(x, y, r)
ctx:circ_fill(x, y, r)
ctx:arc(x, y, r, start_angle, end_angle)
ctx:arc_fill(x, y, r, start_angle, end_angle)
ctx:tri(x1, y1, x2, y2, x3, y3)
ctx:tri_fill(x1, y1, x2, y2, x3, y3)

input:init(backend, win)

input:key_held(key)
input:held(key)
input:key_down(key)
input:down(key)
input:key_up(key)
input:up(key)
input:mouse() -- returns x, y, left, right, middle

assets:init(backend, win)
assets:image(path)

-- Planned APIs (not implemented yet)
-- v v v v v v v v v v v v v v v v v v v

assets:font(path)
assets:sound(path)
assets:music(path)

ctx:font(font)

lunar.log_callback(func)

```

### Services
- **gfx:2d** used to make 2D graphics
- **input** used to get input from window
- **assets** used to load assets (not fully implemented)

### `lunar`
- `lunar:getservice(service_name)` returns a service object.

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
Contributions are welcome.

## Credits
- **Lua** — used as lunar's scripting language.
- **SDL2, SDL2_image, SDL2_ttf** — used as lunar's rendering backend.

## License
This project is licensed under the GNU General Public License v3.0 or later.
See the [LICENSE](LICENSE) file for details.
