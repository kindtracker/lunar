local JSONModule = {}
local JSONService
local Instance

function JSONModule.__Lunar_Internal__Init__(instance)
  Instance = instance

  JSONService = Instance.new("JSONService")
  JSONService.Name = "JSONService"

  function JSONService:Encode(Table)
    local JSONT = {}
    for key, value in pairs(Table) do
      if type(value) == "table" then
        value = JSONService:Encode(value)
      elseif type(value) == "string" then
        value = string.format("%q", value)
      else
        value = tostring(value)
      end
      table.insert(JSONT, string.format("%q:%s", key, value))
    end
    return string.format("{%s}", table.concat(JSONT, ","))
  end

  function JSONService:Decode(JSON)
    JSON = JSON:gsub("null", "nil")
    JSON = JSON:gsub("%[", "{")
    JSON = JSON:gsub("%]", "}")
    JSON = JSON:gsub('"(.-)":', '["%1"]=')

    local Chunk = load("return " .. JSON, "JSON", "t", {})
    return Chunk()
  end

  return JSONService
end

return JSONModule
