local CFrame = {}
local Vector3

function Sign(Number)
  if Number > 0 then
    return 1
  end
  if Number < 0 then
    return -1
  end
  return 0
end

function CFrame.__Lunar_Internal__Init__(vector3)
  Vector3 = vector3
end

function CFrame.new(...)
  local Properties = {
    X = 0,
    Y = 0,
    Z = 0,
    R00 = 0,
    R01 = 0,
    R02 = 0,
    R10 = 0,
    R11 = 0,
    R12 = 0,
    R20 = 0,
    R21 = 0,
    R22 = 0
  }
  
  local Arguments = {...}
  local ArgumentLength = #Arguments
  local lookAt, qX, qY, qZ, qW
  if ArgumentLength == 1 then
    Properties.X = Arguments[1].X
    Properties.Y = Arguments[1].Y
    Properties.Z = Arguments[1].Z
  elseif ArgumentLength == 2 then
    Properties.X = Arguments[1].X
    Properties.Y = Arguments[1].Y
    Properties.Z = Arguments[1].Z
    lookAt = Arguments[2]
  elseif ArgumentLength == 3 then
    Properties.X = x
    Properties.Y = y
    Properties.Z = z
  elseif ArgumentLength == 7 then
    Properties.X = x
    Properties.Y = y
    Properties.Z = z
    qX = Arguments[4]
    qY = Arguments[5]
    qZ = Arguments[6]
    qW = Arguments[7]
  elseif ArgumentLength == 12 then
    Properties.X = x
    Properties.Y = y
    Properties.Z = z
    Properties.R00 = Arguments[4]
    Properties.R01 = Arguments[5]
    Properties.R02 = Arguments[6]
    Properties.R10 = Arguments[7]
    Properties.R11 = Arguments[8]
    Properties.R12 = Arguments[9]
    Properties.R20 = Arguments[10]
    Properties.R21 = Arguments[11]
    Properties.R22 = Arguments[12]
  end

  local Proxy

  Proxy = setmetatable({}, {
    __index = function(_, key)
      if key == "XVector" then
        return Vector3.new(Properties.R00, Properties.R10, Properties.R20)
      elseif key == "YVector" then
        return Vector3.new(Properties.R01, Properties.R11, Properties.R21)
      elseif key == "ZVector" then
        return Vector3.new(Properties.R02, Properties.R12, Properties.R22)
      elseif key == "RightVector" then
        return Vector3.new(Properties.R00, Properties.R10, Properties.R20)
      elseif key == "UpVector" then
        return Vector3.new(Properties.R01, Properties.R11, Properties.R21)
      elseif key == "LookVector" then
        return Vector3.new(-Properties.R00, -Properties.R10, -Properties.R20)
      end
      return Properties[key]
    end,
    __newindex = function(_, key, Value)
      Properties[key] = Value
    end,
    __pairs = function()
      return next, Properties, nil
    end,
  })

  return Proxy
end

return CFrame
