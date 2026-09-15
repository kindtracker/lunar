local CInstance = __Lunar_C__Instance__
local InstanceModule = {}

local Connection
local Signal
local Vector2
local Vector3
local CFrame
local UDim
local UDim2

local EmptyModule = {}
function EmptyModule.new()
  return {}
end

function InstanceModule.__Lunar_Internal__Init__(
  connection,
  signal,
  vector2,
  vector3,
  color3,
  cframe,
  udim,
  udim2,
  FileInstanceModule,
  FolderInstanceModule
)
  Connection = connection
  Signal = signal
  Vector2 = vector2
  Vector3 = vector3
  Color3 = color3
  CFrame = cframe
  UDim = udim
  UDim2 = udim2

  InstanceModule.Classes = {}

  InstanceModule:RegisterClass("Connection", Connection, InstanceModule)
  InstanceModule:RegisterClass("Signal", Signal, InstanceModule)
  InstanceModule:RegisterClass("Vector2", Vector2, InstanceModule)
  InstanceModule:RegisterClass("Vector3", Vector3, InstanceModule)
  InstanceModule:RegisterClass("Color3", Color3, InstanceModule)
  InstanceModule:RegisterClass("CFrame", CFrame, InstanceModule)
  InstanceModule:RegisterClass("UDim", UDim, InstanceModule)
  InstanceModule:RegisterClass("UDim2", UDim2, InstanceModule)
  InstanceModule:RegisterClass("File", FileInstanceModule, InstanceModule)
  InstanceModule:RegisterClass("Folder", FolderInstanceModule, InstanceModule)

  InstanceModule:RegisterClass("Service", EmptyModule, InstanceModule)
end

function InstanceModule.__Lunar_Internal__Init_Stage2__(ErrorModule, TaskModule)
  InstanceModule:RegisterClass("Error", ErrorModule, InstanceModule)
  InstanceModule:RegisterClass("Thread", TaskModule, InstanceModule)
end

function InstanceModule:RegisterClass(ClassName, ClassModule, ParentModule)
  InstanceModule.Classes[ClassName] = { Module = ClassModule, ParentModule = ParentModule }
end

function InstanceModule:RemoveClass(ClassName)
  InstanceModule.Classes[ClassName] = nil
end

function InstanceModule:FindClassByName(ClassName)
  return InstanceModule.Classes[ClassName]
end

function InstanceModule.__Lunar_Internal__ClassNew__(Class)
  local Properties = {}
  if Class.Parent then
    local Parent = InstanceModule.__Lunar_Internal__ClassNew__(Class.Parent)
    for Key, Value in pairs(Parent) do
      Properties[Key] = Value
    end
  end

  for Key, Value in pairs(Class.Module.new()) do
    Properties[Key] = Value
  end

  return Properties
end

