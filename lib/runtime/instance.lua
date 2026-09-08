local CInstance = __Lunar_C__Instance__
local InstanceModule = {}

local Connection
local Signal

local EmptyModule = {}
function EmptyModule.new()
  return {}
end

function InstanceModule.__Lunar_Internal__Init__(connection, signal)
  Connection = connection
  Signal = signal

  InstanceModule.Classes = {}

  InstanceModule:RegisterClass("Connection", Connection)
  InstanceModule:RegisterClass("Signal", Signal)

  InstanceModule:RegisterClass("ConsoleService", EmptyModule)
  InstanceModule:RegisterClass("FileSystemService", EmptyModule)
  InstanceModule:RegisterClass("TimeService", EmptyModule)
  InstanceModule:RegisterClass("ErrorService", EmptyModule)
end

function InstanceModule:RegisterClass(ClassName, ClassModule)
  InstanceModule.Classes[ClassName] = ClassModule
end

function InstanceModule:RemoveClass(ClassName)
  InstanceModule.Classes[ClassName] = nil
end

function InstanceModule:FindClassModule(ClassName)
  return InstanceModule.Classes[ClassName]
end

function InstanceModule.new(ClassName, Parent)
  if ClassName == nil then
    ClassName = "Instance"
  end

  local self = CInstance.new(ClassName, Parent)

  local Properties = {
    Name = nil,
    ClassName = ClassName,
    Parent = Parent,
    Children = {},
    UniqueId = string.format("%08x", math.random(0, 4294967295))
  }
  Properties.Name = Properties.UniqueId 

  if ClassName ~= "Instance" then
    local ClassModule = InstanceModule:FindClassModule(ClassName)
    for Key, Value in pairs(ClassModule.new()) do
      Properties[Key] = Value
    end
  end

  local PropertyChangedSignals = {}

  local Proxy
  Proxy = setmetatable({}, {
    __index = function(_, key)
      if key == "Changed" then
        return changed
      end
      return Properties[key]
    end,

    __newindex = function(_, key, newValue)
      local oldValue = Properties[key]
      Properties[key] = newValue
      if key == "Parent" then
        local Parent = Properties.Parent
        if Parent then
          Parent:GetChildren()[Properties.UniqueId] = nil
        end
        newValue:AddChild(Proxy)
      end
      if PropertyChangedSignals[key] then
        PropertyChangedSignals[key]:Fire(newValue, oldValue)
      end
    end,
    
    __len = function()
      return #Properties.Children
    end,

    __pairs = function()
      return next, Properties, nil
    end
  })
  
  function Proxy:Destroy(Recursive)
    if Recursive == nil then
      Recursive = true
    end

    for _, signal in pairs(PropertyChangedSignals) do
      if signal then
        signal:DisconnectAll()
      end
    end

    local Parent = Properties.Parent

    if Parent then
      Parent:GetChildren()[Properties.UniqueId] = nil
      Properties.Parent = nil
    end

    if Recursive then
      for _, Child in pairs(Proxy:GetChildren()) do
        Child:Destroy(true)
      end
    else
      for _, Child in pairs(Proxy:GetChildren()) do
        if Parent then
          Child.Parent = Parent
        else
          Child.Parent = nil
        end
      end
    end
  end

  function Proxy:Clone()
    local Clone = {}
    
    for Key, Value in pairs(Proxy) do
      Clone[Key] = Value
    end

    return Clone
  end

  function Proxy:GetChildren()
    return self.Children
  end

  function Proxy:AddChild(Child)
    self.Children[Child.UniqueId] = Child
  end

  function Proxy:FindFirstChild(Name)
    for _, child in pairs(Proxy:GetChildren()) do
      if child.Name == Name then
        return child
      end
    end
  end

  function Proxy:FindFirstChildByClassName(ClassName)
    for _, child in pairs(Proxy:GetChildren()) do
      if child.ClassName == ClassName then
        return child
      end
    end
    return nil
  end

  function Proxy:FindChildByUniqueId(Name)
    for _, child in pairs(Proxy:GetChildren()) do
      if child.UniqueId == UniqueId then
        return child
      end
    end
  end

  function Proxy:FindChildren(Name)
    local children = {}
    for _, child in pairs(Proxy:GetChildren()) do
      if child.Name == Name then
        table.insert(children, child)
      end
    end
    return children
  end

  function Proxy:FindChildrenByClassName(ClassName)
    local children = {}
    for _, child in pairs(Proxy:GetChildren()) do
      if child.ClassName == ClassName then
        table.insert(children, child)
      end
    end
    return children
  end

  function Proxy:OnPropertyChanged(PropertyName)
    if not PropertyChangedSignals[PropertyName] then
      PropertyChangedSignals[PropertyName] = Signal.new()
    end

    return PropertyChangedSignals[PropertyName]
  end

  return Proxy
end

return InstanceModule
