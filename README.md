# 🌙 Lunar Engine
Lunar is a general-purpose Lua engine with Roblox-like instances and more. It can be used for servers, games, web applications, and more.

Every instance is an object that can represent anything. For example, `Instance.new("Player")` could represent a player, while `Instance.new("Socket")` could represent a network socket.

Lunar also provides connections, signals, Roblox-like services, and more.

## Contributing
Contributions are welcome. Feel free to open an issue or submit a PR.

## Credits
- **Lua** - used as Lunar's scripting language.
- **LuaSocket** - used in Http Services (Uses socket.http).
- **json.lua** - used in JSONService (https://github.com/rxi/json.lua).

## Cheatsheet
```lua
Lunar.Version
Lunar:GetService(ServiceName)
--[[
Available services:
ConsoleService, ErrorService
FileSystemService, HttpClientService
HttpServerService, HttpSharedService
JSONService, RunService, TaskService
TimeService

Available libraries (You can get them via GetService):
LMathLibrary, LStringLibrary,
LTableLibrary
]]

-- ConsoleService

ConsoleService.Colors -- Colors of every log type
ConsoleService.LogLevels -- Log level of every log type
ConsoleService.LogLevel -- Current log level
ConsoleService.LogFormat -- Current log format
ConsoleService:_Log(LogType, Format, ...) -- Internal (Usable from user)
ConsoleService:Log(Format, ...)
ConsoleService:Info(Format, ...)
ConsoleService:Warn(Format, ...)
ConsoleService:Warning(Format, ...)
ConsoleService:Error(Format, ...)
ConsoleService:Fatal(Format, ...)
ConsoleService:Debug(Format, ...)

ConsoleService:RegisterLogType(Type, LogType, Level, Color)
-- Type: name of the function
-- LogType: uppercase name displayed in logs
-- Example: ConsoleService:RegisterLogType("Log", "LOG", 2, "0;32")

ConsoleService:SetColor(LogType, Color)
ConsoleService:SetLogLevel(LogLevel)
ConsoleService:SetLogFormat(LogFormat)
```

## License
This project is licensed under the GNU General Public License v3.0 or later.
See the [LICENSE](LICENSE) file for details.
