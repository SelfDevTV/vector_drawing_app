local Vec = Class {
    init = function(self, startPoint, endPoint)
        self.startPoint = startPoint
        self.endPoint = endPoint
    end
}

function Vec:draw(coordinateSystem)
    local ux, uy = coordinateSystem:getPoint(self.startPoint.position.x, self.startPoint.position.y)
    local vx, vy = coordinateSystem:getPoint(self.endPoint.position.x, self.endPoint.position.y)
    love.graphics.line(ux, uy, vx, vy)
end

return Vec
