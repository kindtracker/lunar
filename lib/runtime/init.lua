local Connection = dofile(os.getenv("HOME") .. "/.local/share/lunare/lib/runtime/connection.lua")
local Signal = dofile(os.getenv("HOME") .. "/.local/share/lunare/lib/runtime/signal.lua")
local Instance = dofile(os.getenv("HOME") .. "/.local/share/lunare/lib/runtime/instance.lua")
local ServiceManager = dofile(os.getenv("HOME") .. "/.local/share/lunare/lib/runtime/service.lua")

Signal.__Lunar_Internal__Init__(Connection)
Instance.__Lunar_Internal__Init__(Signal)
ServiceManager.__Lunar_Internal__Init__(Instance)

return {
  Connection = Connection,
  Signal = Signal,
  Instance = Instance,
  ServiceManager = ServiceManager
}
