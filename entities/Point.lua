local Point = Class {
    init = function(self, x, y)
        self.position = Vector(x, y)
    end
}

function Point:draw(coordinateSystem)
    local ux, uy = coordinateSystem:getPoint(self.position.x, self.position.y)
    love.graphics.circle("fill", ux, uy, 3)
    love.graphics.print("(" .. self.position.x .. ", " .. self.position.y .. ")", ux + 5, uy - 5)
end

return Point
