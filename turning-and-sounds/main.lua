-- Turning and Sounds
--
-- Copyright (c) 2023, Alessandro Amatucci Girlanda
--
-- This module is free software; you can redistribute it and/or modify it under
-- the terms of the MIT license. See LICENSE for details.

function love.load()
    pause = false

    -- Required Files
    Object = require("classic/classic")
    require("ball")
    require("line")

    -- GLOBALS
    -- Screen
    screenWidth, screenHeight = love.graphics.getDimensions()
    screenCenter = {x = screenWidth / 2, y = screenHeight / 2}
    backgroundColor = {0, 0, 0}
    
    circleRadius = 280
    circleTop = {x = screenCenter.x, y = screenCenter.y - circleRadius}

    -- Circles Calculations
    local areaRadius = 20
    local radius = 5
    local diameter = radius * 2
    local ballsNumber = math.floor((circleRadius - areaRadius) / (diameter))

    -- The ball furthest from the center will touch the border of the large delimiting circle
    -- If the previous 'math.floor' rounded the number, the areaRadius needs to be stretched more
    areaRadius = circleRadius - ballsNumber * diameter

    -- Coloring
    local startColor = {0.11,0,1}
    local endColor = {0,0.64,1}
    local currentColor = {unpack(startColor)}
    local byteChange = 1 / ballsNumber

    local colorChange = {}
    for i=1,#startColor do
        local diff = endColor[i] - startColor[i]
        if diff ~= 0 then
            table.insert(colorChange, byteChange / diff)
        else
            table.insert(colorChange, 0)
        end
    end

    --Sounds Settings
    local loudness = 1
    letters = {'a','b','c','d','e','f','g'}
    notes = {}
    getNotes(ballsNumber)

    local startSpeed = 0.8
    local speedChange = 0.011
    balls = {}
    lines = {}

    -- Generating and inserting balls and lines two separated lists
    for b=1,ballsNumber do
        -- Setting Color
        if b ~= 1 then
            for i=1,#currentColor do
                currentColor[i] = currentColor[i] + colorChange[i]
            end
        end

        -- Sound Source
        local source = notes[b]
        source:setVolume(loudness)
        loudness = loudness - 0.03

        -- Setting individual ball
        local ball = Ball(screenCenter.x, screenCenter.y, radius, areaRadius + diameter * (b - 1), startSpeed - speedChange * startSpeed * (b - 1), source, {unpack(currentColor)})
        table.insert(balls, ball)

        -- Setting individual line
        local line = Line(screenCenter.x, screenCenter.y, areaRadius + diameter * (b - 1) - radius)
        table.insert(lines, line)
    end

    love.audio.setVolume(0.5)
end

function love.update(dt)
    if not pause then
        for i,ball in ipairs(balls) do
            ball:update(dt)
            lines[i]:update(ball.currentAngle, ball.currentColor)
        end
    end
end

function love.draw()
    -- Circle
    love.graphics.ellipse("line", screenCenter.x, screenCenter.y, circleRadius, circleRadius)
    -- Line
    love.graphics.line(screenCenter.x, screenCenter.y, circleTop.x, circleTop.y)

    -- The lines stay always behind all the balls
    -- The lines are drawn first
    -- The lines closer to the center are drawn on top (reversed list)
    for l=#lines,1,-1 do
        lines[l]:draw()
    end

    for b,ball in ipairs(balls) do
        ball:draw()
    end
end

function love.keypressed(key)
    if key == 'space' then
        if pause then
            pause = false
        else
            pause = true
        end
    end
end

-- Music Functions
function getNotes(ballsNumber)
    -- Highest pitch, first in the list
    for i=5,3,-1 do
        for l=#letters,1,-1 do
            local path1 = 'notes/' .. letters[l] .. '-' .. i .. '.mp3'
            local path2 = 'notes/' .. letters[l] ..  i .. '.mp3'
            if love.filesystem.getInfo(path1) then
                table.insert(notes, love.audio.newSource(path1, "stream"))
            end
            if love.filesystem.getInfo(path2) then
                table.insert(notes, love.audio.newSource(path2, "stream"))
            end
        end
    end
end