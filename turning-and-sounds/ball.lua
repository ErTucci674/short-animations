-- Turning and Sounds
--
-- Copyright (c) 2023, Alessandro Amatucci Girlanda
--
-- This module is free software; you can redistribute it and/or modify it under
-- the terms of the MIT license. See LICENSE for details.

Ball = Object:extend()

function Ball:new(x, y, radius, areaRadius, speed, sound, color)
    -- Circle
    self.x = x
    self.y = y - areaRadius
    self.radius = radius
    self.currentAngle = math.pi / 2
    self.speed = speed
    self.sound = sound

    -- Imaginary Circle
    self.areaRadius = areaRadius

    -- Keeps track of the ball's motion
    self.prevX = x

    -- Color Change
    self.startColor = color
    self.endColor = {0, 0, 0}
    self.currentColor = {}
    self:resetColor()

    self.byteChange = math.pi * 2 / self.speed
    self.colorChange = {}
    self:setChange()

    -- Starting position
    self:adjust(-self.radius - 1)
end

function Ball:update(dt)
    self:move(dt)
    
    if self:collision() then
        if self.speed < 0 then
            self:adjust(-self.radius - 1)
        else
            self:adjust(self.radius + 1)
        end
        self.speed = self.speed * -1
        self.sound:play()
        self:resetColor()
    end

    self:changeColor(dt)
end

function Ball:draw()
    love.graphics.setColor(self.currentColor)
    love.graphics.ellipse("fill", self.x, self.y, self.radius, self.radius)
    love.graphics.setColor(1, 1, 1)
    love.graphics.ellipse("line", self.x, self.y, self.radius, self.radius)
end

function Ball:setChange()
    for i=1,#self.startColor do
        local diff = self.endColor[i] - self.startColor[i]
        if diff ~= 0 then
            table.insert(self.colorChange, diff / self.byteChange)
        else
            table.insert(self.colorChange, 0)
        end
    end
end

function Ball:calculatePosition()
    self.prevX = self.x
    -- Calculate new X and Y positions
    self.x = screenCenter.x + self.areaRadius * math.cos(self.currentAngle)
    self.y = screenCenter.y - self.areaRadius * math.sin(self.currentAngle)
end

function Ball:adjust(x)
    self.prevX = self.x
    self.x = screenCenter.x + x
    self.y = screenCenter.y - math.floor(math.sqrt(self.areaRadius ^ 2 - x ^ 2))
end

function Ball:move(dt)
    -- Reset Angle
    self.currentAngle = self.currentAngle + self.speed * dt
    if self.currentAngle > math.pi * 2 then
        self.currentAngle = self.currentAngle - math.pi * 2
    elseif self.currentAngle < 0 then
        self.currentAngle = math.pi * 2 + self.currentAngle
    end
    self:calculatePosition()
end

-- The collision is always going to be either the left or right side of the circle
-- For a matter of simplicity, an immaginary collision box is around the circle
function Ball:collision()
    if self.y < screenCenter.y then
        -- First Line - Check if right side collides when turning clockwise
        -- Second Line - Check if left side collides when turning anti-clockwise
        if (self.speed < 0 and self.prevX + self.radius <= screenCenter.x and self.x + self.radius >= screenCenter.x) or
            (self.speed > 0 and self.prevX - self.radius >= screenCenter.x and self.x - self.radius <= screenCenter.x) then
                return true
        end
    end
end

function Ball:resetColor()
    self.currentColor = {unpack(self.startColor)}
end

function Ball:changeColor(dt)
    for i=1,#self.currentColor do
        self.currentColor[i] = self.currentColor[i] + self.colorChange[i] * dt
    end
end