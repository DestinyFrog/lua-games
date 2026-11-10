
Vec2 = {}
Vec2.__index = Vec2

function Vec2.new(x, y)
    if y == nil then y = x end
    return setmetatable({x = x, y = y}, Vec2)
end

function Vec2.__eq(a, b)
    return a.x == b.x and a.y == b.y
end