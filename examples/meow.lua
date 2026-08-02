local gfx = mengine:getservice("gfx:2d");
local win = gfx:init("Meow!", 800, 600, 60)
local ctx = win:getcontext()

local x = 0
local y = 0
local vx = 400
local vy = 400

local r = 0

while not ctx:end_frame() do
  ctx:color(0, 0, 0)
  ctx:clear()
  ctx:color(r, 0, 0)
  ctx:text("meow", x, y)
  
  r = r + 16

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
