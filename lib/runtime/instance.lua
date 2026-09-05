local CInstance = __Lunar_C__Instance__
local Instance = {}

function Instance.new()
    local self = CInstance.new()

    function self:GetChildren()
        return self.Children
    end

    return self
end

return Instance
