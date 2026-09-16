local PluginService = Lunar:GetService("PluginService")
local Console = Lunar:GetService("ConsoleService")

function Initalize()
  PluginService:LoadLuaPlugin("TestPlugin", "Plugins/Lua/test.lua")
end
Initalize()

-- TestPlugin creates class called TestClass

local instance = Instance.new("TestClass")

local Working = false
for Key, _ in pairs(instance) do
  if Key == "TestVaalue" then
    Console:Log("TestPlugin is working properly")
    Working = true
    break
  end
end
if not Working then
  Console:Error("TestPlugin is not working")
end
