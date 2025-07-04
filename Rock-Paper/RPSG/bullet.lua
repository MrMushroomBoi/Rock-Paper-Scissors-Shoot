Bullet = {}
function CreateBullet(x,y,vx,vy, bulletType, owner)
    local bullet = {

    x = x or 0,
    y = y or 0,
    vx = vx or 0,
    vy = vy or 0,

    timer = 2,
    remove = false,
    spawnProtection = 0.2,

    bulletType = bulletType,
    owner = owner or "player", -- Default owner is "player"
    
    rock = love.graphics.newImage("sprites/Rock.png"),
    scissors = love.graphics.newImage("sprites/Scissors.png"),
    paper = love.graphics.newImage("sprites/Paper.png"),
    sprite = nil --set in changeBulletSprite()


}    

function bullet:destroy()
    if self.body and self.body:isDestroyed() == false then
        self.body:destroy()
    end
end

function bullet:changeBulletSprite(bulletType)
    if bulletType == "rock" then
        self.sprite = self.rock
        
    elseif bulletType == "scissors" then
        self.sprite = self.scissors
      
    elseif bulletType == "paper" then
        self.sprite = self.paper

    else
        self.sprite = self.rock -- Default sprite if no key is pressed

    end
end

-- Physics
    bullet.body = love.physics.newBody(World, bullet.x, bullet.y, "dynamic")
    bullet.shape = love.physics.newCircleShape(8) 
    bullet.fixture = love.physics.newFixture(bullet.body, bullet.shape)
    bullet.body:setBullet(true) -- for fast-moving objects
    bullet.body:setLinearVelocity(bullet.vx, bullet.vy)
    bullet.fixture:setUserData(bullet) 
    bullet.fixture:setMask(1, 2, 3, 4, 5, 6, 7, 8) -- ignore all categories initially
    bullet.fixture:setUserData(bullet)
    bullet.fixture:setRestitution(0)
    bullet.fixture:setSensor(true)


function bullet:update(dt)
    bullet.x = bullet.x + bullet.vx * dt
    bullet.y = bullet.y + bullet.vy * dt
    self.x, self.y = self.body:getPosition()

    bullet.timer = bullet.timer - dt

      if self.spawnProtection > 0 then
        self.spawnProtection = self.spawnProtection - dt
        if self.spawnProtection <= 0 then
            self.fixture:setMask()
        end
    end

    if bullet.timer <= 0 then
        bullet.remove = true
    end
    

    bullet:changeBulletSprite(bulletType)
end

function bullet:draw()
    love.graphics.draw(self.sprite, self.x, self.y, 0, 1, 1, self.sprite:getWidth()/2, self.sprite:getHeight()/2)
end
    
    bullet:changeBulletSprite()

    return bullet
end

