local TimeService = Lunar:GetService("TimeService")
local Console = Lunar:GetService("ConsoleService")

Console:Log("Now: %f", TimeService:Now())
Console:Log("Elapsed: %f", TimeService:Elapsed())
Console:Log("Now but with precise: %f", TimeService:PreciseNow())
Console:Log(TimeService:Date("Current year is %Y"))
