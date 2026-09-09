local TaskModule = {}
local TaskService
local Instance

function TaskModule.new()
  local self = {
    Function = nil,
    Thread = nil
  }

  function self:Initialize()
    self.Thread = coroutine.create(self.Function)
  end

  function self:Status()
    local StatusList = {
      ["suspended"] = "Suspended",
      ["running"] = "Running",
      ["normal"] = "Running",
      ["dead"] = "Dead"
    }
    return StatusList[coroutine.status(self.Thread)]
  end

  function self:Resume(...)
    coroutine.resume(self.Thread, ...)
  end

  return self
end

function TaskModule.__Lunar_Internal__Init__(instance)
  Instance = instance

  TaskService = Instance.new("TaskService")
  TaskService.Name = "TaskService"

  TaskService.Threads = {}

  function TaskService:Spawn(Function)
    local Thread = Instance.new("Thread")
    Thread.Function = Function
    Thread:Initialize()

    table.insert(TaskService.Threads, Thread)
    return Thread
  end

  function TaskService:Yield(...)
    return coroutine.yield(...)
  end

  function TaskService:Step()
    for _, Thread in ipairs(TaskService.Threads) do
      if Thread:Status() ~= "Dead" then
        Thread:Resume()
      end
    end
  end

  return TaskService
end

return TaskModule
