local ErrorService = Lunar:GetService("ErrorService")
local ConsoleService = Lunar:GetService("ConsoleService")

-- Error is an instance created by ErrorService

ErrorService.OnError:Connect(function(Error)
  ConsoleService:Error("%s: %s\nTraceback:\n%s", Error.Type, Error.Message, Error.Traceback)
end)

local Error = ErrorService:Create("TestError", "This is an example", ErrorService:Traceback())
ErrorService:Error(Error)
