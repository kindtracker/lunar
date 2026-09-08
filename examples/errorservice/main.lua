local ErrorService = Lunar:GetService("ErrorService")
local ConsoleService = Lunar:GetService("ConsoleService")

-- Error is an instance created by ErrorService

ErrorService.OnError:Connect(function(Error)
  ErrorService:Print(Error)
end)

local Error = ErrorService:Create("TestError", "This is an example", ErrorService:Traceback())
ErrorService:Error(Error)
