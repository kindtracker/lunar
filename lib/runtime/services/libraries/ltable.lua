local LTableModule = {}
local LTableService
local Instance

function LTableModule.__Lunar_Internal__Init__(instance)
	Instance = instance

	LTableService = Instance.new("LTableService")
	LTableService.Name = "LTableService"

	for key, value in pairs(table) do
		LTableService[key] = value
	end

	function LTableService.clear(t)
		for k in pairs(t) do
			t[k] = nil
		end
	end

	function LTableService.clone(t, deep)
		local t2 = {}
		for k, v in pairs(t) do
			if deep and type(v) == "table" then
				v = LTableService.clone(t, true)
			end
			t2[k] = v
		end
		return t2
	end

	function LTableService.find(t, vtf)
		for i, v in pairs(t) do
			if v == vtf then
				return i
			end
		end
	end

	function LTableService.contains(t, v)
		for _, value in pairs(t) do
			if value == v then
				return true
			end
		end
		return false
	end

	function LTableService.count(t)
		local c = 0
		for _, _ in pairs(t) do
			c = c + 1
		end
		return c
	end

	function LTableService.keys(t)
		local tk = {}
		for k, _ in pairs(t) do
			table.insert(tk, k)
		end
		return tk
	end

	function LTableService.values(t)
		local tv = {}
		for _, v in pairs(t) do
			table.insert(tv, v)
		end
		return tv
	end

	function LTableService.isempty(t)
		return next(t) == nil
	end

	function LTableService.push(...)
		return LTableService.insert(...)
	end

	return LTableService
end

return LTableModule
