local UDim = {}

function UDim.new(Scale, Offset)
  local Properties = {
    Scale = 0,
    Offset = 0,
  }

  Properties.Scale = Scale or 0
  Properties.Offset = Offset or 0

  local Proxy

  Proxy = setmetatable({}, {
    __index = function(_, key)
      return Properties[key]
    end,
    __newindex = function(_, key, value)
      Properties[key] = value
    end,
    __pairs = function()
      return next, Properties, nil
    end,
    __add = function(A, B)
      return UDim.new(A.Scale + B.Scale, A.Offset + B.Offset)
    end,
    __sub = function(A, B)
      return UDim.new(A.Scale - B.Scale, A.Offset - B.Offset)
    end,
    __mul = function(A, B)
      if type(B) == "number" then
        return UDim.new(A.Scale * B, A.Offset * B)
      end
      return UDim.new(A.Scale * B.Scale, A.Offset * B.Offset)
    end,
    __div = function(A, B)
      if type(B) == "number" then
        return UDim.new(A.Scale / B, A.Offset / B)
      end
      return UDim.new(A.Scale / B.Scale, A.Offset / B.Offset)
    end,
    __unm = function(A)
      return UDim.new(-A.Scale, -A.Offset)
    end,
    __eq = function(A, B)
      return A.Scale == B.Scale and A.Offset == B.Offset
    end,
    __tostring = function(A)
      return string.format("%g, %g", A.Scale, A.Offset)
    end,
  })

  function Proxy:Lerp(Goal, Alpha)
    return UDim.new(Properties.Scale + (Goal.Scale - Properties.Scale) * Alpha)
  end

  return Proxy
end

return UDim
