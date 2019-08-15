W = 1280
H = 720

VW = 432
VH = 243

PADDLE_SPEED = 200

push = require 'push'

function love.load()

    love.graphics.setDefaultFilter('nearest', 'nearest')

    smallFont = love.graphics.newFont('font.ttf', 8)
    scoreFont = love.graphics.newFont('font.ttf', 32)

    math.randomseed(os.time())

    love.graphics.setFont(smallFont)

    push:setupScreen(VW, VH, W, H, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })

    ballx =  VW/2 - 2
    bally = VH/2 - 2

    balldx = math.random(2) == 1 and 100 or -100
    balldy = math.random(-50, 50)

    p1score = 0
    p2score = 0

    p1y = 30
    p2y = VH - 50

    gamestate = 'start'
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == "return" then
        if gamestate == 'start' then
            gamestate = 'play'
        else
            gamestate = 'start'

            ballx =  VW/2 - 2
            bally = VH/2 - 2

            balldx = math.random(2) == 1 and 100 or -100
            balldy = math.random(-50, 50)
        end
    end
end

function love.update(dt)
    if love.keyboard.isDown('w') then
        p1y = math.max(0, p1y - PADDLE_SPEED*dt)
    elseif love.keyboard.isDown('s') then
        p1y =  math.min(VH-20, p1y + PADDLE_SPEED*dt)
    end

    if love.keyboard.isDown('up') then
        p2y = math.max(0, p2y - PADDLE_SPEED*dt)
    elseif love.keyboard.isDown('down') then
        p2y =  math.min(VH-20,p2y + PADDLE_SPEED*dt)
    end

    if gamestate == 'play' then

        if bally <= 0 or bally >= VH then
            balldy = -balldy
        end

        if ballx <= 10 or ballx >= VW-10 then
            if ballx <= 10 then
                if bally >= p1y and bally <= p1y + 20 then
                    balldx = -balldx
                else
                    winner = "p2"
                    gamestate = 'end'
                    return
                end
            else
                if bally >= p2y and bally <= p2y + 20 then
                    balldx = -balldx
                else
                    winner = "p1"
                    gamestate = 'end'
                    return
                end
            end
        end

        ballx = ballx + balldx*dt
        bally = bally + balldy*dt
    end
end

function love.draw()
    push:apply('start')

    love.graphics.clear(40, 45, 52, 255)

    love.graphics.setFont(smallFont)

    if gamestate == 'play' then
        love.graphics.printf('Play!', 0, 20, VW, 'center')
    elseif gamestate == 'end' then
        if winner == "p1" then
            love.graphics.printf('Player 1 wins!', 0, 20, VW, 'center')
        else
            love.graphics.printf('Player 2 wins!', 0, 20, VW, 'center')
        end
    else
        love.graphics.printf('Press Enter to Start!', 0, 20, VW, 'center')
    end

    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(p1score), VW/2 - 50, VH/3)
    love.graphics.print(tostring(p2score), VW/2 + 30, VH/3)

    love.graphics.rectangle('fill', 10, p1y, 5, 20)
    love.graphics.rectangle('fill', VW - 10, p2y, 5, 20)

    love.graphics.rectangle('fill', ballx, bally, 4, 4)

    push:apply('end')
end
