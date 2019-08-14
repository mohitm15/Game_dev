CountdownState = Class{__includes = BaseState}

CD_TIME = 0.85

function CountdownState:init()
  self.count = 3
  self.timer = 0
end

function CountdownState:update(dt)
  self.timer = self.timer + dt

  if self.timer > CD_TIME then
    self.timer = self.timer % CD_TIME
    self.count = self.count -1

    if self.count == 0 then
      gStateMachine:change('play')
    end
  end
end

function CountdownState:render()
  love.graphics.setFont(hugeFont)
  love.graphics.printf(tostring(self.count), 0, 120, VIRTUAL_WIDTH, 'center')
end
