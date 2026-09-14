local Task = Lunar:GetService("TaskService")

Task:Spawn(function()
  local i = 4
  while true do
    i = i + 1
    print("Thread 1:", i)

    Task.wait(1 / 4)
  end
end)

Task:Spawn(function()
  local i = 0
  while true do
    i = i + 4
    print("Thread 2:", i)

    Task.wait(1)
  end
end)

while true do
  Task:Step()
end
