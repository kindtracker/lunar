if Color4.new == nil then
  return "Color4.new = nil"
end

local Red = Color4.fromHSV(127, 85, 83, 0.85 * 255)

if Red.R ~= 32 / 255 then
  return "Red.R ~= 32/255"
end

if Red.G ~= 212 / 255 then
  return "Red.G ~= 212/255"
end

if Red.B ~= 53 / 255 then
  return "Red.B ~= 53/255"
end

if Red.A ~= 0.85 then
  return "Red.A ~= 0.85"
end

return true
