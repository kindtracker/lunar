local Instance = require("lunar.src.core.instance")
local ServiceManager = require("lunar.src.core.service")

local Connection = require("lunar.src.datatypes.connection")
local Signal = require("lunar.src.datatypes.signal")
local Vector2 = require("lunar.src.datatypes.vector2")
local Vector3 = require("lunar.src.datatypes.vector3")
local Color3 = require("lunar.src.datatypes.color3")
local Color4 = require("lunar.src.datatypes.color4")
local CFrame = require("lunar.src.datatypes.cframe")
local UDim = require("lunar.src.datatypes.udim")
local UDim2 = require("lunar.src.datatypes.udim2")

local ConsoleServiceModule = require("lunar.src.services.console")
local FileSystemModule, FileInstanceModule, FolderInstanceModule = require("lunar.src.services.fs")
local TimeModule = require("lunar.src.services.time")
local ErrorModule = require("lunar.src.services.error")
local TaskModule = require("lunar.src.services.task")
local RunModule = require("lunar.src.services.run")
local JSONModule = require("lunar.src.services.json")
local LMathModule = require("lunar.src.services.libraries.lmath")
local LTableModule = require("lunar.src.services.libraries.ltable")
local LStringModule = require("lunar.src.services.libraries.lstring")
local HttpClientModule = require("lunar.src.services.http-client")
local HttpServerModule = require("lunar.src.services.http-server")
local HttpSharedModule = require("lunar.src.services.http-shared")
local RandomModule = require("lunar.src.services.random")
local PluginModule = require("lunar.src.services.plugin")

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
