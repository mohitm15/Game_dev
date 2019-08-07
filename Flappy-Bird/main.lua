--[[
    Game2
    Flappy Bird Remake
]]

push = require 'push'

Class = require 'class'

require 'bird'
require 'Pipe'
require 'PipePair'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

-- background image and starting scroll location (X axis)
local background = love.graphics.newImage('images/background.png')
local backgroundScroll = 0

-- ground image and starting scroll location (X axis)
local ground = love.graphics.newImage('images/ground.png')
local groundScroll = 0

--speeds
local BG_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED =60

-- point at which we should loop our background back to X 0
local BG_LOOPING_POINT = 413

-- point at which we should loop our ground back to X 0
local GROUND_LOOPING_POINT = 514

--creating bird object
local bird = Bird()

--table of spawning PipePair
local pipePairs = {}

--timer for spawning pipes
local spawnTimer = 0

-- initialize our last recorded Y value for a gap placement to base other gaps off of
local lastY = -PIPE_HEIGHT + math.random(80) + 20

function love.load()
    -- initialize our nearest-neighbor filter
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- title
    love.window.setTitle('Fifty Bird')

    -- initialize our virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })
-- initialize the input table
    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)
  --parallex of speed looping back to 0 after the looping point
  backgroundScroll = (backgroundScroll + BG_SCROLL_SPEED * dt) % BG_LOOPING_POINT
  groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % GROUND_LOOPING_POINT

  spawnTimer = spawnTimer + dt

  -- spawn a new PipePair if the timer is past 2 seconds
  if spawnTimer > 2 then
      -- modify the last Y coordinate we placed so pipe gaps aren't too far apart
      -- gap: 10px from top to 90 px from bottom
      local y = math.max(-PIPE_HEIGHT + 10,
          math.min(lastY + math.random(-20, 20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
      lastY = y

      table.insert(pipePairs, PipePair(y))
      spawnTimer = 0
  end

  bird:update(dt)

  -- for every pipe in the scene...
  for k, pair in pairs(pipePairs) do
      pair:update(dt)
  end


  for k, pair in pairs(pipePairs) do
      if pair.remove then
          table.remove(pipePairs, k)
      end
  end

  --reset table of input
  love.keyboard.keysPressed = {}
end


function love.draw()
    push:start()

    -- draw the background
    love.graphics.draw(background, -backgroundScroll, 0)

    -- render all the pipe pairs in our scene
    for k, pair in pairs(pipePairs) do
        pair:render()
    end

    -- draw the ground on top of the background, toward the bottom of the screen
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

    bird:render()

    push:finish()
end


function love.keypressed(key)
  -- add to the table of keys
  love.keyboard.keysPressed[key]= true

    if key == 'escape' then
        love.event.quit()
    end
end
--fn used to check our global input table for keys we activated during
    --this frame, looked up by their string value.
function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end
