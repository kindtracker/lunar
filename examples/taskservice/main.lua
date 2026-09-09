local Task = Lunar:GetService("TaskService")

local Cooldown = 1*1000*1000*10

Task:Spawn(function()
  local i = 0
  while true do
    for i = 0, Cooldown do

    end
    i=i+1
    print("Thread:", i)

    Task:Yield()
  end
end)

local i = 0
while true do
  for i = 0, Cooldown do

  end
  i=i+2
  print("Thread Main:", i)

  Task:Step()
end
