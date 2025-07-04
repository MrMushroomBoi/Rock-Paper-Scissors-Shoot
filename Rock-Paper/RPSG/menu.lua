Menu = {}
subtext = {}
function Menu:load()
    Menu.sprite = love.graphics.newImage("sprites/Title.png") --Texture of the title
    Menu.x, Menu.y =100, 200 --Positioning of the title
    --Window opens->Loads Menu Screen->Check for key pressed->Load Playscreen
    subtext.sprite = love.graphics.newImage("sprites/subtext.png")
    subtext.x, subtext.y = 600, 350
end

function Menu:update(dt)
    


end

function Menu:draw()
    love.graphics.draw(Menu.sprite, Menu.x, Menu.y)
    love.graphics.draw(subtext.sprite, subtext.x, subtext.y)

end

