if Color4.new == nil then
  return "Color4.new = nil"
end

local Red = Color4.fromHex("#f00f")

if Red.R ~= 1 then
  return "Red.R ~= 1"
end

if Red.A ~= 1 then
  return "Red.A ~= 1"
end

return true
