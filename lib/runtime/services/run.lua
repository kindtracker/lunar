local RunModule = {}
local RunService
local Instance
local Signal
local TaskService

function RunModule.__Lunar_Internal__Init__(instance, signal, taskservice)
  Instance = instance
  Signal = signal
  TaskService = taskservice

  RunService = Instance.new("RunService")
  RunService.Name = "RunService"
  RunService.Stepped = Signal.new()
  RunService.Heartbeat = Signal.new()
  local UDuration = 1/24

  function RunModule.__Lunar_Internal__Cycle__()
    TaskService.delay(UDuration, function()
      RunService.Stepped:Fire()
      RunService.Heartbeat:Fire()
      RunModule.__Lunar_Internal__Cycle__()
    end)
  end

  RunModule.__Lunar_Internal__Cycle__()

  return RunService
end

return RunModule
