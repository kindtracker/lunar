local gfx = mengine:getservice("gfx:2d");
local input = mengine:getservice("input");
local win = gfx:init("Pong", 700, 450, 60)
local ctx = win:getcontext()
input:init("sdl", win)

while not ctx:end_frame() do
  ctx:color(192, 192, 192)
  ctx:clear()
  
  local x, y, left, right, middle = input:mouse()
  local r = left and 255 or 0
  local g = right and 255 or 0
  local b = middle and 255 or 0
  ctx:color(r, g, b)
  ctx:circ_fill(x, y, 10)
end
win:quit()
