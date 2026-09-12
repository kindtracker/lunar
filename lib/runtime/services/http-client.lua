local http = require("socket.http")
local ltn12 = require("ltn12")

local HttpClientModule = {}
local HttpClientService
local Instance

function HttpClientModule.__Lunar_Internal__Init__(instance)
  Instance = instance

  HttpClientService = Instance.new("Service")
  HttpClientService.Name = "HttpClientService"

  HttpClientService.RequestOptions = {}

  function HttpClientService:__Lunar_Internal__Convert_RequestOptions__(RequestOptions, NoUrl, Method)
    return {
      url = NoUrl and nil or RequestOptions.Url,
      headers = Method or RequestOptions.Headers,
      method = RequestOptions.Method,
      proxy = RequestOptions.Proxy,
      redirect = RequestOptions.FollowRedirect or true,
      sink = RequestOptions.__Hidden_socket_http__sink,
      create = RequestOptions.__Hidden_socket_http__create,
      step = RequestOptions.__Hidden_socket_http__step,
      source = RequestOptions.__Hidden_socket_http__source,
    }
  end

  function HttpClientService:Request(Url)
    if Url then
      HttpClientService.RequestOptions.Url = Url
    end
    return http.request(
      HttpClientService:__Lunar_Internal__Convert_RequestOptions__(HttpClientService.RequestOptions, true, nil)
    )
  end

  function HttpClientService:Get(Url)
    if Url then
      HttpClientService.RequestOptions.Url = Url
    end
    return http.request(
      HttpClientService:__Lunar_Internal__Convert_RequestOptions__(HttpClientService.RequestOptions, true, "GET")
    )
  end

  return HttpClientService
end

return HttpClientModule
