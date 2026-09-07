local CInstance = __Lunar_C__Instance__
local Instance = {}

local Connection
local Signal

function Instance.__Lunar_Internal__Init__(connection, signal)
  Connection = connection
  Signal = signal
end

function Instance.new(className, Parent)
  if className == nil then
    className = "Instance"
  end

  local self = CInstance.new(className, Parent)

  local Properties = {
    Name = nil,
    ClassName = className,
    Parent = Parent,
    Children = {},
    UniqueId = string.format("%08x", math.random(0, 4294967295))
  }
  Properties.Name = Properties.UniqueId 

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

  function Proxy:GetChildren(className)
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

  function Proxy:FindFirstChildByClassName(className)
    for _, child in pairs(Proxy:GetChildren()) do
      if child.className == className then
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

  function Proxy:FindChildrenByClassName(className)
    local children = {}
    for _, child in pairs(Proxy:GetChildren()) do
      if child.className == className then
        table.insert(children, child)
      end
    end
    return children
  end

  function Proxy:GetPropertyChangedSignal(PropertyName)
    if not PropertyChangedSignals[PropertyName] then
      PropertyChangedSignals[PropertyName] = Signal.new()
    end

    return PropertyChangedSignals[PropertyName]
  end

  return Proxy
end

return Instance
