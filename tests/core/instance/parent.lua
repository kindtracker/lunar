local instance = Instance.new()

if instance == nil then
  return "instance = nil"
end

instance.Name = "Test"

if instance.Name ~= "Test" then
  return 'instance.Name ~= "Test"'
end

local Workspace = Lunar:GetService("Workspace")

if Workspace == nil then
  return "Workspace = nil"
end

instance.Parent = Workspace

if instance.Parent ~= Workspace then
  return "instance.Parent ~= Workspace"
end

if Workspace:FindFirstChild("Test") then
  return true
end

return 'Workspace doesn\'t has "Test" instance after adding "Test" instance to Workspace'
