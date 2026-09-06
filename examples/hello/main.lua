local instance = Instance.new()
instance.Name = "Hello"

for key, value in pairs(instance) do
  print(key .. ": " .. tostring(value))
end
