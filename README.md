# 🌙 Lunar Engine
Lunar is a general-purpose Lua engine with Roblox-like instances and more. It can be used for servers, games, web applications, and more.

Every instance is an object that can represent anything. For example, `Instance.new("Player")` could represent a player, while `Instance.new("Socket")` could represent a network socket.

Lunar also provides connections, signals, Roblox-like services, and more.

## Contributing
Contributions are welcome. Feel free to open an issue or submit a PR.

## Credits
- **Lua** - used as Lunar's scripting language.
- **LuaSocket** - used in HttpClientService.
- **pegasus** used in HttpServerService.
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
TimeService, RandomService

Available libraries (You can get them via GetService):
LMathLibrary, LStringLibrary,
LTableLibrary
]]

-- ConsoleService

ConsoleService.Colors -- Colors of every log type
ConsoleService.LogLevels -- Log level of every log type
ConsoleService.LogLevel -- Current log level
ConsoleService.LogFormat -- Current log format

ConsoleService:_Log(LogType, Format, ...)
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

-- ErrorService

ErrorService.ErrorHandler -- Signal
-- ErrorService.ErrorHandler:Connect(function(ErrorInstance) end)

ErrorService.AlwaysPrintError -- Always print error when ErrorService:Error is called

ErrorService:Create(Type, Message, Traceback) -- Returns an ErrorInstance
ErrorService:Traceback(Level)
ErrorService:Error(ErrorInstance)
ErrorService:Print(errorInstance)

-- FileSystemService

FileSystemService:GetFileName(Path)
FileSystemService:GetExtension(Path)
FileSystemService:GetFolder(Path, Recursive)

FileSystemService:Open(Path, Mode) -- Returns a File (Instance), Mode is C-Style fopen() mode string.
File.FilePtr
File.Attributes
File.Mode
File:Seek(Whence, Offset)
File:Close()
File:Read(ReadMode, Offset) -- ReadMode is from io.open
File:Write(Format)

FileSystemService:CreateFolder(Path)
FileSystemService:Delete(Path)
FileSystemService:Move(FromPath, ToPath)
FileSystemService:Copy(FromPath, ToPath)

FileSystemService:GetAttributes(Path)
-- Returns:
{
  Name, -- String
  Path, -- String
  Type, -- String, can be "Folder", "File", "Socket", "NamedPipe", "CharDevice", "BlockDevice", "Unknown"
  Size, -- Number
  ModificationTime, -- Number
  AccessTime, -- Number
  ChangeTime, -- Number
  Permissions -- String
}

FileSystemService:Exists(Path)
FileSystemService:IsFile(Path)
FileSystemService:IsFolder(Path)

-- JSONService

JSONService:Encode(Table)
JSONService:Decode(JSON)

-- HttpSharedService

HttpSharedService:JSONEncode(Table)
HttpSharedService:JSONDecode(JSON)

HttpSharedService:QueryDecode(QueryString)
HttpSharedService:QueryEncode(QueryTable)

HttpSharedService:UrlParse(Url)
-- Returns:
{
  Scheme,
  UserInfo,
  User,
  Password,
  Authority,
  Host,
  Port,
  Path,
  Query,
  Fragment
}

HttpSharedService:UrlBuild(Url)
HttpSharedService:UrlNormalize(Url)
HttpSharedService:UrlAddSegment(Url, Segment)
HttpSharedService:UrlRemoveDotSegments(Path)
HttpSharedService:UrlResolve(BaseUrl, RelativeUrl)
HttpSharedService:UrlSetQuery(Url, Query)
HttpSharedService:UrlSetAuthority(Url, Authority)

-- HttpClientService

HttpClientService.RequestOptions
{
  Url,
  Headers,
  Method,
  Proxy,
  FollowRedirect,
  -- Hidden but you can modify/access them
  __Hidden_socket_http__sink,
  __Hidden_socket_http__create,
  __Hidden_socket_http__step,
  __Hidden_socket_http__source,
}

HttpClientService:ClearRequestOptions()
-- HttpClientService:ClearRequestOptions basically is
HttpClientService.RequestOptions.Method = "GET"
HttpClientService.RequestOptions.Headers["Content-Type"] = nil
HttpClientService.RequestOptions.Headers["Content-Length"] = nil
HttpClientService.RequestOptions.__Hidden_socket_http__source = nil
HttpClientService.RequestOptions.__Hidden_socket_http__sink = nil

HttpClientService:Request(Url) -- Doesn't modify RequestOptions

HttpClientService:Get(Url)
HttpClientService:Post(Url, ContentType, Body)
HttpClientService:Put(Url, ContentType, Body)
HttpClientService:Patch(Url, ContentType, Body)
HttpClientService:Delete(Url)
HttpClientService:Head(Url)

-- HttpServerService

HttpServerService:MatchRoute(Route, Path)

HttpServerService:Create(Options) -- Returns Server
-- Options:
{
  Port,
  Host,
  Location,
}

Server:Route(Method, Path, Callback)
-- Server:Route("GET", "/", function(Request, Response) end)

Server:Listen(Callback)

Request.Method
Request.Path
Request.Params
Request.Headers
Request.PostData
Request.Ip
Request.Port
Request.QueryString

Response:Redirect(Location, Temporary)
Response:WriteErrorMessage(StatusCode, Message)
Response:WriteFile(File)
Response:Write(Content)
Response:AddHeader(Key, Value)
Response:AddHeaders(Headers)
Response:SetStatusCode(StatusCode, StatusMessage)
Response:SetContentType(Value)
Response:Close()

-- RandomService

RandomService.new(Seed) -- Returns a RNG, if seed is nil, seed will be current time

RNG.StartSeed
RNG.CurrentSeed
RNG:RawRandom() -- Internal (Callable from user)
RNG:Next() -- 0 to 1
RNG:NextInteger(Min, Max)
RNG:NextNumber(Min, Max)
RNG:NextBoolean()
RNG:Seed(Seed) -- Sets StartSeed and CurrentSeed to Seed

-- RunService

-- RunService needs TaskService:Step()
-- See /examples/taskservice/main.lua
-- Stepped fires before Heartbeat

RunService.Stepped -- Signal
-- RunService.Stepped:Connect(function(DeltaTime) end)

RunService.Heartbeat -- Signal
-- RunService.Heartbeat:Connect(function(DeltaTime) end)

-- TaskService

-- See /examples/taskservice/main.lua

TaskService:Spawn(Function)
TaskService:Step() -- Needs to be called in a while true loop

-- Cannot be called from the main thread otherwise Lua will error
TaskService.wait(Duration)
TaskService.delay(Duration, Function)

-- Thread is an internal Instance created by wait() or delay(), this will not be internal in future

Thread:Initialize()
Thread:GetStatus()
Thread:Resume(...)

-- TimeService

TimeService:Now() -- Seconds
TimeService:PreciseNow()
TimeService:Elapsed()
TimeService:Date(Format, ...) -- Format is from os.date
```

## License
This project is licensed under the GNU General Public License v3.0 or later.
See the [LICENSE](LICENSE) file for details.
