local Base = os.getenv("HOME") .. "/.local/share/lunare/lib/runtime"
local BaseExternal = os.getenv("HOME") .. "/.local/share/lunare/lib/external"

package.path = BaseExternal .. "/?.lua;" .. BaseExternal .. "/?/init.lua;" .. package.path

local Instance = dofile(Base .. "/core/instance.lua")
local ServiceManager = dofile(Base .. "/core/service.lua")

local Connection = dofile(Base .. "/datatypes/connection.lua")
local Signal = dofile(Base .. "/datatypes/signal.lua")
local Vector2 = dofile(Base .. "/datatypes/vector2.lua")
local Vector3 = dofile(Base .. "/datatypes/vector3.lua")
local Color3 = dofile(Base .. "/datatypes/color3.lua")
local Color4 = dofile(Base .. "/datatypes/color4.lua")
local CFrame = dofile(Base .. "/datatypes/cframe.lua")
local UDim = dofile(Base .. "/datatypes/udim.lua")
local UDim2 = dofile(Base .. "/datatypes/udim2.lua")

local ConsoleServiceModule = dofile(Base .. "/services/console.lua")
local FileSystemModule, FileInstanceModule, FolderInstanceModule = dofile(Base .. "/services/fs.lua")
local TimeModule = dofile(Base .. "/services/time.lua")
local ErrorModule = dofile(Base .. "/services/error.lua")
local TaskModule = dofile(Base .. "/services/task.lua")
local RunModule = dofile(Base .. "/services/run.lua")
local JSONModule = dofile(Base .. "/services/json.lua")
local LMathModule = dofile(Base .. "/services/libraries/lmath.lua")
local LTableModule = dofile(Base .. "/services/libraries/ltable.lua")
local LStringModule = dofile(Base .. "/services/libraries/lstring.lua")
local HttpClientModule = dofile(Base .. "/services/http-client.lua")
local HttpServerModule = dofile(Base .. "/services/http-server.lua")
local HttpSharedModule = dofile(Base .. "/services/http-shared.lua")
local RandomModule = dofile(Base .. "/services/random.lua")
local PluginModule = dofile(Base .. "/services/plugin.lua")

Signal.__Lunar_Internal__Init__(Connection)
CFrame.__Lunar_Internal__Init__(Vector3)
UDim2.__Lunar_Internal__Init__(UDim)
Instance.__Lunar_Internal__Init__(
  Connection,
  Signal,
  Vector2,
  Vector3,
  Color3,
  CFrame,
  UDim,
  UDim2,
  FileInstanceModule,
  FolderInstanceModule
)

local LMathLibrary = LMathModule.__Lunar_Internal__Init__(Instance)
local LTableLibrary = LTableModule.__Lunar_Internal__Init__(Instance)
local LStringLibrary = LStringModule.__Lunar_Internal__Init__(Instance)
local ConsoleService = ConsoleServiceModule.__Lunar_Internal__Init__(Instance, Signal)
local FileSystemService = FileSystemModule.__Lunar_Internal__Init__(Instance)
local TimeService = TimeModule.__Lunar_Internal__Init__(Instance)
local ErrorService = ErrorModule.__Lunar_Internal__Init__(Instance, Signal)
local TaskService = TaskModule.__Lunar_Internal__Init__(Instance, TimeService)
local JSONService = JSONModule.__Lunar_Internal__Init__(Instance)
local HttpClientService = HttpClientModule.__Lunar_Internal__Init__(Instance)
local HttpServerService = HttpServerModule.__Lunar_Internal__Init__(Instance, FileSystemService)
local HttpSharedService = HttpSharedModule.__Lunar_Internal__Init__(Instance, JSONService)
local RandomService = RandomModule.__Lunar_Internal__Init__(Instance, TimeService)
local PluginService = PluginModule.__Lunar_Internal__Init__(Instance)

ServiceManager.__Lunar_Internal__Init__(
  Instance,
  ConsoleService,
  FileSystemService,
  TimeService,
  ErrorService,
  TaskService,
  JSONService,
  LMathLibrary,
  LTableLibrary,
  LStringLibrary,
  HttpClientService,
  HttpServerService,
  HttpSharedService,
  RandomService,
  PluginService
)

Instance.__Lunar_Internal__Init_Stage2__(ErrorModule, TaskModule)
local RunService = RunModule.__Lunar_Internal__Init__(Instance, Signal, TaskService, TimeService)
ServiceManager.__Lunar_Internal__Init_Stage2__(RunService)

return {
  Connection = Connection,
  Signal = Signal,
  Instance = Instance,
  ServiceManager = ServiceManager,
  Vector2 = Vector2,
  Vector3 = Vector3,
  Color3 = Color3,
  Color4 = Color4,
  CFrame = CFrame,
  UDim = UDim,
  UDim2 = UDim2,
  LMathLibrary = LMathLibrary,
  LTableLibrary = LTableLibrary,
  LStringLibrary = LStringLibrary,
  RandomModule = RandomModule,
}
