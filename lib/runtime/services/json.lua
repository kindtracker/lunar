local JSONModule = {}
local JSONService
local Instance

function JSONModule.__Lunar_Internal__Init__(instance)
  Instance = instance

  JSONService = Instance.new("JSONService")
  JSONService.Name = "JSONService"

  JSONService.Null = setmetatable({}, {
    __tostring = function()
      return "null"
    end,
  })

  function JSONService:Encode(Table)
    local JSONT = {}

    local Keys = {}
    for key in pairs(Table) do
      table.insert(Keys, key)
    end
    table.sort(Keys)

    for _, key in ipairs(Keys) do
      local value = Table[key]

      if tostring(value) == "null" then
        value = "null"
      elseif type(value) == "table" then
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
    JSON = JSON:gsub('([,{]%s*)"(.-)"%s*:', '%1["%2"]=')

    local Chunk = load("return " .. JSON, "JSON", "t", {})
    if Chunk == nil then
      return nil
    end
    return Chunk()
  end

  return JSONService
end

return JSONModule
