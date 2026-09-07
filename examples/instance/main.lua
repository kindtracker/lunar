local Workspace = Lunar:GetService("Workspace")

print("Creating instances")

local Kind = Instance.new()
local Tracker = Instance.new()

Kind.Name = "Kind"
Tracker.Name = "Tracker"

print("Workspace:GetChildren():")
for _, Child in pairs(Workspace:GetChildren()) do
  print(Child.Name, Child.Parent)
end

print("Assigning them to Workspace")

Kind.Parent = Workspace
Tracker.Parent = Workspace

print("Workspace:GetChildren():")
for _, Child in pairs(Workspace:GetChildren()) do
  print(Child.Name, Child.Parent)
end
