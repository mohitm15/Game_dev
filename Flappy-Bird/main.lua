--[[
    Game2
    Flappy Bird Remake
]]

push = require 'push'

Class = require 'class'

require 'bird'
require 'Pipe'

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

--creating bird object
local bird = Bird()

--table of spawning Pipes
local pipes = {}

--timer for spawning pipes
local spawnTimer = 0

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
  groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH

  spawnTimer = spawnTimer + dt

  -- spawn a new Pipe if the timer is past 2 seconds
  if spawnTimer > 2 then
      table.insert(pipes, Pipe())
      print('Added new pipe!')
      spawnTimer = 0
  end

  bird:update(dt)

  -- for every pipe in the scene...
  for k, pipe in pairs(pipes) do
      pipe:update(dt)

      -- if pipe is no longer visible past left edge, remove it from scene
      if pipe.x < -pipe.width then
          table.remove(pipes, k)
      end
  end

  --reset table of input
  love.keyboard.keysPressed = {}
end


function love.draw()
    push:start()

    -- draw the background
    love.graphics.draw(background, -backgroundScroll, 0)

    -- render all the pipes in our scene
    for k, pipe in pairs(pipes) do
        pipe:render()
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