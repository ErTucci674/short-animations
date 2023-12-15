-- Turning and Sounds
--
-- Copyright (c) 2023, Alessandro Amatucci Girlanda
--
-- This module is free software; you can redistribute it and/or modify it under
-- the terms of the MIT license. See LICENSE for details.

Line = Object:extend()

function Line:new(x, y, length, color)
    self.x1 = x
    self.y1 = y
    self.x2 = x
    self.y2 = y
    self.length = length
    self.color = {1, 1, 1}
end

function Line:update(angle, color)
    self:calculatePosition(angle)
    self.color = {unpack(color)}
end

function Line:draw()
    love.graphics.setColor(self.color)
    love.graphics.line(self.x1, self.y1, self.x2, self.y2)
end

function Line:calculatePosition(angle)
    -- Calculate X and Y position at which the line comes in contact with the circle
    self.x2 = screenCenter.x + self.length * math.cos(angle)
    self.y2 = screenCenter.y - self.length * math.sin(angle)
end