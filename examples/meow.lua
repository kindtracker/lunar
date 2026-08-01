local gfx = mengine:getservice("gfx:2d");
local win = gfx:init("Meow!", 800, 600, 60)
local ctx = win:getcontext()

local x = 0
local y = 0
local vx = 400
local vy = 400

while not ctx:end_frame() do
  ctx:clear()
  ctx:text("meow", x, y)
  
  local dt = ctx:delta_time()
  x=x+vx*dt
  y=y+vy*dt

  if x >= win.width-24*3 then
    vx=-vx
  elseif x < 0 then
    vx=-vx
  elseif y >= win.height-24 then
    vy=-vy
  elseif y < 0 then
    vy=-vy
  end
end
win:quit()
