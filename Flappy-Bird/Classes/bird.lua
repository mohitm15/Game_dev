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

function Bird:collides(pipe)
  --offset make so that some part of the bird gets leewayed for the user
  if (self.x + 2) + (self.width - 4) >= pipe.x and self.x + 2 <= pipe.x + PIPE_WIDTH then
    if (self.y + 2) + (self.height - 4) >= pipe.y and self.y + 2 <= pipe.y + PIPE_HEIGHT then
        return true
    end
  end

return false
end

-- makes downward effect on bird
function Bird:update(dt)
  self.dy = self.dy + dt * GRAVITY

-- add antigravity factor
  if love.keyboard.wasPressed('space') then
    self.dy= -4
    sounds['jump']:play()
  end

  self.y = self.y +self.dy
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end
