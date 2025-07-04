weapon = {}

function weapon:load()
    
end
function weapon:update(dt)

end
function weapon:draw()
    love.graphics.draw(Bullet.sprite, Bullet.x, Bullet.y, Bullet.rotation)
end
function weapon:changeState()
    if love.keyboard.isDown("1") then
        print("Weapon state changed")
        --change png and implement cyclical hierarchy (Rock beats scissors and paper beats rock etc)
    elseif love.keyboard.isDown("2") then
        print("Weapon state changed")
    elseif love.keyboard.isDown("3") then
        print("Weapon state changed")   
    end
end