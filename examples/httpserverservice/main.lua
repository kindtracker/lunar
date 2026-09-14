local HttpServerService = Lunar:GetService("HttpServerService")
local Console = Lunar:GetService("ConsoleService")

local Server = HttpServerService:Create({
  Port = 8080,
  Host = "127.0.0.1",
})

Server:Route("/", function(Request, Response)
  Console:Log("%s", Request.Path)
  Response:Write("<h1>Hello, World!</h1>")
  Response:Close()
end)

Server:Listen()
