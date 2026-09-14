local pegasus = require("pegasus")

local HttpServerModule = {}
local HttpServerService
local Instance

function HttpServerModule.__Lunar_Internal__Init__(instance)
  Instance = instance

  HttpServerService = Instance.new("Service")
  HttpServerService.Name = "HttpServerService"

  function HttpServerService:MatchRoute(Route, Path)
    local Params = {}
    local Names = {}

    local Pattern = Route:gsub(":([%w_]+)", function(Name)
      table.insert(Names, Name)
      return "([^/]+)"
    end)

    local Captures = { Path:match("^" .. Pattern .. "$") }

    if #Captures == 0 then
      return nil
    end

    for Index, Name in ipairs(Names) do
      Params[Name] = Captures[Index]
    end

    return Params
  end

  function HttpServerService:Create(Options)
    local PServer = pegasus:new({
      port = Options.Port or 8080,
      host = Options.Host or "127.0.0.1",
      location = Options.Location,
    })
    PServer.Routes = {}

    function PServerRequestCallback(PRequest, PResponse)
      local Path = PRequest:path()

      local Request = {
        Path = Path,
        Params = {},
      }

      local Response = {}

      function Response:Write(Content)
        PResponse:write(Content)
      end

      function Response:Close()
        return PResponse:close()
      end

      for _, Route in ipairs(PServer.Routes) do
        local Params = HttpServerService:MatchRoute(Route.Path, Path)

        if Params then
          Request.Params = Params
          return Route.Callback(Request, Response)
        end
      end
    end

    function PServer:Route(Path, Callback)
      table.insert(PServer.Routes, {
        Path = Path,
        Callback = Callback,
      })
    end

    function PServer:Listen()
      PServer:start(PServerRequestCallback)
    end

    return PServer
  end

  return HttpServerService
end

return HttpServerModule
