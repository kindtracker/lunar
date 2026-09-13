local ConsoleServiceModule = {}
local ConsoleService
local Instance
local Signal

function ConsoleServiceModule.__Lunar_Internal__Init__(instance, signal)
  Instance = instance
  Signal = signal

  ConsoleService = Instance.new("Service")
  ConsoleService.Name = "ConsoleService"
  ConsoleService.LogHandler = Signal.new()

  ConsoleService.Colors = {
    LOG = "0;32",
    INFO = "0;32",
    WARN = "0;33",
    WARNING = "0;33",
    ERROR = "0;31",
    FATAL = "0;31",
    DEBUG = "0;36",
  }

  ConsoleService.LogLevels = {
    DEBUG = 1,
    LOG = 2,
    INFO = 2,
    WARN = 3,
    WARNING = 3,
    ERROR = 4,
    FATAL = 5,
  }
  ConsoleService.LogLevel = 1

  ConsoleService.LogFormat = "[{COLOR}{TYPE}{RESET}] {MESSAGE}"

  function ConsoleService:_Log(Type, Format, ...)
    if not (ConsoleService.LogLevels[Type] >= ConsoleService.LogLevel) then
      return
    end
    local Message = string.format(Format, ...)
    local Color = self.Colors[Type] or "37"

    local flogformat = self.LogFormat
      :gsub("{RESET}", "\27[0m")
      :gsub("{COLOR}", "\27[" .. Color .. "m")
      :gsub("{TYPE}", Type)
      :gsub("{MESSAGE}", Message)

    print(flogformat)

    ConsoleService.LogHandler:Fire(flogformat, Type, Format, ...)
  end

  function ConsoleService:Log(format, ...)
    self:_Log("LOG", format, ...)
  end

  function ConsoleService:Info(format, ...)
    self:_Log("INFO", format, ...)
  end

  function ConsoleService:Warn(format, ...)
    self:_Log("WARN", format, ...)
  end

  function ConsoleService:Warning(format, ...)
    self:_Log("WARNING", format, ...)
  end

  function ConsoleService:Error(format, ...)
    self:_Log("ERROR", format, ...)
  end

  function ConsoleService:Fatal(format, ...)
    self:_Log("FATAL", format, ...)
  end

  function ConsoleService:Debug(format, ...)
    self:_Log("DEBUG", format, ...)
  end

  function ConsoleService:RegisterLogType(Type, LogType, Level, Color)
    ConsoleService[Type] = function(format, ...)
      ConsoleService:_Log(LogType, format, ...)
    end
    ConsoleService.LogLevels[LogType] = Level
    ConsoleService.Colors[LogType] = Color
  end

  function ConsoleService:SetColor(Type, Color)
    ConsoleService.Colors[Type] = Color
  end

  function ConsoleService:SetLogLevel(LogLevel)
    ConsoleService.LogLevel = LogLevel
  end

  function ConsoleService:SetLogFormat(LogFormat)
    ConsoleService.LogFormat = LogFormat
  end

  return ConsoleService
end

return ConsoleServiceModule
