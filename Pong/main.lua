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
    largeFont = love.graphics.newFont('font.ttf', 16)
    scoreFont = love.graphics.newFont('font.ttf', 32)
    --set this for small obejct
    love.graphics.setFont(smallFont)

    --sound table
    sounds = {
        ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static')
    }


    -- initialize our virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
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

--fn to resizable screen
function love.resize (w , h)
  push:resize(w,h)
end

-- update function
function love.update(dt)
  if gameState == 'serve' then
    ball.dy = math.random(-50,50)
    if servingPlayer == 1 then
      ball.dx = math.random(140, 200)
    else
      ball.dx = -math.random(140, 200)
    end

  elseif gameState== 'play' then
    --detect the ball collision with paddles
    if ball:collides(player1) then
      ball.dx = -ball.dx * 1.05  --invert the diectn
      ball.x = player1.x + 5     --bouces over the right edge of paddleleft

        -- changes velocity going in the same direction
        if ball.dy < 0 then
            ball.dy = -math.random(10, 150)
        else
            ball.dy = math.random(10, 150)
        end

        sounds['paddle_hit']:play()
    end

    if ball:collides(player2) then
      ball.dx = -ball.dx * 1.05  --invert the diectn
      ball.x = player2.x - 4     --bouces over the leftt edge of paddleright

        -- changes velocity going in the same direction
        if ball.dy < 0 then
            ball.dy = -math.random(10, 150)
        else
            ball.dy = math.random(10, 150)
        end

        sounds['paddle_hit']:play()
    end

    -- detect upper and lower screen boundary collision and reverse if collided
    if ball.y <= 0 then
        ball.y = 0
        ball.dy = -ball.dy
        sounds['wall_hit']:play()
    end

    -- -4 to account for the ball's size
    if ball.y >= VIRTUAL_HEIGHT - 4 then
        ball.y = VIRTUAL_HEIGHT - 4
        ball.dy = -ball.dy
        sounds['wall_hit']:play()
    end


    --when ball hits left boundary of screen
    if ball.x < 0 then
      servingPlayer = 1
      player2Score = player2Score + 1
      sounds['score']:play()

      --victory update for player2
      if player2Score == 5 then
          winningPlayer = 2
          gameState = 'done'
      else
          gameState = 'serve'
          ball:reset()
      end
    end

  --when ball hits right boundary of screen
    if ball.x > VIRTUAL_WIDTH then
      servingPlayer = 2
      player1Score = player1Score + 1
      sounds['score']:play()

      --victory updaet for player1
      if player1Score == 5 then
          winningPlayer = 1
          gameState = 'done'
      else
          gameState = 'serve'
          ball:reset()
      end
    end
  end

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
    love.graphics.clear(255,255, 0, 0)

    --functn to display scoreFont
    displayScore()
    love.graphics.setFont(smallFont)

    if gameState == 'start' then
        love.graphics.printf('Welcome Boi !', 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to begin boi!', 0, 20, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'serve' then
        love.graphics.setFont(smallFont)
        love.graphics.printf('Player ' .. tostring(servingPlayer) .. "'s serve!", 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to serve boi!', 0, 20, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'play' then
        -- do nothing only play
    elseif gameState == 'done' then
      -- UI messages
      love.graphics.setFont(largeFont)
      love.graphics.printf('Player ' .. tostring(winningPlayer) .. ' wins!',0, 10, VIRTUAL_WIDTH, 'center')
      love.graphics.setFont(smallFont)
      love.graphics.printf('Press Enter to restart!', 0, 30, VIRTUAL_WIDTH, 'center')

    end



    -- render paddles, now using their class's render method
    player1:render()
    player2:render()

    -- render ball using its class's render method
    ball:render()

    -- new function just to demonstrate my name
    displayname()

    -- end rendering at virtual resolution
    push:apply('end')

end

function displayname()
    -- simple FPS display across all states
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print('By:Mohit Maroliya')
end
-- displaying score
function displayScore()
    -- draw score on the left and right center of the screen
    -- need to switch font to draw before actually printing
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50,
        VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30,
        VIRTUAL_HEIGHT / 3)
end

-- closing function using backspace (Can use Escape also)
function love.keypressed(key)
    if key == 'backspace' or key == 'escape' then
        -- function to terminate application
        love.event.quit()

        --press enter during the start state of the game, we'll go into play mode
    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'serve'
        elseif gameState == 'serve' then
            gameState = 'play'
        elseif gameState == 'done' then
            gameState = 'serve'
            -- ball's new reset method
            ball:reset()
            player1Score = 0
            player2Score = 0

            --winnign condtn
            if winningPlayer == 1 then
              servingPlayer = 2
            else
              servingPlayer = 1
            end
        end
    end
end --functn end
