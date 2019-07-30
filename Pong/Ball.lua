--[[
   class foe ball object
]]

Ball = Class{}

function Ball:init(x,y,width,height)
  self.x = x
  self.y = y
  self.width = width
  self.height = height

  --ball velocities
  self.dx = math.random(2) == 1 and 250 or -250 --ternary operator
  self.dy = math.random(-300, 300)
end

function Ball:reset()
  -- initial ball positions
  self.x = VIRTUAL_WIDTH / 2 - 2
  self.y = VIRTUAL_HEIGHT / 2 - 2

  self.dx = math.random(2) == 1 and 100 or -100 --ternary operator
  self.dy = math.random(-50, 50)
end

function Ball:update(dt)
  -- body...
  self.x = self.x + self.dx * dt
  self.y = self.y + self.dy * dt
end

function Ball:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end
