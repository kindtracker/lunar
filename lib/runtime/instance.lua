local CInstance = __Lunar_C__Instance__
local Instance = {}

function Instance.new(className)
  local self = CInstance.new(className)

  local Properties = {
    Name = nil,
    ClassName = className,
    Parent = nil,
    Children = {},
    UniqueId = string.format("%08x", math.random(0, 4294967295))
  }
  Properties.Name = Properties.UniqueId 

  local PropertyChangedCallbacks = {}

  local Proxy = setmetatable({}, {
    __index = function(_, key)
      if key == "Changed" then
        return changed
      end
      return Properties[key]
    end,

    __newindex = function(_, key, new_value)
      local old_value = Properties[key]
      Properties[key] = new_value
      if PropertyChangedCallbacks[key] then
        PropertyChangedCallbacks[key](new_value, old_value)
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

  return Proxy
end

return Instance
