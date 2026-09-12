local CServiceManager = __Lunar_C__ServiceManager__
local ServiceManager = {}
local Instance

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
  HttpClientService
)
  Instance = instance

  local Workspace = Instance.new()
  Workspace.Name = "Workspace"
  CServiceManager:RegisterService("Workspace", Workspace)
  CServiceManager:RegisterService("ConsoleService", ConsoleService)
  CServiceManager:RegisterService("FileSystemService", FileSystemService)
  CServiceManager:RegisterService("TimeService", TimeService)
  CServiceManager:RegisterService("ErrorService", ErrorService)
  CServiceManager:RegisterService("TaskService", TaskService)
  CServiceManager:RegisterService("JSONService", JSONService)
  CServiceManager:RegisterService("LMathLibrary", LMathLibrary)
  CServiceManager:RegisterService("LTableLibrary", LTableLibrary)
  CServiceManager:RegisterService("LStringLibrary", LTableLibrary)
  CServiceManager:RegisterService("HttpClientService", HttpClientService)
end

function ServiceManager.__Lunar_Internal__Init_Stage2__(RunService)
  CServiceManager:RegisterService("RunService", RunService)
end

function ServiceManager:GetService(serviceName)
  local Services = CServiceManager:GetServices()
  return Services[serviceName]
end

return ServiceManager
