local JSONService = Lunar:GetService("JSONService")
local Console = Lunar:GetService("ConsoleService")

local OriginalTable = {a = "b", d = JSONService.Null, b = {}, c = 2}
local OriginalTableS = '{a="b",d=JSONService.Null,b={},c=2}'

local JSON = JSONService:Encode(OriginalTable)

Console:Log("%s -> %s", OriginalTableS, JSON)
local NOriginalTable = JSONService:Decode(JSON)
Console:Log("%s -> %s", JSON, NOriginalTable)

for k, v in pairs(NOriginalTable) do
  print(string.format("%s: %s", k, v))
end
