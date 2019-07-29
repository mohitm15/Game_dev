--[[
    Pong Game Development
]]
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720


function love.load()
    love.window.setMode(WINDOW_WIDTH,WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })
end

-- Heading of the game

function love.draw()
    love.graphics.printf(
        'Hello Pong!',
        0,
        WINDOW_HEIGHT /2 -6 ,
        WINDOW_WIDTH,
        'center'
    )
end