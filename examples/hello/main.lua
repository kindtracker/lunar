local instance = Instance.new()
instance.Name = "Hello"

for k, v in pairs(instance) do
  print(k .. ": " .. tostring(v))
end
