local Vector2 = {}

function Sign(Number)
	if Number > 0 then
		return 1
	end
	if Number < 0 then
		return -1
	end
	return 0
end

function Vector2.new(X, Y)
	local Properties = {
		X = 0,
		Y = 0,
	}

	Properties.X = X or 0
	Properties.Y = Y or 0

	local Proxy

	Proxy = setmetatable({}, {
		__index = function(_, key)
			if key == "Magnitude" then
				return math.sqrt(Properties.X ^ 2 + Properties.Y ^ 2)
			end

			if key == "Unit" then
				local Length = math.sqrt(Properties.X ^ 2 + Properties.Y ^ 2)

				if Length == 0 then
					return Vector2.new(0, 0)
				end

				return Vector2.new(Properties.X / Length, Properties.Y / Length)
			end

			return Properties[key]
		end,
		__newindex = function(_, key, value)
			Properties[key] = value
		end,
		__pairs = function()
			return next, Properties, nil
		end,
		__add = function(A, B)
			return Vector2.new(A.X + B.X, A.Y + B.Y)
		end,
		__sub = function(A, B)
			return Vector2.new(A.X - B.X, A.Y - B.Y)
		end,
		__mul = function(A, B)
			if type(B) == "number" then
				return Vector2.new(A.X * B, A.Y * B)
			end
			return Vector2.new(A.X * B.X, A.Y * B.Y)
		end,
		__div = function(A, B)
			if type(B) == "number" then
				return Vector2.new(A.X / B, A.Y / B)
			end
			return Vector2.new(A.X / B.X, A.Y / B.Y)
		end,
		__unm = function(A)
			return Vector2.new(-A.X, -A.Y)
		end,
		__eq = function(A, B)
			return A.X == B.X and A.Y == B.Y
		end,
		__tostring = function(A)
			return string.format("%g, %g", A.X, A.Y)
		end,
	})

	function Proxy:Abs()
		return Vector2.new(math.abs(Properties.X), math.abs(Properties.Y))
	end

	function Proxy:Ceil()
		return Vector2.new(math.ceil(Properties.X), math.ceil(Properties.Y))
	end

	function Proxy:Floor()
		return Vector2.new(math.floor(Properties.X), math.floor(Properties.Y))
	end

	function Proxy:Sign()
		return Vector2.new(Sign(Properties.X), Sign(Properties.Y))
	end

	function Proxy:Min(vector2)
		return Vector2.new(math.min(Properties.X, vector2.X), math.min(Properties.Y, vector2.Y))
	end

	function Proxy:Max(vector2)
		return Vector2.new(math.max(Properties.X, vector2.X), math.max(Properties.Y, vector2.Y))
	end

	function Proxy:Angle(Other, IsSigned)
		local Magnitude = Properties.Magnitude * Other.Magnitude

		if Magnitude == 0 then
			return 0
		end

		local Dot = Proxy:Dot(Other)

		if IsSigned then
			local Cross = Properties.X * Other.Y - Properties.Y * Other.X
			return math.atan2(Cross, Dot)
		end

		local Cosine = Dot / Magnitude
		Cosine = math.max(-1, math.min(1, Cosine))
		return math.acos(Cosine)
	end

	function Proxy:Dot(Other)
		return Properties.X * Other.X + Properties.Y * Other.Y
	end

	function Proxy:Lerp(Goal, Alpha)
		return Vector2.new(
			Properties.X + (Goal.X - Properties.X) * Alpha,
			Properties.Y + (Goal.Y - Properties.Y) * Alpha
		)
	end

	return Proxy
end

return Vector2
