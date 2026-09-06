local CServiceManager = __Lunar_C__ServiceManager__
local ServiceManager = {}

function ServiceManager:GetService(serviceName)
  local Services = CServiceManager:GetServices()
  return Services[serviceName]
end

return ServiceManager
