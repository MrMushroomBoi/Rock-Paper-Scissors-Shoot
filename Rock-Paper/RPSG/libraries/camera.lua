local Camera = {
   x = 0,
   y = 0,
   scale = 1,
}

function Camera:apply()
   love.graphics.push()
   love.graphics.scale(self.scale,self.scale)
   love.graphics.translate(-self.x, -self.y)
end

function Camera:clear()
   love.graphics.pop()
end

function Camera:setPosition(x, y)
   self.x = x - love.graphics.getWidth() / 2 / self.scale
   self.y = y
   local RS = self.x + love.graphics.getWidth() / 2
end

return Camera