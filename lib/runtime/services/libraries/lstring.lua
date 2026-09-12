local LStringModule = {}
local LStringService
local Instance

function LStringModule.__Lunar_Internal__Init__(instance)
  Instance = instance

  LStringService = Instance.new("Service")
  LStringService.Name = "LStringService"

  for key, value in pairs(string) do
    LStringService[key] = value
  end

  function LStringService.split(str, sep)
    if sep == nil then
      sep = "%s"
    end
    local t = {}
    for fstr in string.gmatch(str, "([^" .. sep .. "]+)") do
      table.insert(t, fstr)
    end
    return t
  end

  function LStringService.join(t, sep)
    local result = ""

    for i, v in ipairs(t) do
      if i > 1 then
        result = result .. sep
      end
      result = result .. tostring(v)
    end

    return result
  end

  function LStringService.starts(str, start)
    return str:find("^" .. start) ~= nil
  end

  function LStringService.ends(str, ending)
    return str:sub(-#ending) == ending
  end

  function LStringService.contains(str, search)
    if str:find(search) then
      return true
    else
      return false
    end
  end

  function LStringService.trim(str)
    return str:gsub("^%s*(.-)%s*$", "%1")
  end

  function LStringService.replace(str, search, replace)
    return str:gsub("%" .. search, replace)
  end

  function LStringService.count(str, substr)
    local count = 0
    local position = 1

    while true do
      local start, finish = str:find(substr, position, true)
      if not start then
        break
      end

      count = count + 1
      position = finish + 1
    end

    return count
  end

  function LStringService.repeatstr(str, count)
    local result = ""

    while count > 0 do
      result = result .. str
      count = count - 1
    end

    return result
  end

  return LStringService
end

return LStringModule
