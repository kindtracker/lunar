local Color4 = {}

function Color4.fromRGB(Red, Green, Blue)
  return Color4.new(Red / 255, Green / 255, Blue / 255)
end

function Color4.fromRGBA(Red, Green, Blue, Alpha)
  return Color4.new(Red / 255, Green / 255, Blue / 255, Alpha / 255)
end

function Color4.fromHSV(Hue, Saturation, Value)
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

  return Color4.new(R + M, G + M, B + M)
end

function Color4.fromHSVA(Hue, Saturation, Value, Alpha)
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

  return Color4.new(R + M, G + M, B + M, Alpha / 255)
end

function Color4.fromHex(Hex)
  Hex = Hex:gsub("#", "")
  local R, G, B, A
  local Length = string.len(Hex)
  if Length == 3 then
    R = tonumber("0x" .. Hex:sub(1, 1)) * 16
    G = tonumber("0x" .. Hex:sub(2, 2)) * 16
    B = tonumber("0x" .. Hex:sub(3, 3)) * 16
    return Color4.fromRGB(R, G, B)
  elseif Length == 6 then
    R = tonumber("0x" .. Hex:sub(1, 2))
    G = tonumber("0x" .. Hex:sub(3, 4))
    B = tonumber("0x" .. Hex:sub(5, 6))
    return Color4.fromRGB(R, G, B)
  elseif Length == 4 then
    R = tonumber("0x" .. Hex:sub(1, 1)) * 16
    G = tonumber("0x" .. Hex:sub(2, 2)) * 16
    B = tonumber("0x" .. Hex:sub(3, 3)) * 16
    A = tonumber("0x" .. Hex:sub(4, 4)) * 16
    return Color4.fromRGBA(R, G, B, A)
  elseif Length == 8 then
    R = tonumber("0x" .. Hex:sub(1, 2))
    G = tonumber("0x" .. Hex:sub(3, 4))
    B = tonumber("0x" .. Hex:sub(5, 6))
    A = tonumber("0x" .. Hex:sub(7, 8))
    return Color4.fromRGBA(R, G, B, A)
  end
end

function Color4.new(R, G, B, A)
  local self = {}
  self = {
    R = 0,
    G = 0,
    B = 0,
    A = 0,
  }
  self.R = R or 0
  self.G = G or 0
  self.B = B or 0
  self.A = A or 0

  function self:ToHSV()
    local R, G, B, A = self.R, self.G, self.B, self.A

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

    return H * A, S * A, V * A
  end

  function self:ToHex()
    local R = math.floor(self.R * 255)
    local G = math.floor(self.G * 255)
    local B = math.floor(self.B * 255)
    local A = math.floor(self.A * 255)
    return string.format("#%02X%02X%02X%20X", R, G, B, A)
  end

  function self:Lerp(Goal, Alpha)
    return Color4.new(
      self.R + (Goal.R - self.R) * Alpha,
      self.G + (Goal.G - self.G) * Alpha,
      self.B + (Goal.B - self.B) * Alpha,
      self.A + (Goal.A - self.A) * Alpha
    )
  end

  return self
end

return Color4
