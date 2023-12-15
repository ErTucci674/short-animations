-- Restricted Bouncing
--
-- Copyright (c) 2023, Alessandro Amatucci Girlanda
--
-- This module is free software; you can redistribute it and/or modify it under
-- the terms of the MIT license. See LICENSE for details.

Ball = Object:extend()

function Ball:new(x, y, speed, color, sound)
    self.x = x
    self.y = y
    self.radius = ballRadius
    self.speed = speed
    self.color = color
    self.sound = sound
end

function Ball:update(dt, eL, eR)
    self.x = self.x + self.speed * dt
    self:collision(eL, eR)
end

function Ball:draw()
    love.graphics.setColor(self.color)
    love.graphics.ellipse("fill", self.x, self.y, self.radius, self.radius)
    love.graphics.setColor(0, 0, 0)
    love.graphics.ellipse("line", self.x, self.y, self.radius, self.radius)
end

function Ball:collision(eL, eR)
    if self.speed > 0 then
        if self.x + self.radius >= eR.x then
            self.x = eR.x - self.radius
            self.speed = self.speed * -1
            self.sound:play()
        end
    else
        if self.x - self.radius <= eL.x + eL.width then
            self.x = eL.x + eL.width + self.radius
            self.speed = self.speed * -1
            self.sound:play()
        end
    end
end