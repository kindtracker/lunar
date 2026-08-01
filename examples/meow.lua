local gfx = mengine:getservice("gfx:2d");
local win = gfx:init("Meow!", 800, 600, 60)
local ctx = win:getcontext()

while not ctx:end_frame() do
  ctx:clear()
  ctx:text("meow", 0, 0)
end
win:quit()
