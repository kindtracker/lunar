local gfx = mengine:getservice("gfx");
local input = mengine:getservice("input");
local win = gfx:init("Pong", 700, 450, 60)
local ctx = win:getcontext()
input:init("sdl", win)

local y = 10

local bx = 700/2-5
local by = 450/2-5
local vx = -8
local vy = -8

while not ctx:end_frame() do
  ctx:color(0, 0, 0)
  ctx:clear()
  
  ctx:color(255, 255, 255)
  ctx:rect_fill(10, y, 20, 80)
  ctx:color(255, 0, 0)
  ctx:rect_fill(bx, by, 10, 10)

  if input:key_held("S") then
    y = y + 8
  elseif input:key_held("W") then
    y = y -8
  end
  if y > win.height - 90 then
    y = y - 8
  elseif y < 10 then
    y = y + 8
  end

  bx = bx + vx
  by = by + vy

  if bx <= 30 then
    if by >= y and by <= y+80 then
      vx = -vx
      mengine.log("Pong!")
    else
      if bx <= -10 then
        bx = 700/2-5
        by = 450/2-5
      end
    end
  end
  if by <= 0 then
    vy = -vy
  elseif by >= win.height then
    vy = -vy
  end
  if bx >= win.width then
    vx = -vx
  end
end
win:quit()
