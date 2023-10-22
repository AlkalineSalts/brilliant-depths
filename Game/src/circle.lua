Circle = {}
function Circle.new(x, y, radius)
    local self = {}
	setmetatable(self, {__index = Circle})
    self.x = x
    self.y = y
    self.radius = radius
    return self
end

function Circle.pointInside(self, x, y)
    local value = math.sqrt(math.pow(self.x - x, 2) + math.pow(self.y - y, 2))
    return value <= self.radius
end
