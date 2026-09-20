local RunModule = {}
local RunService
local Instance
local Signal
local TaskService
local TimeService

function RunModule.__Lunar_Internal__Init__(instance, signal, taskservice, timeservice)
  Instance = instance
  Signal = signal
  TaskService = taskservice
  TimeService = timeservice

  RunService = Instance.new("Service")
  RunService.Name = "RunService"
  RunService.Stepped = Signal.new()
  RunService.Heartbeat = Signal.new()
  RunService.IsServerBool = true
  local UDuration = 1 / 24
  local LastTime = TimeService:PreciseNow()

  function RunService.__Lunar_Internal__Cycle__()
    TaskService.delay(UDuration, function()
      local Now = TimeService:PreciseNow()
      local DeltaTime = Now - LastTime
      LastTime = Now

      RunService.Stepped:Fire(DeltaTime)
      RunService.Heartbeat:Fire(DeltaTime)
      RunService.__Lunar_Internal__Cycle__()
    end)
  end

  function RunService:SetServerMode()
    RunService.IsServerBool = true
  end

  function RunService:SetClientMode()
    RunService.IsServerBool = false
  end

  function RunService:IsClient()
    return not RunService.IsServerBool
  end

  function RunService:IsServer()
    return RunService.IsServerBool
  end

  RunService.__Lunar_Internal__Cycle__()
  return RunService
end

return RunModule
