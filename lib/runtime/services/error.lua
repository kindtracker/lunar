local ErrorModule = {}
local ErrorService
local Instance
local Signal

function ErrorModule.__Lunar_Internal__Init__(instance, signal)
  Instance = instance
  Signal = signal

  ErrorService = Instance.new("ErrorService")
  ErrorService.Name = "ErrorService"
  ErrorService.ErrorSignals = {}
  
  function ErrorService:Error(Type, ...)
    for _, signal in ErrorService.ErrorSignals do
      signal:Fire(Type, ...)    
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
