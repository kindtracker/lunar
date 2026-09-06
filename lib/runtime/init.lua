local Instance = dofile(os.getenv("HOME") .. "/.local/share/lunare/lib/runtime/instance.lua")
local Connection = dofile(os.getenv("HOME") .. "/.local/share/lunare/lib/runtime/connection.lua")

return {
  Instance = Instance,
  Connection = Connection
}
