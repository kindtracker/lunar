local Connection = dofile(os.getenv("HOME") .. "/.local/share/lunare/lib/runtime/connection.lua")
local Signal = dofile(os.getenv("HOME") .. "/.local/share/lunare/lib/runtime/signal.lua")
local Instance = dofile(os.getenv("HOME") .. "/.local/share/lunare/lib/runtime/instance.lua")

return {
  Connection = Connection,
  Signal = Signal,
  Instance = Instance
}
