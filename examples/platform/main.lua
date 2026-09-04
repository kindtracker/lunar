-- platform example is incomplete yet

local gfx = lunar:getservice("gfx:2d")
local assets = lunar:getservice("assets")
local win = gfx:init("Platform game!", 800, 550)
local ctx = win:getcontext()
assets:init("sdl", win)

local player_tex = assets:image("assets/player.png")

while not ctx:end_frame() do
  ctx:color(44, 164, 230)
  ctx:clear()

  ctx:camera(0, 0, 3)
  ctx:image_part(player_tex, 0, 0, 16, 16, 16, 16, 32, 32)
end
win:quit()
