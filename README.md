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

input:init(backend, win)

input:key_held(key)
input:held(key)
input:key_down(key)
input:down(key)
input:key_up(key)
input:up(key)

-- TODO (this api is not implemented yet)
gfx:rect(x, y, w, h)
gfx:rect_fill(x, y, w, h)
gfx:circ(x, y, r)
gfx:circ_fill(x, y, r)
gfx:tri(x1, y1, x2, y2, x3, y3)
gfx:tri_fill(x1, y1, x2, y2, x3, y3)
gfx:font(pathname)

input:mouse() -- returns x, y

mengine.platform
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

### `ctx`
- `ctx:color(r, g, b, a?)` set the fill/stroke color with r,g,b,a (0-255)
- `ctx:clear()` clear the window with #000000
- `ctx:end_frame()` end the frame and returns if window should closed
- `ctx:target_fps(target_fps?)` returns target fps and you can put target fps
- `ctx:delta_time()` returns delta time
- `ctx:text(text, x, y)` draw text

### `input`
- `input:init(backend, win)` initalize the input
- `input:key_held(key)` check if key is being held
- `input:held()` get all keys being held
- `input:key_down(key)` check if key is down
- `input:down()` get all keys being down
- `input:key_up(key)` check if key is up
- `input:up()` get all keys being up

## Contributing
Contributing will be accepted

## Credits
- **Lua** — used as Mengine's scripting language.
- **SDL2** — used as Mengine's rendering backend.

## License
This project is licensed under the GNU General Public License v3.0 or later.
See the [LICENSE](LICENSE) file for details.
