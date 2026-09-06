local workspace = Lunar:GetService("Workspace")

for key, value in pairs(workspace) do
  print(key .. ": " .. tostring(value))
end
