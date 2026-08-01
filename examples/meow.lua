local gfx = mengine:getservice("gfx:2d");
local win = gfx:init("meow", 800, 600)
local ctx = win:getcontext()

for i = 1, 60 do
  ctx:clear()
  ctx:text("meow", 0, 0)
  ctx:end_frame()
end
win:quit()
