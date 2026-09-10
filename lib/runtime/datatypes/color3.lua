local Color3 = {}

function Color3.fromRGB(Red, Green, Blue)
  return Color3.new(Red / 255, Green / 255, Blue / 255)
end

function Color3.fromHSV(Hue, Saturation, Value)
  local H = Hue % 1
  local S = math.max(0, math.min(1, Saturation))
  local V = math.max(0, math.min(1, Value))

  local C = V * S
  local X = C * (1 - math.abs((H * 6) % 2 - 1))
  local M = V - C

  local R, G, B

  if H < 1 / 6 then
    R, G, B = C, X, 0
  elseif H < 2 / 6 then
    R, G, B = X, C, 0
  elseif H < 3 / 6 then
    R, G, B = 0, C, X
  elseif H < 4 / 6 then
    R, G, B = 0, X, C
  elseif H < 5 / 6 then
    R, G, B = X, 0, C
  else
    R, G, B = C, 0, X
  end

  return Color3.new(R + M, G + M, B + M)
end

function Color3.fromHex(Hex)
  Hex = Hex:gsub("#", "")
  local R, G, B
  local Length = string.len(Hex)
  if Length == 3 then
    R = tonumber("0x" .. Hex:sub(1, 1)) * 16
    G = tonumber("0x" .. Hex:sub(2, 2)) * 16
    B = tonumber("0x" .. Hex:sub(3, 3)) * 16
  else
    R = tonumber("0x" .. Hex:sub(1, 2))
    G = tonumber("0x" .. Hex:sub(3, 4))
    B = tonumber("0x" .. Hex:sub(5, 6))
  end
  return Color3.fromRGB(R, G, B)
end

function Color3.new(R, G, B)
  local self = {}
  self = {
    R = 0,
    G = 0,
    B = 0,
  }
  self.R = R or 0
  self.G = G or 0
  self.B = B or 0

  function self:ToHSV()
    local R, G, B = self.R, self.G, self.B

    local Max = math.max(R, G, B)
    local Min = math.min(R, G, B)
    local Delta = Max - Min

    local H = 0
    local S = Max == 0 and 0 or Delta / Max
    local V = Max

    if Delta ~= 0 then
      if Max == R then
        H = ((G - B) / Delta) % 6
      elseif Max == G then
        H = (B - R) / Delta + 2
      else
        H = (R - G) / Delta + 4
      end

      H = H / 6
    end

    return H, S, V
  end

  function self:ToHex()
    local R = math.floor(self.R * 255)
    local G = math.floor(self.G * 255)
    local B = math.floor(self.B * 255)
    return string.format("#%02X%02X%02X", R, G, B)
  end

  function self:Lerp(Goal, Alpha)
    return Vector3.new(
      self.X + (Goal.X - self.X) * Alpha,
      self.Y + (Goal.Y - self.Y) * Alpha,
      self.Z + (Goal.Z - self.Z) * Alpha
    )
  end

  return self
end

return Color3
