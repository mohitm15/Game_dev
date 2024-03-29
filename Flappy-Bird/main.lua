--[[
    Game2
    Flappy Bird Remake
]]

push = require 'libraries/push'

Class = require 'libraries/class'

require 'Classes/bird'
require 'Classes/Pipe'
require 'Classes/PipePair'

--all the game states
require 'states/StateMachine'
require 'states/BaseState'
require 'states/PlayState'
require 'states/ScoreState'
require 'states/CountdownState'
require 'states/TitleScreenState'

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

--pause game when we collide
local scrolling = true

--creating bird object
local bird = Bird()

--table of spawning PipePair
--local pipePairs = {}

--timer for spawning pipes
--local spawnTimer = 0

-- initialize our last recorded Y value for a gap placement to base other gaps off of
--local lastY = -PIPE_HEIGHT + math.random(80) + 20

function love.load()
    -- initialize our nearest-neighbor filter
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- title
    love.window.setTitle('Fifty Bird')

    --some new fonts
    smallFont = love.graphics.newFont('fonts/font.ttf', 8)
    mediumFont = love.graphics.newFont('fonts/flappy.ttf', 14)
    flappyFont = love.graphics.newFont('fonts/flappy.ttf', 28)
    hugeFont = love.graphics.newFont('fonts/flappy.ttf', 56)
    love.graphics.setFont(flappyFont)

    -- initialize our table of sounds
    sounds = {
        ['jump'] = love.audio.newSource('sounds/jump.wav', 'static'),
        ['explosion'] = love.audio.newSource('sounds/explosion.wav', 'static'),
        ['hurt'] = love.audio.newSource('sounds/hurt.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['music'] = love.audio.newSource('sounds/marios_way.mp3', 'static')
      }

    -- kick off music
    sounds['music']:setLooping(true)
    sounds['music']:play()

    -- initialize our virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

-- initialize a tableof states
    gStateMachine = StateMachine{
      ['title'] = function() return TitleScreenState() end,
      ['play'] = function() return PlayState() end,
      ['score'] = function() return ScoreState() end,
      ['countdown'] = function() return CountdownState() end,
    }
    gStateMachine:change('title')

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

  --update just the StateMachine
  gStateMachine:update(dt)

  --reset table of input
  love.keyboard.keysPressed = {}
end


function love.draw()
    push:start()

    -- draw the background
    love.graphics.draw(background, -backgroundScroll, 0)

    gStateMachine:render()

    -- draw the ground on top of the background, toward the bottom of the screen
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

    push:finish()
end


function love.keypressed(key)
  -- add to the table of keys
  love.keyboard.keysPressed[key]= true

    if key == 'escape' or key == 'back'  then
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
