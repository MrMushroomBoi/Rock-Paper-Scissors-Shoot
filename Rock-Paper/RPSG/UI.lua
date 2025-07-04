UserI = {}
function UserI:load()
require "player" 
require "bullet"
UserI.x, UserI.y = 1, 1
UserI.sprite = love.graphics.newImage("sprites/FullHP.png")
UserI.sprite1 = love.graphics.newImage("sprites/FullHP.png")
UserI.sprite2 = love.graphics.newImage("sprites/HPM1.png")
UserI.sprite3 = love.graphics.newImage("sprites/HPM2.png")
UserI.sprite4 = love.graphics.newImage("sprites/HPNONE.png")
UserI.rock = love.graphics.newImage("sprites/rock.png")
UserI.scissors = love.graphics.newImage("sprites/scissors.png")
UserI.paper = love.graphics.newImage("sprites/paper.png")
UserI.choice = love.graphics.newImage("sprites/rock.png") -- Default choice icon



end

function UserI:update(dt)
UserI.TextureUpdate(dt)





end

function UserI:draw()
 
    love.graphics.draw(UserI.sprite, UserI.x, UserI.y, 0, 3, 3) -- Scale the UI sprite 3x
    love.graphics.draw(UserI.choice, UserI.x + 185, UserI.y, 0, 2, 2) -- Draw the selected bullet icon

end


function UserI:TextureUpdate(dt)
        if Player.health >= 3 then
            UserI.sprite = UserI.sprite1
        elseif Player.health == 2 then
            UserI.sprite = UserI.sprite2
        elseif Player.health == 1 then
            UserI.sprite = UserI.sprite3
        elseif Player.health <= 0 then
            UserI.sprite = UserI.sprite4
        end
    end

