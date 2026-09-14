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

  function HttpServerService:Create(Port, Host, Location)
    local PServer = pegasus:new({
      port = Port,
      host = Host,
      location = Location,
    })

    PServer.Routes = {}

    function PServerRequestCallback(PRequest, PResponse)
      local Path = PRequest.path

      local Request = {
        Path = Path,
        Params = {},
      }

      local Response = {}

      function Response:Write(Content)
        PResponse:write(Content)
      end

      for _, Route in ipairs(PServer.Routes) do
        local Params = HttpServerService:MatchRoute(Route.Path, Path)

        if Params then
          Request.Params = Params
          Route.Callback(Request, Response)
          return
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
