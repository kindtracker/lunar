local neturl = require("url")

local HttpSharedModule = {}
local HttpSharedService
local Instance
local JSONService

function HttpSharedModule.__Lunar_Internal__Init__(instance, jsonservice)
  Instance = instance
  JSONService = jsonservice

  HttpSharedService = Instance.new("Service")
  HttpSharedService.Name = "HttpSharedService"

  function HttpSharedService:QueryDecode(QueryString)
    return neturl.parseQuery(QueryString)
  end

  function HttpSharedService:QueryEncode(QueryTable)
    return neturl.buildQuery(QueryTable)
  end

  function HttpSharedService:UrlParse(Url)
    local NUTable = neturl.parse(Url)
    return {
      Scheme = NUTable.scheme,
      UserInfo = NUTable.userinfo,
      User = NUTable.user,
      Password = NUTable.password,
      Authority = NUTable.authority,
      Host = NUTable.host,
      Port = NUTable.port,
      Path = NUTable.path,
      Query = NUTable.query,
      Fragment = NUTable.fragment,
    }
  end

  function HttpSharedService:UrlBuild(Url)
    return neturl.parse(Url):build()
  end

  function HttpSharedService:UrlNormalize(Url)
    return neturl.parse(Url):normalize()
  end

  function HttpSharedService:UrlAddSegment(Url, Segment)
    return neturl.parse(Url) / Segment
  end

  function HttpSharedService:UrlRemoveDotSegments(Path)
    return neturl.removeDotSegments(Path)
  end

  function HttpSharedService:UrlResolve(BaseUrl, RelativeUrl)
    local Base = neturl.parse(BaseUrl)
    return tostring(Base:resolve(RelativeUrl))
  end

  function HttpSharedService:UrlSetQuery(Url, Query)
    local URLObject = neturl.parse(Url)
    URLObject:setQuery(Query)
    return URLObject:build()
  end

  function HttpSharedService:UrlSetAuthority(Url, Authority)
    local URLObject = neturl.parse(Url)
    URLObject:setAuthority(Authority)
    return URLObject:build()
  end

  function HttpSharedService:JSONEncode(Table)
    return JSONService:Encode(Table)
  end

  function HttpSharedService:JSONDecode(JSON)
    return JSONService:Decode(JSON)
  end

  return HttpSharedService
end

return HttpSharedModule
