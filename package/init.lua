local Lunar = {}

local InitResponse = require("lunar.src.init")

_G.Connection = InitResponse.Connection
_G.Signal = InitResponse.Signal
_G.Instance = InitResponse.Instance

_G.Vector2 = InitResponse.Vector2
_G.Vector3 = InitResponse.Vector3
_G.Color3 = InitResponse.Color3
_G.Color4 = InitResponse.Color4
_G.CFrame = InitResponse.CFrame
_G.UDim = InitResponse.UDim
_G.UDim2 = InitResponse.UDim2
_G.Random = InitResponse.RandomModule

_G.lmath = InitResponse.LMathLibrary
_G.ltable = InitResponse.LTableLibrary
_G.lstring = InitResponse.LStringLibrary

for Key, Value in pairs(InitResponse) do
  Lunar[Key] = Value
end

Lunar.GetService = InitResponse.ServiceManager.GetService

return Lunar
