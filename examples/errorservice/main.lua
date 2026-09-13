local ErrorService = Lunar:GetService("ErrorService")

-- Error is an instance created by ErrorService

ErrorService.AlwaysPrintError = false -- You can set ErrorService.AlwaysPrintError to true when you have no ErrorHandler

ErrorService.ErrorHandler:Connect(function(Error)
  ErrorService:Print(Error)
end)

local Error = ErrorService:Create("TestError", "This is an example", ErrorService:Traceback())
ErrorService:Error(Error)
