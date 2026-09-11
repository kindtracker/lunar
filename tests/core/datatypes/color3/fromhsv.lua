if Color3.new == nil then
  return "Color3 = nil"
end

local Red = Color3.fromHSV(127, 85, 83)

if Red.R ~= 32 / 255 then
  return "Red.R ~= 32/255"
end

if Red.G ~= 212 / 255 then
  return "Red.G ~= 212/255"
end

if Red.B ~= 53 / 255 then
  return "Red.B ~= 53/255"
end

return true
