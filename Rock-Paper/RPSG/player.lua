Player = {}

selectedBulletType = "rock"

function Player:load()
    Player.x = 100
    Player.y = 0
    Player.sprite = love.graphics.newImage("sprites/player.png")
    Player.hand = love.graphics.newImage("sprites/HandGunProto.png")
    Player.width = self.sprite:getWidth()
    Player.height = self.sprite:getHeight()
    Player.health = 3
    Player.xVel = 0
    Player.yVel = 0
    Player.maxSpeed = 200
    Player.acceleration = 4000
    Player.friction = 3500
    Player.gravity = 1500
    Player.jumpAmount = -500
    Player.grounded = false
    Player.physics = {}
    Player.physics.body = love.physics.newBody(World, Player.x, Player.y, "dynamic")
    Player.physics.body:setFixedRotation(true)
    Player.physics.shape = love.physics.newRectangleShape(Player.width, Player.height)
    Player.physics.fixture = love.physics.newFixture(Player.physics.body, Player.physics.shape)

    Player.physics.fixture:setUserData(Player)
end

function Player:update(dt)
    self:syncPhysics()
    self:move(dt)
    self:applyGravity(dt)
end

function Player:applyGravity(dt)
    if Player.grounded == false then
        Player.yVel = Player.yVel + Player.gravity * dt
    end
end

function Player:move(dt)
    if love.keyboard.isDown("d", "right") then
        if Player.xVel < Player.maxSpeed then
            if Player.xVel + Player.acceleration * dt < Player.maxSpeed then
                Player.xVel = Player.xVel + Player.acceleration * dt
            else    
                Player.xVel = Player.maxSpeed
            end
        end
    elseif love.keyboard.isDown("a", "left") then
      if Player.xVel > -Player.maxSpeed then
            if Player.xVel - Player.acceleration * dt > -Player.maxSpeed then
                Player.xVel = Player.xVel - Player.acceleration * dt
            else    
                Player.xVel = -Player.maxSpeed
            end
        end
    else 
        Player:applyFriction(dt)
    end
end

function Player:applyFriction(dt)
    if Player.xVel > 0 then
        if Player.xVel - Player.friction * dt > 0 then
            Player.xVel = Player.xVel - Player.friction * dt
        else
            Player.xVel = 0
        end
    elseif Player.xVel < 0 then
        if Player.xVel + Player.friction * dt < 0 then
            Player.xVel = Player.xVel + Player.friction * dt
        else
            Player.xVel = 0
        end
    end
end

function Player:syncPhysics()
    Player.x, Player.y = Player.physics.body:getPosition()
    Player.physics.body:setLinearVelocity(Player.xVel, Player.yVel)
end

function Player:beginContact(a, b, collision)
    if Player.grounded == true then return end
    local nx, ny = collision:getNormal()
    if a == Player.physics.fixture then
        if ny > 0 then
            Player:land(collision)
        end
    else if b == Player.physics.fixture then
            if ny < 0 then
                Player:land(collision)
            end
        end
    end
end

function Player:endContact(a, b, collision)
   if a == self.physics.fixture or b == self.physics.fixture then
      if self.currentGroundCollision == collision then
         self.grounded = false
      end
   end
end

function spawnEntities()
    for i, v in ipairs(map.layers.entity.objects) do
        if v.type == "enemy" then
            table.insert(Enemies, CreateEnemy(v.x + v.width / 2, v.y + v.height / 2))
        end
    end
end 
 
function Player:land(collision)
    Player.currentGroundCollision = collision
    Player.yVel = 0
    Player.grounded = true
end

function Player:jump(key)
    if key == "space" and Player.grounded then
        Player.yVel = Player.jumpAmount
        Player.grounded = false
    end
end

function Player:draw()
    love.graphics.draw(Player.sprite, Player.x, Player.y, 0, 1, 1, Player.width / 2, Player.height / 2)
    love.graphics.draw(Player.hand, Player.x + 8, Player.y + 8, 0, 1, 1, Player.hand:getWidth() / 2, Player.hand:getHeight() / 2)
end

function Player:shoot(key)
    --Get mouse position
    local mx, my = love.mouse.getPosition()
    --Convert to world coordinates
    local worldX = mx + Camera.x
    local worldY = my + Camera.y
    --Calculate angle and velocity
    local angle = math.atan2(worldY - self.y, worldX - self.x)
    local vx, vy = math.cos(angle) * 256, math.sin(angle) * 256


    
    table.insert(listOfBullets, CreateBullet(Player.x + 8, Player.y + 8, vx, vy, selectedBulletType, "player"))
    

end