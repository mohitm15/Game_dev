--[[
    Pong Game Development
]]
push = require 'push'

-- class libray
Class = require 'class'

-- inherting the classes
require 'Paddle'
require 'Ball'


WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200

--  start the Game
function love.load()
    -- use nearest-neighbor filtering on upscaling and downscaling to prevent blurring of text
    love.graphics.setDefaultFilter('nearest', 'nearest')

    --set title
    love.window.setTitle('Pong game by Mohit Maroliya')

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
    player1Score = 0
    player2Score = 0

    -- paddle positions on the Y axis
    player1 = Paddle(10,30,5,20)
    player2 = Paddle(VIRTUAL_WIDTH - 10 ,VIRTUAL_HEIGHT - 30,5,20)

    -- initial ball position
    ball = Ball(VIRTUAL_WIDTH / 2 - 2 , VIRTUAL_HEIGHT / 2 - 2 , 4 ,4 )

    --defining state of the game
    gameState  = 'start'
end

-- update function
function love.update(dt)
  -- body...
  --p1 scrolling
  if love.keyboard.isDown('w') then
    player1.dy = -PADDLE_SPEED  --move up
  elseif love.keyboard.isDown('s') then
    player1.dy = PADDLE_SPEED   --move down
  else
    player1.dy = 0
  end

  --p2 scrolling
  if love.keyboard.isDown('up') then
    player2.dy = -PADDLE_SPEED --move up
  elseif love.keyboard.isDown('down') then
    player2.dy = PADDLE_SPEED --move down
  else
    player2.dy = 0
  end

  --update the speed of the ball
  if gameState == 'play' then
    ball:update(dt)
  end

  player1:update(dt)
  player2:update(dt)
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

    -- render paddles, now using their class's render method
    player1:render()
    player2:render()

    -- render ball using its class's render method
    ball:render()

    -- new function just to demonstrate how to see FPS in LÖVE2D
    displayFPS()

    -- end rendering at virtual resolution
    push:apply('end')

end

--Renders the current FPS.
function displayFPS()
    -- simple FPS display across all states
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end

-- closing function using backspace (Can use Escape also)
function love.keypressed(key)
    if key == 'backspace' or key == 'escape' then
        -- function to terminate application
        love.event.quit()

        --press enter during the start state of the game, we'll go into play mode
    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'play'
        else
            gameState = 'start'

            -- ball's new reset method
            ball:reset()
        end
    end
end
