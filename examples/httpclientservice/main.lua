local HttpClientService = Lunar:GetService("HttpClientService")

local Url = "http://example.com/"
local Content = HttpClientService:Get(Url)
print(Content)
