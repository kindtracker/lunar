local ConsoleServiceModule = {}
local ConsoleService
local Instance

function ConsoleServiceModule.__Lunar_Internal__Init__(instance)
  Instance = instance

  ConsoleService = Instance.new("ConsoleService")
  ConsoleService.Name = "ConsoleService"

  ConsoleService.Colors = {
    LOG = "0;32",
    WARN = "0;33",
    WARNING = "0;33",
    ERROR = "0;31",
    FATAL = "0;31",
    DEBUG = "0;36"
  }

  ConsoleService.LogFormat = "[{COLOR}{TYPE}{RESET}] {MESSAGE}"

  function ConsoleService:_Log(Type, Format, ...)
    local Message = string.format(Format, ...)
    local Color = self.Colors[Type] or "37"

    local flogformat = self.LogFormat
      :gsub("{RESET}", "\27[0m")
      :gsub("{COLOR}", "\27[" .. Color .. "m")
      :gsub("{TYPE}", Type)
      :gsub("{MESSAGE}", Message)

    print(flogformat)
  end

  function ConsoleService:Log(format, ...)
    self:_Log("LOG", format, ...)
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

  return ConsoleService
end

return ConsoleServiceModule
