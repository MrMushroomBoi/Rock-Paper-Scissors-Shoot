
function love.load()
   
    require "menu"
    require "play_screen"
    require "player"
    Menu:load()
    local screen = 0
    
    
    Playscreen:load() 
    

end

function love.update(dt)
    if love.keyboard.isDown("space") then
        screen = 1 
        song:play()
    end
    if Player.health <= 0 then
        screen = 0 -- Switch to menu screen if player health is 0
        resetGame() -- Reset the game state
    end

    if screen == 1 then
        Playscreen:update(dt)
    else
        Menu:update(dt)
    end
end

function love.draw()
        if screen == 1 then
        Playscreen:draw()
    else 
         Menu:draw()
    end
end


function resetGame()
    -- Reset player stats
    Player.health = 3
    Player.x = 100 -- or your starting x
    Player.y = 100 -- or your starting y
    Player.yVel = 0
    Player.xVel = 0
    Player.grounded = false

    -- Clear bullets and enemies
    listOfBullets = {}
    Enemies = {}

    -- Reload the play screen (if needed)
    Playscreen:load()
end