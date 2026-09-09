local RunService = Lunar:GetService("RunService")
local Task = Lunar:GetService("TaskService")

RunService.Stepped:Connect(function(DeltaTime)
  print(DeltaTime, 1/DeltaTime)
end)

while true do
  Task:Step()
end
