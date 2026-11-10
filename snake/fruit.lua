require "data"
require "vec2"

local fruit = {
    position = Vec2.new(0),
}

function fruit:repos(snake)
    local free_positions = {}
    for x = 1, COLS - 1 do
        for y = 1, ROWS - 1 do
            for _, part in ipairs(snake.body) do
                if part.x == x and part.y == y then
                    goto continue
                end
            end

            table.insert(free_positions, { x = x, y = y })
            ::continue::
        end
    end

    local chosen_position = free_positions[math.random(#free_positions)]
    self.position.x = chosen_position.x
    self.position.y = chosen_position.y
end

function fruit:draw()
    love.graphics.rectangle("fill", BORDER * UNIT + self.position.x * UNIT + UNIT/3, BORDER * UNIT + self.position.y * UNIT, UNIT/3, UNIT/3)
    love.graphics.rectangle("fill", BORDER * UNIT + self.position.x * UNIT, BORDER * UNIT + self.position.y * UNIT + UNIT/3, UNIT/3, UNIT/3)
    love.graphics.rectangle("fill", BORDER * UNIT + (self.position.x + 1) * UNIT - UNIT/3, BORDER * UNIT + self.position.y * UNIT + UNIT/3, UNIT/3, UNIT/3)
    love.graphics.rectangle("fill", BORDER * UNIT + self.position.x * UNIT  + UNIT/3, BORDER * UNIT + (self.position.y + 1) * UNIT - UNIT/3, UNIT/3, UNIT/3)
end

return fruit