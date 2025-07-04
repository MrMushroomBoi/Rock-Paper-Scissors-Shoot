Playscreen = {}
Enemies = {}

function Playscreen:load()
    sti = require"libraries/sti"
    map = sti("maps/RPSMap.lua", {"box2d"})
    World = love.physics.newWorld(0,0)
	World:setCallbacks(beginContact, endContact)
	map:box2d_init(World)
    map.layers.solid.visible = false
    map.layers.entity.visible = false
    MapWidth = map.layers.ground.width * 16
    --Camera
 
    Camera = require "libraries/camera"
    
    song = love.audio.newSource("Audio/RPSS Soundtrack.mp3", "stream")
    song:setLooping(true)
    song:setVolume(0.1)
    Playscreen.DeathByRock = love.audio.newSource("Audio/DeathByRock.mp3", "static")
    Playscreen.ShootPlane = love.audio.newSource("Audio/ShootPlane.wav", "static")
    Playscreen.ScissorsCollide = love.audio.newSource("Audio/ScissorsCollide.mp3", "static")
    -- Note that this code, as-is, will set the volume to 1.0, as per the last line, and that's how sound:play() will play it back.
    Playscreen.DeathByRock:setVolume(0.5) -- 50% volume
    Playscreen.ShootPlane:setVolume(0.5) -- 50% volume
    Playscreen.ScissorsCollide:setVolume(0.5) -- 50% volume
    --Bullets
    require "bullet"
    listOfBullets = {}
    require "UI"
    UserI:load()
    --Player
    require"Player"
    Player:load()

    --Enemies
    require"enemy"

    require"endGuy"
    endGuy:load(4000,450)

    spawnEntities()
end

function Playscreen:update(dt)
    World:update(dt)
    UserI:update(dt)
    Player:update(dt)
    endGuy:update(dt)

    -- Update all enemies and remove any that are flagged for removal
    for i = #Enemies, 1, -1 do
        local enemy = Enemies[i] -- not 'Enemies'
        enemy:update(dt)
        if enemy.remove then
            enemy.physics.body:destroy()
            table.remove(Enemies, i)
        end
    end

    Camera:setPosition(Player.x, 0)

    -- Update bullets and check for overlap with all enemies
    for i = 1, #listOfBullets do
        local bullet = listOfBullets[i]
        bullet:update(dt)

        for j = #Enemies, 1, -1 do
            local enemy = Enemies[j]
            if not enemy.remove and bullet.owner == "player" then
                local bx, by = bullet.body:getPosition()
                local ex, ey = enemy.physics.body:getPosition()
                local dist = ((bx - ex)^2 + (by - ey)^2)^0.5
                if dist < bullet.shape:getRadius() + math.max(enemy.width, enemy.height)/2 then
                    bullet.remove = true
                    enemy.remove = true
                end
            end
        end
    end

    -- Remove/destroy bullets that are marked for removal
    for i = #listOfBullets, 1, -1 do
        local bullet = listOfBullets[i]
        if bullet.remove then
            bullet:destroy()
            table.remove(listOfBullets, i)
        end
    end
end

function Playscreen:draw()
    map:draw(-Camera.x, -Camera.y, Camera.scale, Camera.scale)
    UserI:draw()
    Camera:apply()
        Player:draw()
        for i, enemy in ipairs(Enemies) do
            enemy:draw()
        end
        -- Draw bullets
        for i, v in ipairs(listOfBullets) do
            v:draw()
        end
        endGuy:draw()
        
    Camera:clear()
    love.graphics.setColor(1, 1, 1, 1) -- Reset color
end

function love.keypressed(key)
    if key == "1" then
        selectedBulletType = "rock"
        UserI.choice = UserI.rock   
    elseif key == "2" then
        selectedBulletType = "scissors"
        UserI.choice = UserI.scissors
    elseif key == "3" then
        selectedBulletType = "paper"
        UserI.choice = UserI.paper
    end

    Player:jump(key)
end

function love.mousepressed(x, y, button)
    if button == 1 then
        Player:shoot()
    end
end

function beginContact(a, b, collision)
    local ua = a:getUserData()
    local ub = b:getUserData()

    -- Don't process if either bullet is already marked for removal
    if (ua and ua.remove) or (ub and ub.remove) then return end

    -- Bullet vs Player logic
    if ua and ua.bulletType and ua.owner == "enemy" and ub == Player then
        ua.remove = true
        Player.health = Player.health - 1
    elseif ub and ub.bulletType and ub.owner == "enemy" and ua == Player then
        ub.remove = true
        Player.health = Player.health - 1
    end

        -- Player touches endGuy
    if (ua == Player and ub == endGuy) or (ub == Player and ua == endGuy) then
        resetGame()
        screen = 0 -- or whatever value returns to the menu
        return
    end

    -- Bullet vs Bullet logic
    if ua and ub and ua.bulletType and ub.bulletType then
        if ua.bulletType == "rock" and ub.bulletType == "scissors" then
            ub.remove = true
        elseif ua.bulletType == "scissors" and ub.bulletType == "rock" then
            ua.remove = true
        elseif ua.bulletType == "scissors" and ub.bulletType == "paper" then
            ub.remove = true
        elseif ua.bulletType == "paper" and ub.bulletType == "scissors" then
            ua.remove = true
        elseif ua.bulletType == "paper" and ub.bulletType == "rock" then
            ub.remove = true
        elseif ua.bulletType == "rock" and ub.bulletType == "paper" then
            ua.remove = true
        end
    elseif ua and ua.bulletType and ub == Enemies then
        ua.remove = true
        Enemies.remove = true
    elseif ub and ub.bulletType and ua == Enemies then
        ub.remove = true
        Enemies.remove = true
    elseif ua and ua.bulletType then 
        ua.remove = true
    elseif ub and ub.bulletType then
        ub.remove = true
    else
        Player:beginContact(a, b, collision)
        for i, enemy in ipairs(Enemies) do
        if enemy.beginContact then
            enemy:beginContact(a, b, collision)
        end
    end
    end
    -- Player-specific collision logic
    if ua and ua == Player.physics.fixture then
        if Player.beginContact then
            Player:beginContact(a, b, collision)
            Player.health = Player.health - 1
        end
    elseif ub and ub == Player.physics.fixture then
        if Player.beginContact then
            Player:beginContact(a, b, collision)
            Player.health = Player.health - 1
        end
    end
end

 
function endContact(a, b, collision)
    Player:endContact(a, b, collision)
    for i, enemy in ipairs(Enemies) do
        if enemy.endContact then
            enemy:endContact(a, b, collision)
        end
    end
end

function spawnEntities()
    for i, v in ipairs(map.layers.entity.objects) do
        if v.type == "enemy" then
            table.insert(Enemies, CreateEnemy(v.x + v.width / 2, v.y + v.height / 2))
        elseif v.type == "endGuy" then
            endGuy:load(v.x + v.width / 2, v.y + v.height / 2)
        end
    end
end