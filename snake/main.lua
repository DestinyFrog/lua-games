require "data"

local snake_body = {}
local snake_direction = { x = 0, y = 0 }
local snake_head = {}
local is_dead = false
local fruit_position = {}

local function repos_fruit()
    local free_positions = {}
    for x = 1, COLS - 1 do
        for y = 1, ROWS - 1 do
            for _, part in ipairs(snake_body) do
                if part.x == x and part.y == y then
                    goto continue
                end
            end

            table.insert(free_positions, { x = x, y = y })
            ::continue::
        end
    end

    local chosen_position = free_positions[math.random(#free_positions)]
    fruit_position.x = chosen_position.x
    fruit_position.y = chosen_position.y
end

function love.load()
    snake_head = {
        x = math.floor(ROWS / 2),
        y = math.floor(COLS / 2),
    }
    table.insert(snake_body, snake_head)

    math.randomseed(os.time())
    repos_fruit()

    love.graphics.setBackgroundColor( 0, 0.7, 0 )
    love.graphics.setColor(0.3, 0.3, 0.3)
end

local time_passed = 0
local time_to_pass = 75

function love.update(dt)
    if love.keyboard.isDown("up", "w") then
        snake_direction.x = 0
        snake_direction.y = -1
    end

    if love.keyboard.isDown("down", "s") then
        snake_direction.x = 0
        snake_direction.y = 1
    end

    if love.keyboard.isDown("left", "a") then
        snake_direction.x = -1
        snake_direction.y = 0
    end

    if love.keyboard.isDown("right", "d") then
        snake_direction.x = 1
        snake_direction.y = 0
    end

    time_passed = time_passed + 1 + dt
    if time_passed > time_to_pass then
        time_passed = 0
    else return end

    if is_dead then
        if #snake_body > 1 then
            table.remove(snake_body)
        else
            snake_direction.x = 0
            snake_direction.y = 0
            is_dead = false
        end
        return
    end

    for i = #snake_body, 2, -1 do
        snake_body[i].x = snake_body[i - 1].x
        snake_body[i].y = snake_body[i - 1].y
    end

    snake_head.x = snake_head.x + snake_direction.x
    snake_head.y = snake_head.y + snake_direction.y

    if snake_head.x < 0 then snake_head.x = ROWS - 1 end
    if snake_head.y < 0 then snake_head.y = COLS - 1 end
    if snake_head.x >= ROWS then snake_head.x = 0 end
    if snake_head.y >= COLS then snake_head.y = 0 end

    for i = 2, #snake_body do
        if snake_body[i].x == snake_head.x and
           snake_body[i].y == snake_head.y then
            is_dead = true
            return
        end
    end

    if snake_head.x == fruit_position.x and
       snake_head.y == fruit_position.y
    then
        repos_fruit()

        table.insert(snake_body, { x = nil, y = nil })
    end
end

function love.draw()
    for x = 1, COLS + 2 do
        love.graphics.rectangle("fill", x * UNIT + 1, UNIT + 1, UNIT - 2, UNIT - 2, 2)
        love.graphics.rectangle("fill", x * UNIT + 1, ROWS * UNIT + UNIT * 2 + 1, UNIT - 2, UNIT - 2, 2)
    end

    for y = 2, ROWS + 2 do
        love.graphics.rectangle("fill", UNIT + 1, y * UNIT + 1, UNIT - 2, UNIT - 2, 2)
        love.graphics.rectangle("fill", (COLS + 2) * UNIT + 1, y * UNIT + 1, UNIT - 2, UNIT - 2, 2)
    end

    for _, part in ipairs(snake_body) do
        if part.x ~= nil then
            love.graphics.rectangle("fill", BORDER * UNIT + part.x * UNIT, BORDER * UNIT + part.y * UNIT, UNIT, UNIT, 2)
        end
    end

    love.graphics.rectangle("fill", BORDER * UNIT + fruit_position.x * UNIT + UNIT/3, BORDER * UNIT + fruit_position.y * UNIT, UNIT/3, UNIT/3)
    love.graphics.rectangle("fill", BORDER * UNIT + fruit_position.x * UNIT, BORDER * UNIT + fruit_position.y * UNIT + UNIT/3, UNIT/3, UNIT/3)
    love.graphics.rectangle("fill", BORDER * UNIT + (fruit_position.x + 1) * UNIT - UNIT/3, BORDER * UNIT + fruit_position.y * UNIT + UNIT/3, UNIT/3, UNIT/3)
    love.graphics.rectangle("fill", BORDER * UNIT + fruit_position.x * UNIT  + UNIT/3, BORDER * UNIT + (fruit_position.y + 1) * UNIT - UNIT/3, UNIT/3, UNIT/3)
end