local RunService = Lunar:GetService("RunService")
local Task = Lunar:GetService("TaskService")

RunService.Stepped:Connect(function(DeltaTime)
  print("Stepped", DeltaTime, 1/DeltaTime)
end)

RunService.Heartbeat:Connect(function(DeltaTime)
  print("Heartbeat", DeltaTime, 1/DeltaTime)
end)

while true do
  Task:Step()
end
