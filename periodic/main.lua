require "data"

local Animation = {}
function Animation:init(o)
    o = o or {}
    o.current_frame = 1
    o.timer = 0
    setmetatable(o, { __index = self })
    return o
end

function Animation:update()
    if self.timer > self:get_current_sprite().duration then
        self.timer = 0
        self.current_frame = self.current_frame + 1
        if self.current_frame > #self.frames then
            self.current_frame = 0
        end
    end
end

function Animation:get_current_sprite()
    return self.frames[self.current_frame]
end

function Animation:draw(...)
    love.graphics.draw(self.sprite, self:get_current_sprite(), ...)
end

local animation_player_idle

function love.load()
    local spr_player = love.graphics.newImage("spr_player.png")
    animation_player_idle = Animation:init {
        sprite = spr_player,
        frames = {
            {
                quad = love.graphics.newQuad(0, 0, 8, 8, spr_player),
                duration = 5,
            },
            {
                quad = love.graphics.newQuad(0, 0, 8, 8, spr_player),
                duration = 5,
            }
        }
    }
end

local time_passed = 0
local time_to_pass = 75

function love.update(dt)
    time_passed = time_passed + 1 + dt
    if time_passed > time_to_pass then
        time_passed = 0
    else return end

    animation_player_idle:update()
end

function love.draw()
    animation_player_idle:draw(8, 8)
end
