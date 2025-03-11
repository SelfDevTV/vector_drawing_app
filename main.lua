Vector = require("libs.vector")
Inspect = require("libs.inspect")
Class = require("libs.class")

local coordinateSystem = require "systems.coordinateSystem"
local inputSystem = require "systems.inputSystem"

function love.load()
    love.window.setTitle("Vector Drawing App")
    -- coordinateSystem:addPoint(2, 2)
end

function love.update(dt)
    -- Update your logic here
    inputSystem:update(dt)
end

function love.keypressed(key)
    inputSystem:keypressed(key)
end

function love.draw()
    coordinateSystem:draw()
    inputSystem:draw()
end
