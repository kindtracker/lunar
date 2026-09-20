local pegasus = require("pegasus")

local HttpServerModule = {}
local HttpServerService
local Instance
local FileSystemService

function HttpServerModule.__Lunar_Internal__Init__(instance, filesystemservice)
  Instance = instance
  FileSystemService = filesystemservice

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
    })
    PServer.Routes = {}
    PServer.Uses = {}

    function PServerRequestCallback(PRequest, PResponse, CurrentUse)
      if CurrentUse == nil then
        CurrentUse = #PServer.Uses
      end
      local Path = PRequest:path()

      if Path == "/" then
        Path = "/index.html"
      end

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

      if CurrentUse ~= 0 then
        local Use = PServer.Uses[CurrentUse]
        local AllowedNextUse = false

        local function Next()
          AllowedNextUse = true
        end
        Use(Request, Response, Next)
        if not AllowedNextUse then
          return nil
        end
        return PServerRequestCallback(PRequest, PResponse, CurrentUse - 1)
      end

      local FilePath = Options.Location .. "/" .. Request.Path
      if FileSystemService:Exists(FilePath) then
        return Response:WriteFile(FilePath)
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

    function PServer:Use(Callback)
      table.insert(PServer.Uses, Callback)
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
