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
        Method = PRequest:method(),
        Path = Path,
        Params = {},
        Headers = PRequest:headers(),
        PostData = PRequest:post(),
        Ip = PRequest.ip,
        Port = PRequest.port,
        QueryString = PRequest.querystring,
      }

      local Response = {}

      Response.Redirect = PResponse.writeDefaultErrorMessage
      Response.WriteErrorMessage = PResponse.writeDefaultErrorMessage
      Response.WriteFile = PResponse.writeFile
      Response.Write = PResponse.write
      Response.AddHeader = PResponse.addHeader
      Response.AddHeaders = PResponse.addHeaders
      Response.SetStatusCode = PResponse.statusCode
      Response.SetContentType = PResponse.contentType

      function Response:Close()
        return PResponse:close()
      end

      for _, Route in ipairs(PServer.Routes) do
        if Route.Method ~= Request.Method then
          goto continue
        end
        local Params = HttpServerService:MatchRoute(Route.Path, Path)

        if Params then
          Request.Params = Params
          return Route.Callback(Request, Response)
        end
        ::continue::
      end
    end

    function PServer:Route(Method, Path, Callback)
      table.insert(PServer.Routes, {
        Method = Method,
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
