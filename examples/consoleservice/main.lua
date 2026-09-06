local console = Lunar:GetService("ConsoleService")

for key, value in pairs(console) do
  print(key .. ": " .. tostring(value))
end

console:Log("Logging...")
