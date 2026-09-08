local ErrorModule = {}
local ErrorService
local Instance
local Signal

function ErrorModule.new()
  return {
    Type = "?",
    Message = "?",
    Traceback = "?"
  }
end

function ErrorModule.__Lunar_Internal__Init__(instance, signal)
  Instance = instance
  Signal = signal

  ErrorService = Instance.new("ErrorService")
  ErrorService.Name = "ErrorService"
  ErrorService.ErrorSignals = {}

  function ErrorService:Traceback(Message, Level)
    return debug.traceback(Message, Level)
  end

  function ErrorService:Create(Type, Message, Traceback)
    local ErrorInstance = Instance.new("Error")
    ErrorInstance.Type = Type
    ErrorInstance.Message = Message
    ErrorInstance.Traceback = Traceback

    return ErrorInstance
  end

  function ErrorService:Error(ErrorInstance)
    for _, signal in ErrorService.ErrorSignals do
      signal:Fire(signal)
    end
  end

  function ErrorService:OnError()
    local signal = Signal.new()
    table.insert(ErrorService.ErrorSignals, signal)
    return signal
  end

  return ErrorService
end

return ErrorModule
