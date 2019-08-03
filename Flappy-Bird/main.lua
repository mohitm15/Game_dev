--[[
    Game2
    Flappy Bird Remake
]]

push = require 'push'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

-- images
local background = love.graphics.newImage('images/background.png')
local ground = love.graphics.newImage('images/ground.png')

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
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.draw()
    push:start()

    -- draw the background
    love.graphics.draw(background, 0, 0)

    -- draw the ground on top of the background, toward the bottom of the screen
    love.graphics.draw(ground, 0, VIRTUAL_HEIGHT - 12)

    push:finish()
end
