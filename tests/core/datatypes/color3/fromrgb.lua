if Color3.new == nil then
  return "Color3 = nil"
end

local Red = Color3.fromRGB(255, 0, 0)

if Red.R ~= 1 then
  return "Red.R ~= 1"
end

return true
