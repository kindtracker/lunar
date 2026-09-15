local RandomModule = {}
local RandomService
local Instance
local TimeService

function RandomModule.__Lunar_Internal__Init__(instance, timeservice)
  Instance = instance
  TimeService = timeservice

  RandomService = Instance.new("Service")
  RandomService.Name = "RandomService"

  function RandomService.new(Seed)
    if Seed == nil then
      Seed = TimeService:Now()
    end
    local RNG = {}
    RNG.StartSeed = Seed
    RNG.CurrentSeed = Seed

    function RNG:RawRandom()
      local X = RNG.CurrentSeed
      X = X ~ ((X << 13) & 0xffffffff)
      X = X ~ (X >> 17)
      X = X ~ ((X << 5) & 0xffffffff)
      RNG.CurrentSeed = X & 0xffffffff
      return RNG.CurrentSeed
    end

    function RNG:Next()
      return RNG:RawRandom() / 0x100000000
    end

    function RNG:NextInteger(Min, Max)
      return Min + math.floor(RNG:Next() * (Max - Min + 1))
    end

    function RNG:NextNumber(Min, Max)
      if Min == nil and Max == nil then
        return RNG:Next()
      end
      if Max == nil then
        Max = Min
        Min = 0
      end

      return Min + RNG:Next() * (Max - Min)
    end

    function RNG:NextBoolean()
      return RNG:NextInteger(0, 1) == 1
    end

    function RNG:Seed(Seed)
      if Seed == nil then
        for _ = 1, 4 do
          Seed = TimeService:Now()
        end
      end
      RNG.StartSeed = Seed
      RNG.CurrentSeed = Seed
      RNG:RawRandom()
    end

    for _ = 1, 4 do
      RNG:RawRandom()
    end

    return RNG
  end

  return RandomService
end

return RandomModule