function InstanceModule.new(ClassName, Parent)
  if ClassName == nil then
    ClassName = "Instance"
  end

  local Properties = {
    Name = nil,
    ClassName = ClassName,
    Parent = Parent,
    Children = {},
    UniqueId = string.format("%08x", math.random(0, 4294967295)),
    Changed = Signal.new(),
    ChildAdded = Signal.new(),
    ChildRemoved = Signal.new(),
    Destroying = Signal.new(),
    AncestryChanged = Signal.new(),
    DescendantAdded = Signal.new(),
    DescendantRemoving = Signal.new(),
    Tags = {},
    Attributes = {},
    AttributeSignals = {},
  }
  local PropertyChangedSignals = {}

  local self
  self = setmetatable({}, {
    __index = function(_, key)
      return Properties[key]
    end,

    __newindex = function(_, key, newValue)
      local oldValue = self[key]
      Properties[key] = newValue
      if key == "Parent" then
        if oldValue then
          oldValue:GetChildren()[self.UniqueId] = nil
          oldValue.ChildRemoved:Fire(self)
          oldValue.DescendantRemoving:Fire(self)
        end
        if newValue then
          newValue:AddChild(self)
          self.AncestryChanged:Fire(self, newValue)
        end
      end
      if PropertyChangedSignals[key] then
        PropertyChangedSignals[key]:Fire(newValue, oldValue)
        self.Changed:Fire(key, newValue, oldValue)
      end
    end,

    __len = function()
      return #self.Children
    end,

    __pairs = function()
      return next, Properties, nil
    end,
  })

  self.Name = self.UniqueId

  if ClassName ~= "Instance" then
    local Class = InstanceModule:FindClassByName(ClassName)
    local ClassReady = InstanceModule.__Lunar_Internal__ClassNew__(Class)
    for Key, Value in pairs(ClassReady) do
      self[Key] = Value
    end
  end

  function self:Destroy(Recursive)
    if Recursive == nil then
      Recursive = true
    end

    self.Destroying:Fire()

    for _, signal in pairs(PropertyChangedSignals) do
      if signal then
        signal:DisconnectAll()
      end
    end

    local Parent = self.Parent

    if Parent then
      Parent:GetChildren()[self.UniqueId] = nil
      self.Parent = nil
    end

    if Recursive then
      for _, Child in pairs(self:GetChildren()) do
        Child:Destroy(true)
      end
    else
      for _, Child in pairs(self:GetChildren()) do
        if Parent then
          Child.Parent = Parent
        else
          Child.Parent = nil
        end
      end
    end
  end

  function self:Clone()
    local Clone = {}

    for Key, Value in pairs(self) do
      if Key ~= "Children" then
        Clone[Key] = Value
      end
    end

    Clone.Children = {}
    for _, Child in pairs(self:GetChildren()) do
      local CloneChild = Child:Clone()
      CloneChild.Parent = Clone
    end

    return Clone
  end

  function self:GetChildren()
    return self.Children
  end

  function self:GetChildrenCount()
    local Count = 0

    for _ in pairs(self.Children) do
      Count = Count + 1
    end

    return Count
  end

  function self:AddChild(Child)
    self.Children[Child.UniqueId] = Child
    self.ChildAdded:Fire(Child)
    self.DescendantAdded:Fire(Child)
  end

  function self:FindFirstChild(Name, Recursive)
    for _, Child in pairs(self:GetChildren()) do
      if Recursive then
        local RChild = Child:FindFirstChild(Name, true)
        if RChild then
          return RChild
        end
      end
      if Child.Name == Name then
        return Child
      end
    end
    return nil
  end

  function self:FindFirstChildOfClass(ClassName, Recursive)
    for _, Child in pairs(self:GetChildren()) do
      if Recursive then
        local RChild = Child:FindFirstChildOfClass(ClassName, true)
        if RChild then
          return RChild
        end
      end
      if Child.ClassName == ClassName then
        return Child
      end
    end
    return nil
  end

  function self:FindFirstChildWhichIsA(ClassName, Recursive)
    for _, Child in pairs(self:GetChildren()) do
      if Recursive then
        local RChild = Child:FindFirstChildOfClass(ClassName, true)
        if RChild then
          return RChild
        end
      end
      if Child:IsA(ClassName) then
        return Child
      end
    end
    return nil
  end

  function self:FindFirstDescendant(Name)
    return self:FindFirstChild(Name, true)
  end

  function self:GetPropertyChangedSignal(PropertyName)
    if not PropertyChangedSignals[PropertyName] then
      PropertyChangedSignals[PropertyName] = Signal.new()
    end

    return PropertyChangedSignals[PropertyName]
  end

  function self:GetAttributeChangedSignal(Attribute)
    if not self.AttributeSignals[Attribute] then
      self.AttributeSignals[Attribute] = Signal.new()
    end

    return self.AttributeSignals[Attribute]
  end

  function self:GetDescendants()
    local Descendants = {}
    local function AddChildren(Instance)
      for _, Child in pairs(Instance:GetChildren()) do
        table.insert(Descendants, Child)
        AddChildren(Child)
      end
    end
    AddChildren(self)
    return Descendants
  end

  function self:ClearAllChildren()
    for _, Child in pairs(self:GetChildren()) do
      Child:Destroy()
    end
  end

  function self:IsA(ClassName)
    local TargetClassModule = InstanceModule:FindClassByName(ClassName).Module
    local CurrentClass = InstanceModule:FindClassByName(self.ClassName)

    while CurrentClass do
      if CurrentClass.Module == TargetClassModule then
        return true
      end
      CurrentClass = InstanceModule:FindClassByName(CurrentClass.ParentModule)
    end

    return self.ClassName == ClassName
  end

  function self:GetFullName()
    local Result = self.Name
    local CurrentInstance = self.Parent
    while CurrentInstance ~= nil do
      Result = CurrentInstance.Name .. "." .. Result
      CurrentInstance = CurrentInstance.Parent
    end
    return Result
  end

  function self:FindFirstAncestor(Name)
    local CurrentInstance = self.Parent
    while CurrentInstance ~= nil do
      if CurrentInstance.Name == Name then
        return CurrentInstance
      end
      CurrentInstance = CurrentInstance.Parent
    end
    return nil
  end

  function self:FindFirstAncestorOfClass(ClassName)
    local CurrentInstance = self.Parent
    while CurrentInstance ~= nil do
      if CurrentInstance.ClassName == ClassName then
        return CurrentInstance
      end
      CurrentInstance = CurrentInstance.Parent
    end
    return nil
  end

  function self:FindFirstAncestorWhichIsA(ClassName)
    local CurrentInstance = self.Parent
    while CurrentInstance ~= nil do
      if CurrentInstance:IsA(ClassName) then
        return CurrentInstance
      end
      CurrentInstance = CurrentInstance.Parent
    end
    return nil
  end

  function self:IsAncestorOf(Descendant)
    local CurrentInstance = Descendant.Parent
    while CurrentInstance ~= nil do
      if CurrentInstance == self then
        return true
      end
      CurrentInstance = CurrentInstance.Parent
    end
    return false
  end

  function self:IsDescendantOf(Ancestor)
    local CurrentInstance = self.Parent
    while CurrentInstance ~= nil do
      if CurrentInstance == Ancestor then
        return true
      end
      CurrentInstance = CurrentInstance.Parent
    end
    return false
  end

  function self:AddTag(Tag)
    self.Tags[Tag] = true
  end

  function self:RemoveTag(Tag)
    self.Tags[Tag] = nil
  end

  function self:HasTag(Tag)
    return self.Tags[Tag]
  end

  function self:GetTags()
    local Tags = {}
    for _, Tag in ipairs(self.Tags) do
      table.insert(Tags, Tag)
    end
    return Tags
  end

  function self:SetAttribute(Attribute, Value)
    local oldValue = self.Attributes[Attribute]
    self.Attributes[Attribute] = Value
    self.AttributeSignals[Attribute]:Fire(Value, oldValue)
  end

  function self:RemoveAttribute(Attribute)
    self.Attributes[Attribute] = nil
  end

  function self:GetAttributes()
    return self.Attributes
  end

  return self
end

return InstanceModule
