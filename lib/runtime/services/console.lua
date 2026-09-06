local ConsoleService = {}
local Instance

function ConsoleService.__Lunar_Internal__Init__(instance)
  Instance = instance

  ConsoleService = Instance.new()
  ConsoleService.Name = "ConsoleService"

  ConsoleService.Colors = {
    LOG = "37",
    WARN = "33",
    WARNING = "33",
    ERROR = "31",
    FATAL = "31",
    DEBUG = "36"
  }

  ConsoleService.LogFormat = "[{COLOR_START}{TYPE}{COLOR_END}{RESET}]: {MESSAGE}"
end

function ConsoleService:_Log(Type, Format, ...)
  local Message = string.format(Format, ...)
  local Color = ConsoleService.Colors[Type] or "37"

  local flogformat = ConsoleService.LogFormat
    :gsub("{RESET}", "\27[0m")
    :gsub("{COLOR_START}", "\27[" .. Color)
    :gsub("{COLOR_END}", "m")
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
