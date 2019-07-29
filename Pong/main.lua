--[[
    Pong Game Development
]]
push = require 'push'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

--  start the Game
function love.load()
    -- use nearest-neighbor filtering on upscaling and downscaling to prevent blurring of text
    love.graphics.setDefaultFilter('nearest', 'nearest')

    --font
    smallFont = love.graphics.newFont('font.ttf', 8)
    --set this for small obejct
    love.graphics.setFont(smallFont)

    -- initialize our virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })
end

function love.draw()
    -- begin rendering at virtual resolution
    push:apply('start')

    -- to clear the scrren with a color
    --love.graphics.clear(40, 45, 52, 255)

    love.graphics.printf('Hello To The Pong World!', 0, 20, VIRTUAL_WIDTH, 'center')

    --first paddle rectangle(left side)
    love.graphics.rectangle('fill', 10, 30, 5, 20)

    --second paddle (right side)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 50, 5, 20)

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
