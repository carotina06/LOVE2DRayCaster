function love.load()
    duePi = math.pi * 2

    w = 600
    h = 600
    love.window.setMode(w*2,h)

    player = {}
    player.pos = {400,100}
    player.angle = duePi/4
    player.speed = 100
    player.angspeed = duePi/3
    player.mappos = {0,0}
    player.fov = duePi /6
    halfFov = player.fov/2

    nRays = 500
    maxDepth = 100
    deltaAng = player.fov / nRays

    map = {
        {1,1,1,1,1,1,1,1,},
        {1,_,_,_,1,_,1,1,},
        {1,_,_,_,1,_,1,1,},
        {1,_,_,_,_,_,_,1,},
        {1,_,1,1,1,_,1,1,},
        {1,_,1,_,_,_,_,1,},
        {1,_,1,_,_,_,_,1,},
        {1,1,1,1,1,1,1,1,},
    }
    map = {
        {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
        {1,_,_,_,_,_,_,_,1,_,_,_,_,_,_,1},
        {1,_,_,2,_,_,_,_,1,_,_,_,_,_,_,1},
        {1,_,_,_,_,_,_,1,1,_,_,_,_,_,_,1},
        {1,_,_,_,_,_,_,_,_,_,_,_,_,_,_,1},
        {1,_,_,_,_,_,_,_,_,_,_,_,_,_,_,1},
        {1,_,_,_,_,_,_,_,_,_,_,_,_,_,_,1},
        {1,_,_,_,_,_,_,_,_,_,_,_,_,_,_,1},
        {1,_,_,_,_,_,_,_,_,_,_,_,_,_,_,1},
        {1,1,1,1,1,1,1,1,_,_,_,_,_,_,_,1},
        {1,_,_,_,_,_,_,_,_,_,_,_,_,_,_,1},
        {1,_,_,_,_,_,_,_,_,_,_,_,_,_,_,1},
        {1,_,_,1,1,1,1,1,_,_,_,_,_,_,_,1},
        {1,_,_,1,_,_,_,_,_,_,_,_,_,_,_,1},
        {1,_,_,1,_,_,_,_,_,_,_,_,_,_,_,1},
        {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}
        
    }
    m = false
end

function checkAngle(angol)
    if angol<0 then
        return angol + duePi
    elseif angol>duePi then
        return angol - duePi
    else return angol
    end
end


function move(delta)
    local cos = math.cos(player.angle)
    local sin = math.sin(player.angle)
    
    if love.keyboard.isDown("w") then
        local ex = player.pos[1] + cos * player.speed * delta
        local uay = player.pos[2] + sin * player.speed * delta
        player.mappos[1] = math.floor(ex/w *#map) +1
        player.mappos[2] = math.floor(uay/h *#map) +1
        if map[player.mappos[2]][player.mappos[1]] == _ then
            player.pos[1] = ex
            player.pos[2] = uay
        end
    elseif love.keyboard.isDown("s") then
        local ex = player.pos[1] - cos * player.speed * delta
        local uay = player.pos[2] - sin * player.speed * delta
        player.mappos[1] = math.floor(ex/w *#map) +1
        player.mappos[2] = math.floor(uay/h *#map) +1
        if map[player.mappos[2]][player.mappos[1]] == _ then
            player.pos[1] = ex
            player.pos[2] = uay
        end
    end

    if love.keyboard.isDown("d") then
        cos = math.cos(player.angle+duePi/4)
        sin = math.sin(player.angle+duePi/4)
        local ex = player.pos[1] + cos * player.speed * delta
        local uay = player.pos[2] + sin * player.speed * delta
        player.mappos[1] = math.floor(ex/w *#map) +1
        player.mappos[2] = math.floor(uay/h *#map) +1
        if map[player.mappos[2]][player.mappos[1]] == _ then
            player.pos[1] = ex
            player.pos[2] = uay
        end
    elseif love.keyboard.isDown("a") then
        cos = math.cos(player.angle-duePi/4)
        sin = math.sin(player.angle-duePi/4)
        local ex = player.pos[1] + cos * player.speed * delta
        local uay = player.pos[2] + sin * player.speed * delta
        player.mappos[1] = math.floor(ex/w *#map) +1
        player.mappos[2] = math.floor(uay/h *#map) +1
        if map[player.mappos[2]][player.mappos[1]] == _ then
            player.pos[1] = ex
            player.pos[2] = uay
        end
    end

    if love.keyboard.isDown("right") then
        player.angle = player.angle + player.angspeed * delta
    elseif love.keyboard.isDown("left") then
        player.angle = player.angle - player.angspeed * delta
    end
    player.angle = checkAngle(player.angle)
end

function love.update(dt)
    move(dt)
    if love.keyboard.isDown("m") then
        if m then m=false else m=true end
    end
end

function love.draw()
    love.graphics.setColor(1,1,1)
    for i,fila in pairs(map) do
        for x,cuc in pairs(fila) do
            if cuc==1 then
                love.graphics.rectangle("line",(x-1)*w/#map + w,(i-1)*h/#map,w/#map,h/#map)
            end
        end
    end
    
    love.graphics.print(player.angle.."\n"..player.mappos[1].."\n"..player.mappos[2])
    love.graphics.circle("fill",player.pos[1]+w,player.pos[2],10)
    for ray = player.angle - halfFov, player.angle + halfFov, player.fov / nRays do
        local hitX, hitY, wallType = castRay(player.pos[1], player.pos[2], ray)
        
        if hitX and hitY then
            love.graphics.line(player.pos[1]+w, player.pos[2], hitX+w, hitY)
            local distance = math.sqrt((player.pos[1] - hitX)^2 + (player.pos[2] - hitY)^2)
            local correctedDistance = distance * math.cos(ray - player.angle)  -- Adjust for fish-eye effect

            local wallHeight = h / correctedDistance * maxDepth  -- Adjust wall height based on corrected distance

            -- Calculate the screen coordinates for the wall
            local screenX = (ray - (player.angle - halfFov)) / player.fov * w
            local wallTop = h / 2 - wallHeight / 2
            local wallBottom = h / 2 + wallHeight / 2

            -- Draw the wall
            if wallType==1 then
                love.graphics.setColor(0, wallHeight/h, 0)
            elseif wallType==2 then
                love.graphics.setColor(wallHeight/h, 0 , 0)
            end
            love.graphics.rectangle("fill", screenX, wallTop, w/nRays, wallHeight)
        end
    end
    --[[
    for i,fila in pairs(map) do
        for x,cuc in pairs(fila) do
            if cuc==1 then
                love.graphics.rectangle("line",(x-1)*w/#map,(i-1)*h/#map,w/#map,h/#map)
            end
        end
    end
    love.graphics.print(player.angle.."\n"..player.mappos[1].."\n"..player.mappos[2])
    love.graphics.circle("fill",player.pos[1],player.pos[2],10)
    ]]
    

    
end

function castRay(startX, startY, angle)
    local stepX = math.cos(angle)
    local stepY = math.sin(angle)
    
    local x = startX
    local y = startY

    while x >= 0 and x <= w and y >= 0 and y <= h do
        local mapX = math.floor(x / w * #map) + 1
        local mapY = math.floor(y / h * #map) + 1

        if map[mapY] and map[mapY][mapX] and map[mapY][mapX] ~= _ then
            return x, y, map[mapY][mapX]  -- Hit a wall
        end

        x = x + stepX
        y = y + stepY
    end

    return nil, nil, nil  -- No hit
end
