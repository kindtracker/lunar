local Instance = dofile(os.getenv("HOME") .. "/.local/share/lunare/lib/runtime/core/instance.lua")
local ServiceManager = dofile(os.getenv("HOME") .. "/.local/share/lunare/lib/runtime/core/service.lua")

local Connection = dofile(os.getenv("HOME") .. "/.local/share/lunare/lib/runtime/datatypes/connection.lua")
local Signal = dofile(os.getenv("HOME") .. "/.local/share/lunare/lib/runtime/datatypes/signal.lua")
local Vector2 = dofile(os.getenv("HOME") .. "/.local/share/lunare/lib/runtime/datatypes/vector2.lua")
local Vector3 = dofile(os.getenv("HOME") .. "/.local/share/lunare/lib/runtime/datatypes/vector3.lua")
local Color3 = dofile(os.getenv("HOME") .. "/.local/share/lunare/lib/runtime/datatypes/color3.lua")
local CFrame = dofile(os.getenv("HOME") .. "/.local/share/lunare/lib/runtime/datatypes/cframe.lua")

local ConsoleServiceModule = dofile(os.getenv("HOME") .. "/.local/share/lunare/lib/runtime/services/console.lua")
local FileSystemModule = dofile(os.getenv("HOME") .. "/.local/share/lunare/lib/runtime/services/fs.lua")
local TimeModule = dofile(os.getenv("HOME") .. "/.local/share/lunare/lib/runtime/services/time.lua")
local ErrorModule = dofile(os.getenv("HOME") .. "/.local/share/lunare/lib/runtime/services/error.lua")
local TaskModule = dofile(os.getenv("HOME") .. "/.local/share/lunare/lib/runtime/services/task.lua")
local RunModule = dofile(os.getenv("HOME") .. "/.local/share/lunare/lib/runtime/services/run.lua")
local JSONModule = dofile(os.getenv("HOME") .. "/.local/share/lunare/lib/runtime/services/json.lua")

Signal.__Lunar_Internal__Init__(Connection)
CFrame.__Lunar_Internal__Init__(Vector3)
Instance.__Lunar_Internal__Init__(Connection, Signal, Vector2, Vector3, Color3, CFrame)

local ConsoleService = ConsoleServiceModule.__Lunar_Internal__Init__(Instance)
local FileSystemService = FileSystemModule.__Lunar_Internal__Init__(Instance)
local TimeService = TimeModule.__Lunar_Internal__Init__(Instance)
local ErrorService = ErrorModule.__Lunar_Internal__Init__(Instance, Signal)
local TaskService = TaskModule.__Lunar_Internal__Init__(Instance, TimeService)
local JSONService = JSONModule.__Lunar_Internal__Init__(Instance)

ServiceManager.__Lunar_Internal__Init__(Instance, ConsoleService, FileSystemService, TimeService, ErrorService, TaskService, JSONService)

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
  CFrame = CFrame
}
