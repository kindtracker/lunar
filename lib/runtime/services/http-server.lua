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
    PServer.Uses = {}

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

      function Response:Redirect(Location, Temporary)
        return PResponse:redirect(Location, Temporary)
      end

      function Response:WriteErrorMessage(StatusCode, Message)
        return PResponse:writeDefaultErrorMessage(StatusCode, Message)
      end

      function Response:WriteFile(File)
        return PResponse:writeFile(File)
      end

      function Response:Write(Content)
        return PResponse:write(Content)
      end

      function Response:AddHeader(Key, Value)
        return PResponse:addHeader(Key, Value)
      end

      function Response:AddHeaders(Headers)
        return PResponse:addHeaders(Headers)
      end

      function Response:SetStatusCode(StatusCode, StatusMessage)
        return PResponse:statusCode(StatusCode, StatusMessage)
      end

      function Response:SetContentType(Value)
        return PResponse:contentType(Value)
      end

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

    function PServer:Listen(Callback)
      if Callback then
        Callback()
      end
      PServer:start(PServerRequestCallback)
    end

    return PServer
  end

  return HttpServerService
end

return HttpServerModule
