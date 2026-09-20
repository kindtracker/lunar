local ServiceManager = {}
ServiceManager.Services = {}
local Instance

function ServiceManager:RegisterService(Name, Service)
  ServiceManager.Services[Name] = Service
end

function ServiceManager.__Lunar_Internal__Init__(
  instance,
  ConsoleService,
  FileSystemService,
  TimeService,
  ErrorService,
  TaskService,
  JSONService,
  LMathLibrary,
  LTableLibrary,
  LStringLibrary,
  HttpClientService,
  HttpServerService,
  HttpSharedService,
  RandomService,
  PluginService
)
  Instance = instance

  local Workspace = Instance.new()
  Workspace.Name = "Workspace"
  ServiceManager:RegisterService("Workspace", Workspace)
  ServiceManager:RegisterService("ConsoleService", ConsoleService)
  ServiceManager:RegisterService("FileSystemService", FileSystemService)
  ServiceManager:RegisterService("TimeService", TimeService)
  ServiceManager:RegisterService("ErrorService", ErrorService)
  ServiceManager:RegisterService("TaskService", TaskService)
  ServiceManager:RegisterService("JSONService", JSONService)
  ServiceManager:RegisterService("LMathLibrary", LMathLibrary)
  ServiceManager:RegisterService("LTableLibrary", LTableLibrary)
  ServiceManager:RegisterService("LStringLibrary", LStringLibrary)
  ServiceManager:RegisterService("HttpClientService", HttpClientService)
  ServiceManager:RegisterService("HttpServerService", HttpServerService)
  ServiceManager:RegisterService("HttpSharedService", HttpSharedService)
  ServiceManager:RegisterService("RandomService", RandomService)
  ServiceManager:RegisterService("PluginService", PluginService)
end

function ServiceManager.__Lunar_Internal__Init_Stage2__(RunService)
  ServiceManager:RegisterService("RunService", RunService)
end

function ServiceManager:GetServices()
  return ServiceManager.Services
end

function ServiceManager:GetService(ServiceName)
  return ServiceManager.Services[ServiceName]
end

return ServiceManager
