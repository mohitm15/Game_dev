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

    --use cuurent time as parameter for random function
    math.randomseed(os.time())

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
    --player1Score = 0
    --player2Score = 0

    -- paddle positions on the Y axis
    player1Y = 30
    player2Y = VIRTUAL_HEIGHT - 50

    -- initial ball positions
    ballX = VIRTUAL_WIDTH / 2 - 2
    ballY = VIRTUAL_HEIGHT / 2 - 2

    --ball velocities
    ballDX = math.random(2) == 1 and 100 or -100 --ternary operator
    ballDY = math.random(-50, 50)

    --defining state of the game
    gameState  = 'start'
end

-- update function
function love.update(dt)
  -- body...
  --p1 scrolling
  if love.keyboard.isDown('w') then
    player1Y = math.max(0, player1Y + -PADDLE_SPEED*dt)  --move up
  elseif love.keyboard.isDown('s') then
    player1Y = math.min(VIRTUAL_HEIGHT-20 ,player1Y + PADDLE_SPEED*dt)  --move down
  end

  --p2 scrolling
  if love.keyboard.isDown('up') then
    player2Y = math.max(0, player2Y + -PADDLE_SPEED*dt) --move up
  elseif love.keyboard.isDown('down') then
    player2Y = math.min(VIRTUAL_HEIGHT-20 ,player2Y + PADDLE_SPEED*dt) --move down
  end

  --update the speed of the ball
  if gameState == 'play' then
    ballX = ballX + ballDX * dt
    ballY = ballY + ballDY * dt
  end

end

-- draw function
function love.draw()
    -- begin rendering at virtual resolution
    push:apply('start')

    -- to clear the scrren with a color
    --love.graphics.clear(40, 45, 52, 255)
    love.graphics.setFont(smallFont)
    if gameState == 'start' then
        love.graphics.printf('Welcome Boi !', 0, 20, VIRTUAL_WIDTH, 'center')
    else
        love.graphics.printf('Now Play !', 0, 20, VIRTUAL_WIDTH, 'center')
    end

    --draw score with larger FOnt
    --love.graphics.setFont(scoreFont)
    --love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
    --love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)

    --first paddle rectangle(left side)
    love.graphics.rectangle('fill', 10, player1Y, 5, 20)

    --second paddle (right side)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, player2Y, 5, 20)

    --ball (center)
    love.graphics.rectangle('fill', ballX, ballY, 4, 4)

    -- end rendering at virtual resolution
    push:apply('end')

end

-- closing function using backspace (Can use Escape also)
function love.keypressed(key)
    if key == 'backspace' then
        -- function to terminate application
        love.event.quit()

        --press enter during the start state of the game, we'll go into play mode
    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'play'
        else
            gameState = 'start'

            ballX = VIRTUAL_WIDTH / 2 - 2
            ballY = VIRTUAL_HEIGHT / 2 - 2

            -- given ball's x and y velocity a random starting value
            ballDX = math.random(2) == 1 and 100 or -100
            ballDY = math.random(-50, 50) * 1.5
        end
    end
end
