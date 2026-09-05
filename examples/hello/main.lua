local instance = Instance.new()
instance.Name = "Test"

for k, v in pairs(instance) do
  print(k .. ": " .. tostring(v))
end
