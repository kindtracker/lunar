local Vector3 = {}

function Sign(Number)
  if Number > 0 then
    return 1
  end
  if Number < 0 then
    return -1
  end
  return 0
end

function Vector3.new(X, Y, Z)
  local Properties = {
    X = 0,
    Y = 0,
    Z = 0
  }

  Properties.X = X or 0
  Properties.Y = Y or 0
  Properties.Z = Z or 0
  Properties.one = Vector3.new(1, 1, 1)
  Properties.zero = Vector3.new(0, 0, 0)
  Properties.xAxis = Vector3.new(1, 0, 0)
  Properties.yAxis = Vector3.new(0, 1, 0)
  Properties.zAxis = Vector3.new(0, 0, 1)

  local Proxy

  Proxy = setmetatable({}, {
    __index = function(_, key)
      if key == "Magnitude" then
        return math.sqrt(Properties.X ^ 2 + Properties.Y ^ 2 + Properties.Z ^ 2)
      end

      if key == "Unit" then
        local Length = math.sqrt(Properties.X ^ 2 + Properties.Y ^ 2 ^ Properties.Z ^ 2)
        
        if Length == 0 then
          return Vector3.new(0, 0, 0)
        end
        
        return Vector3.new(Properties.X / Length, Properties.Y / Length, Properties.Z / Length)
      end

      return Properties[key]
    end,
    __newindex = function(_, key, Value)
      if key == "xAxis" then
        return
      end
      if key == "yAxis" then
        return
      end
      if key == "zAxis" then
        return
      end
      if key == "one" then
        return
      end
      if key == "zero" then
        return
      end
      Properties[key] = Value
    end,
    __pairs = function()
      return next, Properties, nil
    end,
    __add = function(A, B)
      return Vector3.new(A.X+B.X, A.Y+B.Y, A.Z+B.Z)
    end,
    __sub = function(A, B)
      return Vector3.new(A.X-B.X, A.Y-B.Y, A.Z-B.Z)
    end,
    __mul = function(A, B)
      if type(B) == "number" then
        return Vector3.new(A.X*B, A.Y*B, A.Z*B)
      end
      return Vector3.new(A.X*B.X, A.Y*B.Y, A.Z*B.Z)
    end,
    __div = function(A, B)
      if type(B) == "number" then
        return Vector3.new(A.X/B, A.Y/B, A.Z/B)
      end
      return Vector3.new(A.X/B.X, A.Y/B.Y, A.Z/B.Z)
    end,
    __unm = function(A)
      return Vector3.new(-A.X, -A.Y, -A.Z)
    end,
    __eq = function(A, B)
      return A.X == B.X and A.Y == B.Y and A.Z == B.Z
    end,
    __tostring = function(A)
      return string.format("%g, %g, %g", A.X, A.Y, A.Z)
    end,
  })

  function Proxy:Abs()
    return Vector3.new(math.abs(Properties.X), math.abs(Properties.Y), math.abs(Properties.Z))
  end

  function Proxy:Ceil()
    return Vector3.new(math.ceil(Properties.X), math.ceil(Properties.Y), math.ceil(Properties.Z))
  end

  function Proxy:Floor()
    return Vector3.new(math.floor(Properties.X), math.floor(Properties.Y), math.floor(Properties.Z))
  end

  function Proxy:Sign()
    return Vector3.new(Sign(Properties.X), Sign(Properties.Y), Sign(Properties.Z))
  end

  function Proxy:Min(vector3)
    return Vector3.new(math.min(Properties.X, vector2.X), math.min(Properties.Y, vector2.Y), math.min(Properties.Z, vector3.Z))
  end

  function Proxy:Max(vector3)
    return Vector3.new(math.max(Properties.X, vector2.X), math.max(Properties.Y, vector2.Y), math.max(Properties.Z, vector3.Z))
  end

  function Proxy:Angle(Other, IsSigned)
    local Magnitude = Properties.Magnitude * Other.Magnitude

    if Magnitude == 0 then
      return 0
    end

    local Dot = Proxy:Dot(Other)

    if IsSigned then
      local Cross = Properties.X * Other.Y - Properties.Y * Other.X
      return math.atan2(Cross, Dot)
    end

    local Cosine = Dot / Magnitude
    Cosine = math.max(-1, math.min(1, Cosine))
    return math.acos(Cosine)
  end

  function Proxy:Dot(Other)
    return Properties.X * Other.X + Properties.Y * Other.Y + Properties.Z * Other.Z
  end

  function Proxy:Lerp(Goal, Alpha)
    return Vector3.new(
      Properties.X + (Goal.X - Properties.X) * Alpha, 
      Properties.Y + (Goal.Y - Properties.Y) * Alpha, 
      Properties.Z + (Goal.Z - Properties.Z) * Alpha)
  end

  return Proxy
end

return Vector3
