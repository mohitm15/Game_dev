--[[
    Bird Class
]]

Bird = Class{}

local GRAVITY =20

function Bird:init()
    -- load bird image from disk and assign its width and height
    self.image = love.graphics.newImage('images/bird.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    -- position bird in the middle of the screen
    self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)

    -- Y velocity; gravity
    self.dy = 0
end

-- makes downward effect on bird
function Bird:update(dt)
  self.dy = self.dy + dt * GRAVITY

  self.y = self.y +self.dy
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end
