local RandomService = Lunar:GetService("RandomService")
local Task = Lunar:GetService("TaskService")
local RNG = RandomService.new()

Task:Spawn(function()
  while true do
    print(RNG:NextNumber())
    Task.wait(0.1)
  end
end)

while true do
  Task:Step()
end
