local instance = Instance.new()

if instance == nil then
  return "instance = nil"
end

instance.Name = "Test"

if instance.Name ~= "Test" then
  return 'instance.Name ~= "Test"'
end

return true
