local PluginModule = {}
local PluginService
local Instance

function PluginModule.__Lunar_Internal__Init__(instance)
  Instance = instance

  PluginService = Instance.new("Service")
  PluginService.Name = "PluginService"
  PluginService.Plugins = {}

  function PluginService:LoadLuaPlugin(PluginName, FilePath)
    local PluginTable = dofile(FilePath)
    local Plugin = Instance.new("Plugin")
    Plugin.Name = PluginName
    Plugin.FilePath = FilePath

    for Key, Value in pairs(PluginTable) do
      Plugin[Key] = Value
    end

    if Plugin.InitPlugin then
      Plugin:InitPlugin()
    end

    self.Plugins[PluginName] = Plugin
    return Plugin
  end

  function PluginService:GetPlugin(PluginName)
    return self.Plugins[PluginName]
  end

  function PluginService:UnloadLuaPlugin(PluginName)
    local Plugin = self.Plugins[PluginName]

    if not Plugin then
      return false
    end

    if Plugin.UnloadPlugin then
      Plugin:UnloadPlugin()
    end

    self.Plugins[PluginName] = nil

    return true
  end

  function PluginService:GetPlugins()
    return self.Plugins
  end

  return PluginService
end

return PluginModule
