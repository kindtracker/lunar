local gfx = mengine:getservice("gfx:2d")
local assets = mengine:getservice("assets")
local input = mengine:getservice("input")
local win = gfx:init("Meow!", 800, 600, 60)
local ctx = win:getcontext()
input:init("sdl", win)
assets:init("sdl", win)

local image = assets:image("lua.svg")

while not ctx:end_frame() do
  ctx:color(192, 192, 192)
  ctx:clear()

  local x, y, left, right, middle = input:mouse()
  ctx:image(image, x, y, 64, 64)
end
win:quit()
