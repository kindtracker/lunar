local JSONService = Lunar:GetService("JSONService")
local Console = Lunar:GetService("ConsoleService")

local OriginalTable = {a = "b", d = nil, b = {}, c = 2}
local OriginalTableS = '{a="b",d=nil,b={},c=2}'

local JSON = JSONService:Encode(OriginalTable)

print(Console:Log("%s -> %s", OriginalTableS, JSON))
