local coordinateSystem = require "systems.coordinateSystem"
function love.load()
    love.window.setTitle("Vector Drawing App")
end

function love.update(dt)
    -- Update your logic here
end

function love.draw()
    love.graphics.print("Welcome to Vector Drawing App!", 100, 100)
    coordinateSystem:draw()
end
