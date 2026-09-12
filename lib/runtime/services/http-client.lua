local http = require("socket.http")
local ltn12 = require("ltn12")

local HttpClientModule = {}
local HttpClientService
local Instance

function HttpClientModule.__Lunar_Internal__Init__(instance)
  Instance = instance

  HttpClientService = Instance.new("Service")
  HttpClientService.Name = "HttpClientService"

  HttpClientService.RequestOptions = { Headers = {} }

  function HttpClientService:__Lunar_Internal__Convert_RequestOptions__(RequestOptions)
    return {
      url = RequestOptions.Url,
      headers = RequestOptions.Headers,
      method = RequestOptions.Method,
      proxy = RequestOptions.Proxy,
      redirect = (not RequestOptions.FollowRedirect) or false,
      sink = RequestOptions.__Hidden_socket_http__sink,
      create = RequestOptions.__Hidden_socket_http__create,
      step = RequestOptions.__Hidden_socket_http__step,
      source = RequestOptions.__Hidden_socket_http__source,
    }
  end

  function HttpClientService:__Lunar_Internal__Clear_RequestOptions__()
    HttpClientService.RequestOptions.Method = "GET"
    HttpClientService.RequestOptions.Headers["Content-Type"] = nil
    HttpClientService.RequestOptions.Headers["Content-Length"] = nil
    HttpClientService.RequestOptions.__Hidden_socket_http__source = nil
    HttpClientService.RequestOptions.__Hidden_socket_http__sink = nil
  end

  function HttpClientService:Request(Url)
    if Url then
      HttpClientService.RequestOptions.Url = Url
    end
    return http.request(HttpClientService:__Lunar_Internal__Convert_RequestOptions__(HttpClientService.RequestOptions))
  end

  function HttpClientService:Get(Url, __Lunar_Interna__Override_Method__)
    HttpClientService.RequestOptions.Url = Url
    HttpClientService.RequestOptions.Method = __Lunar_Interna__Override_Method__ or "GET"
    return http.request(HttpClientService:__Lunar_Internal__Convert_RequestOptions__(HttpClientService.RequestOptions))
  end

  function HttpClientService:Post(Url, ContentType, Body, __Lunar_Interna__Override_Method__)
    local Response = {}
    HttpClientService.RequestOptions.Url = Url
    HttpClientService.RequestOptions.Method = __Lunar_Interna__Override_Method__ or "POST"
    HttpClientService.RequestOptions.Headers["Content-Type"] = ContentType
    HttpClientService.RequestOptions.Headers["Content-Length"] = tostring(#Body)
    HttpClientService.RequestOptions.__Hidden_socket_http__source = ltn12.source.string(Body)
    HttpClientService.RequestOptions.__Hidden_socket_http__sink = ltn12.sink.table(Response)
    http.request(HttpClientService:__Lunar_Internal__Convert_RequestOptions__(HttpClientService.RequestOptions))
    HttpClientService:__Lunar_Internal__Clear_RequestOptions__()
    return table.concat(Response)
  end

  function HttpClientService:Put(Url, ContentType, Body)
    return HttpClientService:Post(Url, ContentType, Body, "PUT")
  end

  function HttpClientService:Patch(Url, ContentType, Body)
    return HttpClientService:Post(Url, ContentType, Body, "PATCH")
  end

  function HttpClientService:Delete(Url)
    return HttpClientService:Get(Url, "DELETE")
  end

  function HttpClientService:Head(Url)
    HttpClientService:Get(Url, "HEAD")
  end

  HttpClientService:__Lunar_Internal__Clear_RequestOptions__()

  return HttpClientService
end

return HttpClientModule
