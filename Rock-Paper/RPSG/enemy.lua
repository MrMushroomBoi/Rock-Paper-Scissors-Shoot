function CreateEnemy(x, y)
    local enemy = {}

    enemy.x = x
    enemy.y = y
    enemy.vx = 0
    enemy.vy = 0
    enemy.sprite = love.graphics.newImage("sprites/Enemy.png")
    enemy.width = enemy.sprite:getWidth()
    enemy.height = enemy.sprite:getHeight()

    enemy.xVel = 0
    enemy.yVel = 0
    enemy.maxSpeed = 200
    enemy.acceleration = 4000
    enemy.friction = 3500
    enemy.gravity = 1500
    enemy.jumpAmount = -500
    enemy.grounded = false
    enemy.remove = false

    enemy.physics = {}
    enemy.physics.body = love.physics.newBody(World, enemy.x, enemy.y, "dynamic")
    enemy.physics.body:setFixedRotation(true)
    enemy.physics.shape = love.physics.newRectangleShape(enemy.width, enemy.height)
    enemy.physics.fixture = love.physics.newFixture(enemy.physics.body, enemy.physics.shape)
    enemy.physics.fixture:setUserData(enemy)

    function enemy:update(dt)
        self:syncPhysics()
        self:move(dt)
        self:applyGravity(dt)

        self.shootTimer = (self.shootTimer or 0) - dt
        if self.shootTimer <= 0 then
            local types = {"rock", "paper", "scissors"}
            local randomType = types[math.random(#types)]
            self:shoot(Player.x, Player.y, randomType)
            self.shootTimer = 2
        end
    end

    function enemy:applyGravity(dt)
        if not self.grounded then
            self.yVel = self.yVel + self.gravity * dt
        end
    end

    function enemy:move(dt)
        -- Your movement logic here
    end

    function enemy:applyFriction(dt)
        if self.xVel > 0 then
            if self.xVel - self.friction * dt > 0 then
                self.xVel = self.xVel - self.friction * dt
            else
                self.xVel = 0
            end
        elseif self.xVel < 0 then
            if self.xVel + self.friction * dt < 0 then
                self.xVel = self.xVel + self.friction * dt
            else
                self.xVel = 0
            end
        end
    end

    function enemy:syncPhysics()
        self.x, self.y = self.physics.body:getPosition()
        self.physics.body:setLinearVelocity(self.xVel, self.yVel)
    end

    function enemy:beginContact(a, b, collision)
        if self.grounded == true then return end
        local nx, ny = collision:getNormal()
        if a == self.physics.fixture then
            if ny > 0 then
                self:land(collision)
            end
        elseif b == self.physics.fixture then
            if ny < 0 then
                self:land(collision)
            end
        end
    end

    function enemy:endContact(a, b, collision)
        if a == self.physics.fixture or b == self.physics.fixture then
            if self.currentGroundCollision == collision then
                self.grounded = false
            end
        end
    end

    function enemy:land(collision)
        self.currentGroundCollision = collision
        self.yVel = 0
        self.grounded = true
    end

    function enemy:shoot(targetX, targetY, bulletType, owner)
        local angle = math.atan2(targetY - self.y, targetX - self.x)
        local offset = self.width / 2 + 10
        local spawnX = self.x + math.cos(angle) * offset
        local spawnY = self.y + math.sin(angle) * offset
        table.insert(listOfBullets, CreateBullet(spawnX, spawnY, math.cos(angle) * 256, math.sin(angle) * 256, bulletType or "rock", "enemy"))
    end

    function enemy:draw()
        love.graphics.draw(self.sprite, self.x, self.y, 0, 1, 1, self.width / 2, self.height / 2)
    end

    return enemy
end