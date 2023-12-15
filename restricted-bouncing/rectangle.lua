-- Restricted Bouncing
--
-- Copyright (c) 2023, Alessandro Amatucci Girlanda
--
-- This module is free software; you can redistribute it and/or modify it under
-- the terms of the MIT license. See LICENSE for details.

Rectangle = Object:extend()

function Rectangle:new(x, height, dir)
    self.width = recStart
    self.height = height
    self.speed = recSpeed
    self.dir = dir

    self.y = 0
    if dir == -1 then
        self.x = x - self.width
    else
        self.x = x
    end

    self.color = {0, 0, 0}
end

function Rectangle:update(dt)
    if self.width < screenWidth / 2 - ballRadius then
        self.width = self.width + (self.speed * dt)
        if self.dir == -1 then
            self.x = self.x - self.speed * dt
        end
    else
        love.event.quit()
    end
end

function Rectangle:draw()
    love.graphics.setColor(self.color)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end