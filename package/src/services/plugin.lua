local PluginModule = {}
local PluginService
local Instance

function PluginModule.__Lunar_Internal__Init__(instance)
  Instance = instance

  PluginService = Instance.new("Service")
  PluginService.Name = "PluginService"

  function PluginService:LoadLuaPlugin(PluginName, FilePath)
    return dofile(FilePath)
  end

  return PluginService
end

return PluginModule
