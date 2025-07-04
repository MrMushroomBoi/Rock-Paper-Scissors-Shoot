endGuy = {}

function endGuy:load(x,y)
    endGuy.sprite = love.graphics.newImage("maps/endGuy.png") -- Load the sprites
    endGuy.x = x
    endGuy.y = y

    endGuy.width = endGuy.sprite:getWidth()
    endGuy.height = endGuy.sprite:getHeight()


    endGuy.physics = {}
    endGuy.physics.body = love.physics.newBody(World, endGuy.x, endGuy.y, "dynamic")
    endGuy.physics.body:setFixedRotation(true)
    endGuy.physics.shape = love.physics.newRectangleShape(endGuy.width, endGuy.height)
    endGuy.physics.fixture = love.physics.newFixture(endGuy.physics.body, endGuy.physics.shape)
    endGuy.physics.fixture:setUserData(endGuy)
end

function endGuy:update(dt)
    
end

function endGuy:draw()
    love.graphics.draw(endGuy.sprite, endGuy.x, endGuy.y, 0, 1, 1, endGuy.sprite:getWidth()/2, endGuy.sprite:getHeight()/2)
end