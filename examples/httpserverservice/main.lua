local HttpServerService = Lunar:GetService("HttpServerService")
local Console = Lunar:GetService("ConsoleService")

-- You can access /index.html (or /) and /hello

local Server = HttpServerService:Create({
  Port = 8080,
  Host = "127.0.0.1",
  Location = "Workspace/",
})

Server:Use(function(Request, Response, Next)
  Console:Log("Request.Path: %s", Request.Path)
  Next()
end)

Server:Route("GET", "/hello", function(Request, Response)
  Console:Log("%s", "Hellllo user!")
  Response:Write("<h1>Helllo!</h1>")
  Response:Close()
end)

Server:Listen(function()
  Console:Info("Server running at http://localhost:8080/")
end)
