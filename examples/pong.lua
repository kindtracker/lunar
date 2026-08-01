local gfx = mengine:getservice("gfx:2d");
local input = mengine:getservice("input");
local win = gfx:init("Pong", 800, 600, 60)
local ctx = win:getcontext()
input:init("sdl", win)

local y = 0
local i = 0

while not ctx:end_frame() do
  ctx:clear()
  print(input:held())
end
win:quit()
