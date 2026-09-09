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

  function TaskService:Spawn(Function, Start) 
    if Start == nil then
      Start = true
    end

    local Thread = Instance.new("Thread")

    Thread.Function = Function
    Thread:Initialize()

    if Start == true then
      Thread:Resume()
    end

    return Thread
  end

  return TaskService
end

return TaskModule
