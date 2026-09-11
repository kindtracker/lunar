local http = require("socket.http")

local HttpClientModule = {}
local HttpClientService
local Instance

function HttpClientModule.__Lunar_Internal__Init__(instance)
  Instance = instance

  HttpClientService = Instance.new("Service")
  HttpClientService.Name = "HttpClientService"

  function HttpClientService:Request(RequestOptions)
    return http.request({
      url = RequestOptions.Url,
      headers = RequestOptions.Headers,
      method = RequestOptions.Method,
      proxy = RequestOptions.Proxy,
      redirect = RequestOptions.FollowRedirect or true,
      sink = RequestOptions.__Hidden_socket_http__sink,
      create = RequestOptions.__Hidden_socket_http__create,
      step = RequestOptions.__Hidden_socket_http__step,
      source = RequestOptions.__Hidden_socket_http__source,
    })
  end

  return HttpClientService
end

return HttpClientModule
