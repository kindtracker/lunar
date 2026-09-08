local Connection = dofile(os.getenv("HOME") .. "/.local/share/lunare/lib/runtime/connection.lua")
local Signal = dofile(os.getenv("HOME") .. "/.local/share/lunare/lib/runtime/signal.lua")
local Instance = dofile(os.getenv("HOME") .. "/.local/share/lunare/lib/runtime/instance.lua")
local ServiceManager = dofile(os.getenv("HOME") .. "/.local/share/lunare/lib/runtime/service.lua")

local ConsoleServiceModule = dofile(os.getenv("HOME") .. "/.local/share/lunare/lib/runtime/services/console.lua")
local FileSystemModule = dofile(os.getenv("HOME") .. "/.local/share/lunare/lib/runtime/services/fs.lua")
local TimeModule = dofile(os.getenv("HOME") .. "/.local/share/lunare/lib/runtime/services/time.lua")
local ErrorModule = dofile(os.getenv("HOME") .. "/.local/share/lunare/lib/runtime/services/error.lua")

Signal.__Lunar_Internal__Init__(Connection)
Instance.__Lunar_Internal__Init__(Connection, Signal)

local ConsoleService = ConsoleServiceModule.__Lunar_Internal__Init__(Instance)
local FileSystemService = FileSystemModule.__Lunar_Internal__Init__(Instance)
local TimeService = TimeModule.__Lunar_Internal__Init__(Instance)
local ErrorService = ErrorModule.__Lunar_Internal__Init__(Instance, Signal)

ServiceManager.__Lunar_Internal__Init__(Instance, ConsoleService, FileSystemService, TimeService, ErrorService)

return {
  Connection = Connection,
  Signal = Signal,
  Instance = Instance,
  ServiceManager = ServiceManager
}
