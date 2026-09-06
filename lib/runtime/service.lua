local CServiceManager = __Lunar_C__ServiceManager__
local ServiceManager = {}
local Instance

function ServiceManager.__Lunar_Internal__Init__(instance)
  Instance = instance

  local Workspace = Instance.new()
  Workspace.Name = "Workspace"
  CServiceManager:RegisterService("Workspace", Workspace)
end

function ServiceManager:GetService(serviceName)
  local Services = CServiceManager:GetServices()
  return Services[serviceName]
end

return ServiceManager
