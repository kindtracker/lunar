local UDim2 = {}
local UDim

function UDim2.__Lunar_Internal__Init__(udim)
  UDim = udim
end

function UDim2.fromScale(xScale, yScale)
  UDim2.new(xScale, 0, yScale, 0)
end

function UDim2.fromOffset(xOffset, yOffset)
  UDim2.new(0, xOffset, 0, yOffset)
end

function UDim2.new(...)
  local Properties = {
    X = UDim.new(),
    Y = UDim.new(),
    Width = UDim.new(),
    Height = UDim.new(),
  }

  local Arguments = { ... }
  local ArgumentLength = #Arguments

  if ArgumentLength == 4 then
    Properties.X.Scale = Arguments[1]
    Properties.X.Offset = Arguments[2]
    Properties.Y.Scale = Arguments[3]
    Properties.Y.Offset = Arguments[4]
  elseif ArgumentLength == 2 then
    Properties.X = Arguments[1]
    Properties.Y = Arguments[2]
  end

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
      return UDim2.new(A.X + B.X, A.Y + B.Y, A.Width + B.Width, A.Height + B.Height)
    end,
    __sub = function(A, B)
      return UDim2.new(A.X - B.X, A.Y - B.Y, A.Width - B.Width, A.Height - B.Height)
    end,
    __mul = function(A, B)
      if type(B) == "number" then
        return UDim2.new(A.X * B, A.Y * B, A.Width * B, A.Height * B)
      end
      return UDim2.new(A.X * B.X, A.Y * B.Y, A.Width * B.Width, A.Height * B.Height)
    end,
    __div = function(A, B)
      if type(B) == "number" then
        return UDim2.new(A.X / B, A.Y / B, A.Width / B, A.Height / B)
      end
      return UDim2.new(A.X / B.X, A.Y / B.Y, A.Width / B.Width, A.Height / B.Height)
    end,
    __unm = function(A)
      return UDim2.new(-A.X, -A.Y, -A.Width, -A.Height)
    end,
    __eq = function(A, B)
      return A.X == B.X and A.Y == B.Y and A.Width == B.Width and B.Height == B.Height
    end,
    __tostring = function(A)
      return string.format("{%g, %g}, {%g, %g}", A.X.Scale, A.Y.Scale, A.Width.Scale, A.Height.Offset)
    end,
  })

  function Proxy:Lerp(Goal, Alpha)
    return UDim2.new(
      Properties.Scale + (Goal.Scale - Properties.Scale) * Alpha,
      Properties.Offset + (Goal.Offset - Properties.Offset) * Alpha,
      Properties.Width + (Goal.Width - Properties.Width) * Alpha,
      Properties.Height + (Goal.Height - Properties.Height) * Alpha
    )
  end

  return Proxy
end

return UDim2
