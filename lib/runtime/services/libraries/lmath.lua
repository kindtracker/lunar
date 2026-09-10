local LMathModule = {}
local LMathService
local Instance

function LMathModule.__Lunar_Internal__Init__(instance)
  Instance = instance

  LMathService = Instance.new("LMathService")
  LMathService.Name = "LMathService"

  LMathService.nan = 0 / 0

  for key, value in pairs(math) do
    LMathService[key] = value
  end

  function LMathService.sign(x)
    if x > 0 then
      return 1
    end
    if x < 0 then
      return -1
    end
    return 0
  end

  function LMathService.clamp(x, min, max)
    if x > max then
      return max
    elseif x < min then
      return min
    end
  end

  function LMathService.lerp(a, b, t)
    return a + (b - a) * t
  end

  function LMathService.round(a)
    return LMathService.floor(a + 0.5)
  end

  function LMathService.wrap(x, min, max)
    return (x - min) % (max - min) + min
  end

  function LMathService.isnan(x)
    return tostring(x) == tostring(LMathService.nan)
  end

  function LMathService.isinf(x)
    return x == LMathService.huge
  end

  function LMathService.isfinite(x)
    return x ~= LMathService.huge
  end

  function LMathService.log10(x)
    return LMathService.log(x, 10)
  end

  function LMathService.log2(x)
    return LMathService.log(x, 2)
  end

  function LMathService.atan2(y, x)
    return math.atan(y, x)
  end

  return LMathService
end

return LMathModule
