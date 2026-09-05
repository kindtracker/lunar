local CInstance = __Lunar_C__Instance__
local Instance = {}

function Instance.new(className)
  local self = CInstance.new(className)

  self.Name = nil
  self.className = className
  self.UniqueId = string.format("%08x", math.random(0, 4294967296))

  function self:GetChildren(className)
    return self.Children
  end

  function self:FindFirstChild(Name)
    for _, child in pairs(self:GetChildren()) do
      if child.Name == Name then
        return child
      end
    end
  end

  function self:FindFirstChildByClassName(className)
    for _, child in pairs(self:GetChildren()) do
      if child.className == className then
        return child
      end
    end
    return nil
  end

  function self:FindChildByUniqueId(Name)
    for _, child in pairs(self:GetChildren()) do
      if child.UniqueId = UniqueId then
        return child
      end
    end
  end

  function self:FindChildren(Name)
    local children = {}
    for _, child in pairs(self:GetChildren()) do
      if child.Name == Name then
        table.insert(children, child)
      end
    end
    return children
  end

  function self:FindChildrenByClassName(className)
    local children = {}
    for _, child in pairs(self:GetChildren()) do
      if child.className == className then
        table.insert(children, child)
      end
    end
    return children
  end

  return self
end

return Instance
