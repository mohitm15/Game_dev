--[[
    Pong Game Development
]]
push = require 'push'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200

--  start the Game
function love.load()
    -- use nearest-neighbor filtering on upscaling and downscaling to prevent blurring of text
    love.graphics.setDefaultFilter('nearest', 'nearest')

    --font
    smallFont = love.graphics.newFont('font.ttf', 8)
    scoreFont = love.graphics.newFont('font.ttf', 32)
    --set this for small obejct
    love.graphics.setFont(smallFont)

    -- initialize our virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })

    -- initialize score variables
    player1Score = 0
    player2Score = 0

    -- paddle positions on the Y axis
    player1Y = 30
    player2Y = VIRTUAL_HEIGHT - 50


end

-- update function
function love.update(dt)
  -- body...
  --p1 scrolling
  if love.keyboard.isDown('w') then
    player1Y =player1Y + -PADDLE_SPEED*dt  --move up
  elseif love.keyboard.isDown('s') then
    player1Y = player1Y + PADDLE_SPEED*dt  --move down
  end

  --p2 scrolling
  if love.keyboard.isDown('up') then
    player2Y =player2Y + -PADDLE_SPEED*dt --move up
  elseif love.keyboard.isDown('down') then
    player2Y = player2Y + PADDLE_SPEED*dt  --move down
  end

end

-- draw function
function love.draw()
    -- begin rendering at virtual resolution
    push:apply('start')

    -- to clear the scrren with a color
    --love.graphics.clear(40, 45, 52, 255)
    love.graphics.setFont(smallFont)
    love.graphics.printf('Hello To The Pong World!', 0, 20, VIRTUAL_WIDTH, 'center')

    --draw score with larger FOnt
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)
    --first paddle rectangle(left side)
    love.graphics.rectangle('fill', 10, player1Y, 5, 20)

    --second paddle (right side)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, player2Y, 5, 20)

    --ball (center)    
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

    -- end rendering at virtual resolution
    push:apply('end')

end

-- closing function using backspace (Can use Escape also)
function love.keypressed(key)
    if key == 'backspace' then
        -- function to terminate application
        love.event.quit()
    end
end
