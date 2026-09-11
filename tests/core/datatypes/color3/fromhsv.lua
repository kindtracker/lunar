if Color3.new == nil then
  return "Color3.new = nil"
end

local Green = Color3.fromHSV(127, 85, 83)

if Green.R ~= 32 / 255 then
  return "Green.R ~= 32/255"
end

if Green.G ~= 212 / 255 then
  return "Green.G ~= 212/255"
end

if Green.B ~= 53 / 255 then
  return "Green.B ~= 53/255"
end

return true
