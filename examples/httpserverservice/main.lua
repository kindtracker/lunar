local HttpServerService = Lunar:GetService("HttpServerService")
local Console = Lunar:GetService("ConsoleService")

local Server = HttpServerService:Create({
  Port = 8080,
  Host = "127.0.0.1",
  Location = "Workspace",
})

Server:Route("GET", "/hello", function(Request, Response)
  Console:Log("%s", Request.Path)
  Response:Write("<h1>Helllo!</h1>")
  Response:Close()
end)

Server:Listen()
