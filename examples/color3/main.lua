local Task = Lunar:GetService("TaskService")

Task:Spawn(function()
  local Hue = 0
  while true do
    Hue = Hue + 0.001
    local Color = Color3.fromHSV(Hue, 0.5, 0.75)
    print(Color.R, Color.G, Color.B)
    Task:Wait(0.01)
  end
end)

while true do
  Task:Step()
end
