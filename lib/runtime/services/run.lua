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
  local UDuration = 1 / 24
  local LastTime = TimeService:PreciseNow()

  function RunModule.__Lunar_Internal__Cycle__()
    TaskService.delay(UDuration, function()
      local Now = TimeService:PreciseNow()
      local DeltaTime = Now - LastTime
      LastTime = Now

      RunService.Stepped:Fire(DeltaTime)
      RunService.Heartbeat:Fire(DeltaTime)
      RunModule.__Lunar_Internal__Cycle__()
    end)
  end

  RunModule.__Lunar_Internal__Cycle__()

  return RunService
end

return RunModule
