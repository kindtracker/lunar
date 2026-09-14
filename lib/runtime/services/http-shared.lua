local HttpSharedModule = {}
local HttpSharedService
local Instance
local JSONService

function HttpSharedModule.__Lunar_Internal__Init__(instance, jsonservice)
  Instance = instance
  JSONService = jsonservice

  HttpSharedService = Instance.new("Service")
  HttpSharedService.Name = "HttpSharedService"

  function HttpSharedService:JSONEncode(Table)
    return JSONService:Encode(Table)
  end

  function HttpSharedService:JSONDecode(JSON)
    return JSONService:Decode(JSON)
  end

  return HttpSharedService
end

return HttpSharedModule
