local json = require("json")

local JSONModule = {}
local JSONService
local Instance

function JSONModule.__Lunar_Internal__Init__(instance)
  Instance = instance

  JSONService = Instance.new("Service")
  JSONService.Name = "JSONService"

  function JSONService:Encode(Table)
    return json.encode(Table)
  end

  function JSONService:Decode(JSON)
    return json.decode(JSON)
  end

  return JSONService
end

return JSONModule
