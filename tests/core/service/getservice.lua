local Services = {
  "ConsoleService",
  "FileSystemService",
  "TimeService",
  "ErrorService",
  "TaskService",
  "JSONService",
  "LMathService",
  "LTableService",
}

if Lunar.GetService == nil then
  return "Lunar.GetService = nil"
end

for _, ServiceName in pairs(Services) do
  local Service = Lunar:GetService(ServiceName)
  if Service == nil then
    return string.format('Lunar:GetService("%s") = nil', ServiceName)
  end
end

return true
