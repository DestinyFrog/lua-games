require "data"
local snake = require "snake"
local fruit = require "fruit"

function love.load()
    math.randomseed(os.time())

    fruit:repos(snake)
    snake:init()

    love.graphics.setBackgroundColor( 0, 0.7, 0 )
    love.graphics.setColor(0.3, 0.3, 0.3)
end

local time_passed = 0
local time_to_pass = 75

function love.update(dt)
    if love.keyboard.isDown("up", "w") then snake:to_up() end
    if love.keyboard.isDown("down", "s") then snake:to_down() end
    if love.keyboard.isDown("left", "a") then snake:to_left() end
    if love.keyboard.isDown("right", "d") then snake:to_right() end

    time_passed = time_passed + 1 + dt
    if time_passed > time_to_pass then
        time_passed = 0
    else return end

    if snake.is_dead then
        if snake:has_only_head() then
            snake:shrink()
        else
            snake:stop()
            snake:live()
        end
        return
    end

    snake:move()

    if snake:head_collides_with_body() then
        return snake:die()
    end

    if snake.head == fruit.position then
        fruit:repos(snake)
        snake:grow()
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

    snake:draw()
    fruit:draw()
end
