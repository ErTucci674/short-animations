-- Restricted Bouncing
--
-- Copyright (c) 2023, Alessandro Amatucci Girlanda
--
-- This module is free software; you can redistribute it and/or modify it under
-- the terms of the MIT license. See LICENSE for details.

function love.load()
    -- Files
    Object = require("classic/classic")
    require("rectangle")
    require("ball")

    -- Globals --
    -- Window
    screenWidth, screenHeight = love.graphics.getDimensions()
    backgroundColor = {1, 1, 1} -- White

    -- Rectangle Specs
    recStart = 80
    recSpeed = 3

    -- Ball Specs
    ballRadius = 20
    ballDistance = ballRadius * 3
    ballsNumber = 8
    ballStart = (screenHeight - (ballDistance * (ballsNumber - 1) + ballRadius)) / 2 + ballRadius / 2
    ballSpeed = 100
    
    -- Colors
    rainbow = {
        {255, 0, 0},
        {255, 127, 0},
        {255, 255, 0},
        {0, 255, 0},
        {0, 0, 255},
        {75, 0, 130},
        {148, 0, 211},
        {255, 255, 255}
    }

    -- Lua works with decimal values
    -- Change 'rainbow' values to decimal
    for i,color in ipairs(rainbow) do
        for j, num in ipairs(color) do
            rainbow[i][j] = rainbow[i][j] / 255
        end
    end

    -- Create walls
    recL = Rectangle(0, screenHeight, 1)
    recR = Rectangle(screenWidth, screenHeight, -1)

    -- Generate 'balls'
    --Assign sounds
    local rate = 44100 -- samples per second
    local length = 1/8
    local tone = 1000 -- Hz
    local toneChange = tone / ballsNumber

    

    balls = {}
    for i = 1, ballsNumber do
        -- Generating new sound
        local p  = math.floor(rate/(tone - toneChange * (i - 1))) -- wave length in samples
        local soundData = love.sound.newSoundData(math.floor(length*rate), rate, 16, 1)
        for j=0, soundData:getSampleCount() - 1 do
            soundData:setSample(j, math.sin(2*math.pi*j/p)) -- sine wave.
        end
        local source = love.audio.newSource(soundData)

        -- Ball object creation
        local ball = Ball(recStart + ballRadius, ballStart + (i - 1) * ballDistance, ballSpeed - (i - 1) * 2, rainbow[i], source)
        table.insert(balls, ball)
    end
end

function love.update(dt)
    recL:update(dt)
    recR:update(dt)

    for i,ball in ipairs(balls) do
        ball:update(dt, recL, recR)
    end

    love.audio.setVolume(0.5)
end

function love.draw()
    -- Background Color
    love.graphics.setColor(backgroundColor)
    love.graphics.rectangle("fill", 0, 0, screenWidth, screenHeight)
    
    recL:draw()
    recR:draw()
    
    for i,ball in ipairs(balls) do
        ball:draw()
    end
end