local Task = Lunar:GetService("TaskService")

Task:Spawn(function()
  local i = 0
  while true do
    i=i+1
    print("Thread 1:", i)
    
    Task.wait(0.5)
  end
end)

Task:Spawn(function()
  local i = 0
  while true do
    i=i+2
    print("Thread 2:", i)

    Task.wait(1)
  end
end)

while true do
  Task:Step()
end
