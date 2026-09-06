local instance = Instance.new()

print("Setuping on 'Name' property")
instance:GetPropertyChangedSignal("Name"):Connect(function(newValue, oldValue)
  print("'Name' property changed from " .. oldValue .. " to " .. newValue)
end)

print("Changing instance's name to Hello")
instance.Name = "Hello"
print("Changing instance's name to 123")
instance.Name = "123"
