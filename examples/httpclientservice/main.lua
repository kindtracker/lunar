local HttpClientService = Lunar:GetService("HttpClientService")
local Console = Lunar:GetService("ConsoleService")

local Url = "http://example.com/"
local Response = HttpClientService:Get(Url)
if Response.Result ~= 1 then
  Console:Error("Failed to get %s", Url)
end
Console:Log("Status: %d", Response.Status)
print(Response.Body)
