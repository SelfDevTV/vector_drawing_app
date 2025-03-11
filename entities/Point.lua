local Point = Class {
    init = function(self, x, y)
        self.position = Vector(x, y)
        self.radius = 4
    end
}

function Point:draw(coordinateSystem)
    love.graphics.setColor(0, 0, 1)
    local ux, uy = coordinateSystem:getPointCoordinates(self.position.x, self.position.y)
    love.graphics.circle("fill", ux, uy, self.radius)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("(" .. self.position.x .. ", " .. self.position.y .. ")", ux + 5, uy - 5)
end

return Point
