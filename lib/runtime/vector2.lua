local Vector2 = {}

function Vector2.new(X, Y)
  local self = {}

  local Properties = {
    X = 0,
    Y = 0
  }

  Properties.X = X or 0
  Properties.Y = Y or 0

  local Proxy
  Proxy = setmetatable({}, {
    __index = function(_, key)
      return Properties[key]
    end,

    __newindex = function(_, key, newValue)
      Properties[key] = newValue
    end,
    
    __len = function()
      return #Properties.Children
    end,

    __pairs = function()
      return next, Properties, nil
    end
  })

  return Proxy
end

return Vector2
