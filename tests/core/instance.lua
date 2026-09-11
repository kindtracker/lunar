local instance = Instance.new()

if instance == nil then
  return nil
end

instance.Name = "Test"

return instance.Name == "Test"
