local http = require("socket.http")
local ltn12 = require("ltn12")

local HttpBaseModule = {}
local HttpBaseService
local Instance
local JSONService

function HttpBaseModule.__Lunar_Internal__Init__(instance, jsonservice)
  Instance = instance
  JSONService = jsonservice

  HttpBaseService = Instance.new("Service")
  HttpBaseService.Name = "HttpBaseService"

  function HttpBaseService:JSONEncode(Table)
    return JSONService:Encode(Table)
  end

  function HttpBaseService:JSONDecode(JSON)
    return JSONService:Decode(JSON)
  end

  return HttpBaseService
end

return HttpBaseModule
