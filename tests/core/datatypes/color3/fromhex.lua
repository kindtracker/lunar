if Color3.new == nil then
  return "Color3.new = nil"
end

local Red = Color3.fromHex("#f00")

if Red.R ~= 1 then
  return "Red.R ~= 1"
end

return true
