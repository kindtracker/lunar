local ErrorModule = {}
local ErrorService
local Instance
local Signal

function ErrorModule.new()
  return {
    Type = "?",
    Message = "?",
    Traceback = "?",
  }
end

function ErrorModule.__Lunar_Internal__Init__(instance, signal)
  Instance = instance
  Signal = signal

  ErrorService = Instance.new("Service")
  ErrorService.Name = "ErrorService"
  ErrorService.ErrorHandler = Signal.new()
  ErrorService.AlwaysPrintError = false

  function ErrorService:Traceback(Level)
    Level = (Level or 1) + 1
    return debug.traceback(nil, Level):gsub("stack traceback:\n", "")
  end

  function ErrorService:Create(Type, Message, Traceback)
    local ErrorInstance = Instance.new("Error")
    ErrorInstance.Type = Type
    ErrorInstance.Message = Message
    ErrorInstance.Traceback = Traceback

    return ErrorInstance
  end

  function ErrorService:Error(ErrorInstance)
    ErrorService.ErrorHandler:Fire(ErrorInstance)
    if ErrorService.AlwaysPrintError == true then
      ErrorService:Print(ErrorInstance)
    end
  end

  function ErrorService:Print(ErrorInstance)
    print(
      string
        .format("\27[1;31m%s:\27[0m %s\n%s", ErrorInstance.Type, ErrorInstance.Message, ErrorInstance.Traceback)
        :gsub("	", "   ")
    )
  end

  return ErrorService
end

return ErrorModule
