-- Mostly CFrame code is ai-generated (i couldn't understand the math)

local CFrame = {}
local Vector3

function CFrame.__Lunar_Internal__Init__(vector3)
  Vector3 = vector3
end

local function Normalize(Vector)
  local Magnitude = math.sqrt(Vector.X * Vector.X + Vector.Y * Vector.Y + Vector.Z * Vector.Z)

  if Magnitude == 0 then
    return Vector3.new(0, 0, 0)
  end

  return Vector3.new(Vector.X / Magnitude, Vector.Y / Magnitude, Vector.Z / Magnitude)
end

local function Dot(A, B)
  return A.X * B.X + A.Y * B.Y + A.Z * B.Z
end

local function Cross(A, B)
  return Vector3.new(A.Y * B.Z - A.Z * B.Y, A.Z * B.X - A.X * B.Z, A.X * B.Y - A.Y * B.X)
end

local function MatrixToQuaternion(CF)
  local Trace = CF.R00 + CF.R11 + CF.R22

  local X
  local Y
  local Z
  local W

  if Trace > 0 then
    local S = math.sqrt(Trace + 1) * 2

    W = 0.25 * S
    X = (CF.R21 - CF.R12) / S
    Y = (CF.R02 - CF.R20) / S
    Z = (CF.R10 - CF.R01) / S
  elseif CF.R00 > CF.R11 and CF.R00 > CF.R22 then
    local S = math.sqrt(1 + CF.R00 - CF.R11 - CF.R22) * 2

    W = (CF.R21 - CF.R12) / S
    X = 0.25 * S
    Y = (CF.R01 + CF.R10) / S
    Z = (CF.R02 + CF.R20) / S
  elseif CF.R11 > CF.R22 then
    local S = math.sqrt(1 + CF.R11 - CF.R00 - CF.R22) * 2

    W = (CF.R02 - CF.R20) / S
    X = (CF.R01 + CF.R10) / S
    Y = 0.25 * S
    Z = (CF.R12 + CF.R21) / S
  else
    local S = math.sqrt(1 + CF.R22 - CF.R00 - CF.R11) * 2

    W = (CF.R10 - CF.R01) / S
    X = (CF.R02 + CF.R20) / S
    Y = (CF.R12 + CF.R21) / S
    Z = 0.25 * S
  end

  return X, Y, Z, W
end

local function QuaternionSlerp(AX, AY, AZ, AW, BX, BY, BZ, BW, Alpha)
  local DotProduct = AX * BX + AY * BY + AZ * BZ + AW * BW

  if DotProduct < 0 then
    BX = -BX
    BY = -BY
    BZ = -BZ
    BW = -BW
    DotProduct = -DotProduct
  end

  if DotProduct > 0.9995 then
    local X = AX + Alpha * (BX - AX)
    local Y = AY + Alpha * (BY - AY)
    local Z = AZ + Alpha * (BZ - AZ)
    local W = AW + Alpha * (BW - AW)

    local Length = math.sqrt(X * X + Y * Y + Z * Z + W * W)

    return X / Length, Y / Length, Z / Length, W / Length
  end

  local Theta = math.acos(math.max(-1, math.min(1, DotProduct)))
  local SinTheta = math.sin(Theta)

  local A = math.sin((1 - Alpha) * Theta) / SinTheta
  local B = math.sin(Alpha * Theta) / SinTheta

  return AX * A + BX * B, AY * A + BY * B, AZ * A + BZ * B, AW * A + BW * B
end

local function CreateCFrame(X, Y, Z, R00, R01, R02, R10, R11, R12, R20, R21, R22)
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
    R22 = R22,
  }

  local Proxy

  Proxy = setmetatable({}, {
    __index = function(_, Key)
      if Key == "XVector" or Key == "RightVector" then
        return Vector3.new(Properties.R00, Properties.R10, Properties.R20)
      elseif Key == "YVector" or Key == "UpVector" then
        return Vector3.new(Properties.R01, Properties.R11, Properties.R21)
      elseif Key == "ZVector" then
        return Vector3.new(Properties.R02, Properties.R12, Properties.R22)
      elseif Key == "LookVector" then
        return Vector3.new(-Properties.R02, -Properties.R12, -Properties.R22)
      elseif Key == "Position" then
        return Vector3.new(Properties.X, Properties.Y, Properties.Z)
      elseif Key == "Rotation" then
        return CreateCFrame(
          0,
          0,
          0,
          Properties.R00,
          Properties.R01,
          Properties.R02,
          Properties.R10,
          Properties.R11,
          Properties.R12,
          Properties.R20,
          Properties.R21,
          Properties.R22
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

        return CreateCFrame(X, Y, Z, R00, R01, R02, R10, R11, R12, R20, R21, R22)
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
        A.R00,
        A.R01,
        A.R02,
        A.R10,
        A.R11,
        A.R12,
        A.R20,
        A.R21,
        A.R22
      )
    end,

    __sub = function(A, B)
      return CreateCFrame(
        A.X - B.X,
        A.Y - B.Y,
        A.Z - B.Z,
        A.R00,
        A.R01,
        A.R02,
        A.R10,
        A.R11,
        A.R12,
        A.R20,
        A.R21,
        A.R22
      )
    end,
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

    return CreateCFrame(X, Y, Z, R00, R01, R02, R10, R11, R12, R20, R21, R22)
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

  function Proxy:GetComponents()
    return Properties.X,
      Properties.Y,
      Properties.Z,
      Properties.R00,
      Properties.R01,
      Properties.R02,
      Properties.R10,
      Properties.R11,
      Properties.R12,
      Properties.R20,
      Properties.R21,
      Properties.R22
  end

  function Proxy:ToWorldSpace(CFrame2)
    return self * CFrame2
  end

  function Proxy:ToObjectSpace(CFrame2)
    return self:Inverse() * CFrame2
  end

  function Proxy:ToAxisAngle()
    local Trace = Properties.R00 + Properties.R11 + Properties.R22
    local CosAngle = math.max(-1, math.min(1, (Trace - 1) / 2))
    local Angle = math.acos(CosAngle)

    if Angle < 0.000001 then
      return Vector3.new(1, 0, 0), 0
    end

    local S = 2 * math.sin(Angle)

    if math.abs(S) < 0.000001 then
      return Vector3.new(1, 0, 0), Angle
    end

    local Axis = Vector3.new(
      (Properties.R21 - Properties.R12) / S,
      (Properties.R02 - Properties.R20) / S,
      (Properties.R10 - Properties.R01) / S
    )

    return Normalize(Axis), Angle
  end

  function Proxy:ToEulerAnglesXYZ()
    local R20 = Properties.R20

    local Y = math.asin(math.max(-1, math.min(1, -R20)))

    local X
    local Z

    if math.abs(math.cos(Y)) > 0.000001 then
      X = math.atan2(Properties.R21, Properties.R22)
      Z = math.atan2(Properties.R10, Properties.R00)
    else
      X = math.atan2(-Properties.R12, Properties.R11)
      Z = 0
    end

    return X, Y, Z
  end

  function Proxy:ToOrientation()
    return self:ToEulerAnglesXYZ()
  end

  function Proxy:Lerp(Goal, Alpha)
    local AX, AY, AZ, AW = MatrixToQuaternion(self)
    local BX, BY, BZ, BW = MatrixToQuaternion(Goal)

    local X, Y, Z, W = QuaternionSlerp(AX, AY, AZ, AW, BX, BY, BZ, BW, Alpha)

    local PositionX = Properties.X + (Goal.X - Properties.X) * Alpha
    local PositionY = Properties.Y + (Goal.Y - Properties.Y) * Alpha
    local PositionZ = Properties.Z + (Goal.Z - Properties.Z) * Alpha

    local Result = CFrame.new(PositionX, PositionY, PositionZ, X, Y, Z, W)

    return Result
  end

  function Proxy:FuzzyEq(Other, Epsilon)
    Epsilon = Epsilon or 0.000001

    local function Close(A, B)
      return math.abs(A - B) <= Epsilon
    end

    return Close(Properties.X, Other.X)
      and Close(Properties.Y, Other.Y)
      and Close(Properties.Z, Other.Z)
      and Close(Properties.R00, Other.R00)
      and Close(Properties.R01, Other.R01)
      and Close(Properties.R02, Other.R02)
      and Close(Properties.R10, Other.R10)
      and Close(Properties.R11, Other.R11)
      and Close(Properties.R12, Other.R12)
      and Close(Properties.R20, Other.R20)
      and Close(Properties.R21, Other.R21)
      and Close(Properties.R22, Other.R22)
  end

  function Proxy:IsIdentity()
    return Properties.X == 0
      and Properties.Y == 0
      and Properties.Z == 0
      and Properties.R00 == 1
      and Properties.R01 == 0
      and Properties.R02 == 0
      and Properties.R10 == 0
      and Properties.R11 == 1
      and Properties.R12 == 0
      and Properties.R20 == 0
      and Properties.R21 == 0
      and Properties.R22 == 1
  end

  return Proxy
end

function CFrame.new(...)
  local Arguments = { ... }
  local ArgumentLength = #Arguments

  if ArgumentLength == 0 then
    return CreateCFrame(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)
  elseif ArgumentLength == 1 then
    local Position = Arguments[1]

    return CreateCFrame(Position.X, Position.Y, Position.Z, 1, 0, 0, 0, 1, 0, 0, 0, 1)
  elseif ArgumentLength == 2 then
    local Position = Arguments[1]
    local LookAt = Arguments[2]

    local Forward = Normalize(Vector3.new(LookAt.X - Position.X, LookAt.Y - Position.Y, LookAt.Z - Position.Z))

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
      Right.X,
      Up.X,
      -Forward.X,
      Right.Y,
      Up.Y,
      -Forward.Y,
      Right.Z,
      Up.Z,
      -Forward.Z
    )
  elseif ArgumentLength == 3 then
    return CreateCFrame(Arguments[1], Arguments[2], Arguments[3], 1, 0, 0, 0, 1, 0, 0, 0, 1)
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

    return CreateCFrame(X, Y, Z, R00, R01, R02, R10, R11, R12, R20, R21, R22)
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

function CFrame.fromAxisAngle(Axis, Angle)
  Axis = Normalize(Axis)

  local HalfAngle = Angle / 2
  local S = math.sin(HalfAngle)

  return CFrame.new(0, 0, 0, Axis.X * S, Axis.Y * S, Axis.Z * S, math.cos(HalfAngle))
end

function CFrame.fromEulerAnglesXYZ(X, Y, Z)
  return CFrame.Angles(X, Y, Z)
end

function CFrame.fromOrientation(X, Y, Z)
  return CFrame.Angles(X, Y, Z)
end

function CFrame.fromMatrix(Position, Vx, Vy, Vz)
  if Vz == nil then
    Vz = Cross(Vx, Vy)
  end

  return CFrame.new(Position.X, Position.Y, Position.Z, Vx.X, Vy.X, Vz.X, Vx.Y, Vy.Y, Vz.Y, Vx.Z, Vy.Z, Vz.Z)
end

return CFrame
