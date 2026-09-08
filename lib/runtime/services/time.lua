local TimeModule = {}
local TimeService
local Instance

function TimeModule.__Lunar_Internal__Init__(instance)
  Instance = instance

  TimeService = Instance.new("TimeService")
  TimeService.Name = "TimeService"
  TimeService.TimeStart = os.time()
  
  function TimeService:Now()
    return os.time()
  end

  function TimeService:Elapsed()
    return os.clock()
  end

  function TimeService:PreciseNow()
    return TimeService.TimeStart + os.clock()
  end

  function TimeService:Date(Format, ...)
    return os.date(Format, ...)
  end

  return TimeService
end

return TimeModule
