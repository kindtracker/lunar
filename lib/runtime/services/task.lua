local TaskModule = {}
local TaskService
local Instance
local TimeService

function TaskModule.new()
  local self = {
    Function = nil,
    Thread = nil,
    Waiting = false
  }

  function self:Initialize()
    self.Thread = coroutine.create(self.Function)
  end

  function self:GetStatus()
    local StatusList = {
      ["suspended"] = "Suspended",
      ["running"] = "Running",
      ["normal"] = "Running",
      ["dead"] = "Dead"
    }

    return StatusList[coroutine.status(self.Thread)]
  end

  function self:Resume(...)
    local Success, Error = coroutine.resume(self.Thread, ...)

    if not Success then
      error(Error, 0)
    end
  end

  return self
end

function TaskModule.__Lunar_Internal__Init__(instance, timeservice)
  Instance = instance
  TimeService = timeservice

  TaskService = Instance.new("TaskService")
  TaskService.Name = "TaskService"

  TaskService.Threads = {}
  TaskService.Waiting = {}

  function TaskService:Spawn(Function)
    local Thread = Instance.new("Thread")
    Thread.Function = Function
    Thread:Initialize()

    TaskService.Threads[Thread] = Thread
    return Thread
  end

  function TaskService:Yield(...)
    return coroutine.yield(...)
  end

  function TaskService:Step()
    local Now = TimeService:PreciseNow()

    for i = #TaskService.Waiting, 1, -1 do
      local Waiting = TaskService.Waiting[i]

      if Now >= Waiting.Until then
        table.remove(TaskService.Waiting, i)

        Waiting.Thread.Waiting = false
        Waiting.Thread:Resume()
      end
    end

    for _, Thread in pairs(TaskService.Threads) do
      if Thread:GetStatus() ~= "Dead" and not Thread.Waiting then
        Thread:Resume()
      end
    end
  end

  function TaskService.wait(Duration)
    local Coroutine = coroutine.running()
    local Thread
    for _, value in pairs(TaskService.Threads) do
      if value.Thread == Coroutine then
        Thread = value
        break
      end
    end

    if not Thread then
      Thread = Instance.new("Thread")
      Thread.Thread = Coroutine
      TaskService.Threads[Thread] = Thread
    end

    Thread.Waiting = true

    table.insert(TaskService.Waiting, {
      Thread = Thread,
      Until = TimeService:PreciseNow() + Duration
    })

    return coroutine.yield()
  end

  function TaskService.delay(Duration, Function)
    return TaskService:Spawn(function()
      TaskService.wait(Duration)
      Function()
    end)
  end

  return TaskService
end

return TaskModule
