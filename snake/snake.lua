require "data"
require "vec2"

local snake = {
    body = {},
    direction = Vec2.new(0),
    head = Vec2.new(0),
    is_dead = false,
}

function snake:init()
    self.head = Vec2.new(math.floor(ROWS / 2), math.floor(COLS / 2))
    table.insert(self.body, self.head)
end

function snake:move()
    for i = #self.body, 2, -1 do
        self.body[i].x = self.body[i - 1].x
        self.body[i].y = self.body[i - 1].y
    end

    self.head.x = self.head.x + self.direction.x
    self.head.y = self.head.y + self.direction.y

    if self.head.x < 0 then self.head.x = ROWS - 1 end
    if self.head.y < 0 then self.head.y = COLS - 1 end
    if self.head.x >= ROWS then self.head.x = 0 end
    if self.head.y >= COLS then self.head.y = 0 end
end

function snake:draw()
    for _, part in ipairs(self.body) do
        if part.x ~= nil then
            love.graphics.rectangle("fill", BORDER * UNIT + part.x * UNIT, BORDER * UNIT + part.y * UNIT, UNIT, UNIT, 2)
        end
    end
end

function snake:grow()
    table.insert(self.body, Vec2.new())
end

function snake:shrink()
    table.remove(self.body)
end

function snake:head_collides_with_body()
    for i = 2, #self.body do
        if self.body[i] == self.head then
            return true
        end
    end

    return false
end

function snake:die()
    self.is_dead = true
end

function snake:live()
    self.is_dead = false
end

function snake:stop()
    self.direction.x = 0
    self.direction.y = 0
end

function snake:to_up()
    self.direction.x = 0
    self.direction.y = -1
end

function snake:to_down()
    self.direction.x = 0
    self.direction.y = 1
end

function snake:to_left()
    self.direction.x = -1
    self.direction.y = 0
end

function snake:to_right()
    self.direction.x = 1
    self.direction.y = 0
end

function snake:has_only_head()
    return #self.body > 1
end

return snake