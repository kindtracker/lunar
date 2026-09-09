-- Mostly CFrame code is ai-generated (i couldn't understand the math)

--[[

Not implemented:

CFrame.fromAxisAngle()
CFrame.fromEulerAnglesXYZ()
CFrame.fromOrientation()
CFrame:Lerp()
CFrame:ToEulerAnglesXYZ()
CFrame:ToOrientation()
CFrame:GetComponents()
CFrame:ToAxisAngle()
CFrame.Rotation
CFrame.Position

--]]

local CFrame = {}
local Vector3

function CFrame.__Lunar_Internal__Init__(vector3)
  Vector3 = vector3
end

local function Normalize(Vector)
  local Magnitude = math.sqrt(
    Vector.X * Vector.X +
    Vector.Y * Vector.Y +
    Vector.Z * Vector.Z
  )

  if Magnitude == 0 then
    return Vector3.new(0, 0, 0)
  end

  return Vector3.new(
    Vector.X / Magnitude,
    Vector.Y / Magnitude,
    Vector.Z / Magnitude
  )
end

local function Dot(A, B)
  return A.X * B.X + A.Y * B.Y + A.Z * B.Z
end

local function Cross(A, B)
  return Vector3.new(
    A.Y * B.Z - A.Z * B.Y,
    A.Z * B.X - A.X * B.Z,
    A.X * B.Y - A.Y * B.X
  )
end

local function CreateCFrame(
  X, Y, Z,
  R00, R01, R02,
  R10, R11, R12,
  R20, R21, R22
)
  local Properties = {
    X = X,
    Y = Y,
    Z = Z,
    R00 = R00,
    R01 = R01,
    R02 = R02,
    R10 = R10,
    R11 = R11,
    R12 = R12,
    R20 = R20,
    R21 = R21,
    R22 = R22
  }

  local Proxy

  Proxy = setmetatable({}, {
    __index = function(_, Key)
      if Key == "XVector" or Key == "RightVector" then
        return Vector3.new(
          Properties.R00,
          Properties.R10,
          Properties.R20
        )
      elseif Key == "YVector" or Key == "UpVector" then
        return Vector3.new(
          Properties.R01,
          Properties.R11,
          Properties.R21
        )
      elseif Key == "ZVector" then
        return Vector3.new(
          Properties.R02,
          Properties.R12,
          Properties.R22
        )
      elseif Key == "LookVector" then
        return Vector3.new(
          -Properties.R02,
          -Properties.R12,
          -Properties.R22
        )
      end

      return Properties[Key]
    end,

    __newindex = function(_, Key, Value)
      Properties[Key] = Value
    end,

    __pairs = function()
      return next, Properties, nil
    end,

    __mul = function(A, B)
      if B.R00 ~= nil then
        local R00 = A.R00 * B.R00 + A.R01 * B.R10 + A.R02 * B.R20
        local R01 = A.R00 * B.R01 + A.R01 * B.R11 + A.R02 * B.R21
        local R02 = A.R00 * B.R02 + A.R01 * B.R12 + A.R02 * B.R22

        local R10 = A.R10 * B.R00 + A.R11 * B.R10 + A.R12 * B.R20
        local R11 = A.R10 * B.R01 + A.R11 * B.R11 + A.R12 * B.R21
        local R12 = A.R10 * B.R02 + A.R11 * B.R12 + A.R12 * B.R22

        local R20 = A.R20 * B.R00 + A.R21 * B.R10 + A.R22 * B.R20
        local R21 = A.R20 * B.R01 + A.R21 * B.R11 + A.R22 * B.R21
        local R22 = A.R20 * B.R02 + A.R21 * B.R12 + A.R22 * B.R22

        local X = A.X + A.R00 * B.X + A.R01 * B.Y + A.R02 * B.Z
        local Y = A.Y + A.R10 * B.X + A.R11 * B.Y + A.R12 * B.Z
        local Z = A.Z + A.R20 * B.X + A.R21 * B.Y + A.R22 * B.Z

        return CreateCFrame(
          X, Y, Z,
          R00, R01, R02,
          R10, R11, R12,
          R20, R21, R22
        )
      end

      return Vector3.new(
        A.X + A.R00 * B.X + A.R01 * B.Y + A.R02 * B.Z,
        A.Y + A.R10 * B.X + A.R11 * B.Y + A.R12 * B.Z,
        A.Z + A.R20 * B.X + A.R21 * B.Y + A.R22 * B.Z
      )
    end,

    __add = function(A, B)
      return CreateCFrame(
        A.X + B.X,
        A.Y + B.Y,
        A.Z + B.Z,
        A.R00, A.R01, A.R02,
        A.R10, A.R11, A.R12,
        A.R20, A.R21, A.R22
      )
    end,

    __sub = function(A, B)
      return CreateCFrame(
        A.X - B.X,
        A.Y - B.Y,
        A.Z - B.Z,
        A.R00, A.R01, A.R02,
        A.R10, A.R11, A.R12,
        A.R20, A.R21, A.R22
      )
    end
  })

  function Proxy:Inverse()
    local R00 = Properties.R00
    local R01 = Properties.R10
    local R02 = Properties.R20

    local R10 = Properties.R01
    local R11 = Properties.R11
    local R12 = Properties.R21

    local R20 = Properties.R02
    local R21 = Properties.R12
    local R22 = Properties.R22

    local X = -(R00 * Properties.X + R01 * Properties.Y + R02 * Properties.Z)
    local Y = -(R10 * Properties.X + R11 * Properties.Y + R12 * Properties.Z)
    local Z = -(R20 * Properties.X + R21 * Properties.Y + R22 * Properties.Z)

    return CreateCFrame(
      X, Y, Z,
      R00, R01, R02,
      R10, R11, R12,
      R20, R21, R22
    )
  end

  function Proxy:VectorToWorldSpace(Vector)
    return Vector3.new(
      Properties.R00 * Vector.X + Properties.R01 * Vector.Y + Properties.R02 * Vector.Z,
      Properties.R10 * Vector.X + Properties.R11 * Vector.Y + Properties.R12 * Vector.Z,
      Properties.R20 * Vector.X + Properties.R21 * Vector.Y + Properties.R22 * Vector.Z
    )
  end

  function Proxy:PointToWorldSpace(Vector)
    return self * Vector
  end

  function Proxy:VectorToObjectSpace(Vector)
    return self:Inverse():VectorToWorldSpace(Vector)
  end

  function Proxy:PointToObjectSpace(Vector)
    return self:Inverse() * Vector
  end

  return Proxy
end

function CFrame.new(...)
  local Arguments = {...}
  local ArgumentLength = #Arguments

  if ArgumentLength == 0 then
    return CreateCFrame(
      0, 0, 0,
      1, 0, 0,
      0, 1, 0,
      0, 0, 1
    )
  elseif ArgumentLength == 1 then
    local Position = Arguments[1]

    return CreateCFrame(
      Position.X,
      Position.Y,
      Position.Z,
      1, 0, 0,
      0, 1, 0,
      0, 0, 1
    )
  elseif ArgumentLength == 2 then
    local Position = Arguments[1]
    local LookAt = Arguments[2]

    local Forward = Normalize(Vector3.new(
      LookAt.X - Position.X,
      LookAt.Y - Position.Y,
      LookAt.Z - Position.Z
    ))

    local Up = Vector3.new(0, 1, 0)

    if math.abs(Dot(Forward, Up)) > 0.999 then
      Up = Vector3.new(0, 0, 1)
    end

    local Right = Normalize(Cross(Up, Forward))
    Up = Cross(Forward, Right)

    return CreateCFrame(
      Position.X,
      Position.Y,
      Position.Z,
      Right.X, Up.X, -Forward.X,
      Right.Y, Up.Y, -Forward.Y,
      Right.Z, Up.Z, -Forward.Z
    )
  elseif ArgumentLength == 3 then
    return CreateCFrame(
      Arguments[1],
      Arguments[2],
      Arguments[3],
      1, 0, 0,
      0, 1, 0,
      0, 0, 1
    )
  elseif ArgumentLength == 7 then
    local X = Arguments[1]
    local Y = Arguments[2]
    local Z = Arguments[3]

    local qX = Arguments[4]
    local qY = Arguments[5]
    local qZ = Arguments[6]
    local qW = Arguments[7]

    local R00 = 1 - 2 * (qY * qY + qZ * qZ)
    local R01 = 2 * (qX * qY - qZ * qW)
    local R02 = 2 * (qX * qZ + qY * qW)

    local R10 = 2 * (qX * qY + qZ * qW)
    local R11 = 1 - 2 * (qX * qX + qZ * qZ)
    local R12 = 2 * (qY * qZ - qX * qW)

    local R20 = 2 * (qX * qZ - qY * qW)
    local R21 = 2 * (qY * qZ + qX * qW)
    local R22 = 1 - 2 * (qX * qX + qY * qY)

    return CreateCFrame(
      X, Y, Z,
      R00, R01, R02,
      R10, R11, R12,
      R20, R21, R22
    )
  elseif ArgumentLength == 12 then
    return CreateCFrame(
      Arguments[1],
      Arguments[2],
      Arguments[3],
      Arguments[4],
      Arguments[5],
      Arguments[6],
      Arguments[7],
      Arguments[8],
      Arguments[9],
      Arguments[10],
      Arguments[11],
      Arguments[12]
    )
  end
end

function CFrame.Angles(X, Y, Z)
  local CX = math.cos(X / 2)
  local SX = math.sin(X / 2)
  local CY = math.cos(Y / 2)
  local SY = math.sin(Y / 2)
  local CZ = math.cos(Z / 2)
  local SZ = math.sin(Z / 2)

  local qX = SX * CY * CZ - CX * SY * SZ
  local qY = CX * SY * CZ + SX * CY * SZ
  local qZ = CX * CY * SZ - SX * SY * CZ
  local qW = CX * CY * CZ + SX * SY * SZ

  return CFrame.new(0, 0, 0, qX, qY, qZ, qW)
end

return CFrame
