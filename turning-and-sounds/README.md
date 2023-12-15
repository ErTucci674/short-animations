# Turning and Sounds
## Introduction 📖
The animation consists of circles travelling in a constant turning motion around a wider circle's centre point. The small circles are attached with a string to the centre point. A vertical line connects the centre point to the top side of the circle's diametre. When the circles reach the vertical line, they bounce back and start turning in the opposite direction. The circles and their corrisponding strings start with a specific colour each which gradually changes to black while reaching the other side of the string. When a circle collides its music note is played and the colours instantly changes back to the original. Each circle is slightly faster than the previous one.

## Built with ⌨️
+ Lua (v5.4.2)
+ LÖVE (Framework - v11.4)

## Play Animation (Windows only) ▶️
To play the animation, download the zip folder

```
TurningAndSounds.zip
```

Extract the files into a new folder, open the `.exe` file and relax.

## Files and Code 📄
### Configurations/Settings ⚙️
The `conf.lua` file contains all the main back-end configurations of the application. It includes: window default size, LÖVE version, console visibility, audio control, input control (mouse, keyboard, joystick), etc. The function layout has been taken from the original [LÖVE](https://love2d.org/wiki/Config_Files) website and adjusted to suit the game's settings.

### Class Library 📚
To ensure flexibility and readability of the project, every entity (walls and circles) has been assigned to a class and managed using Object-Oriented Programming. In the project repository, the `classic` folder contains a library which simplifies the operation of classes:
```
path: classic/classic.lua
```

### Entities 👥
There are only two _Entities/Objects_ in the animation: the lines (strings) and the balls (circles).

#### Circles 🔴🟠🟡🟢🔵🟣⚪
Each circles object contains an imaginary wider circle with `self.areaRadius` radius. The circle's turning motion travels along the imaginary circle's diameter.

The circle object is always set to start on top of the vertical line and shifted by just a bit more than its radius on the _x-axis_. The _Y_ position is calculated by the `Ball:adjust()` method.

```lua
function Ball:adjust(x)
    self.prevX = self.x
    self.x = screenCenter.x + x
    self.y = screenCenter.y - math.floor(math.sqrt(self.areaRadius ^ 2 - x ^ 2))
end
```

The method takes a parameter _X_ as _shifting_ value. The _Y_ value is then calculated using **Pythagoras' Theorem**.

Pythagoras' Theorem: a<sup>2</sup> + b<sup>2</sup> = c<sup>2</sup>

Substitute Values: x<sup>2</sup> + y<sup>2</sup> = areaRadius<sup>2</sup>

Rearrangement: y<sup>2</sup> = &radic;(areaRadius<sup>2</sup> - b<sup>2</sup>)

The `self.prevX` attribute stores the circle's previous _X_ position. This is used in the collision method to check if the circle goes on top or over the vertical line. While the `self.speed` attribute is checked to know the turning direction, the `self.prevX` is used to observe the change in position of the circle.

```lua
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
```

The circle's colour is determined by 3 main attributes: `self.startColor`, `self.endColor`, `self.currentColor`. The latter is the variable where the circle's colour shown in is stored. The other two attributes are the starting and the ending colours. The colour change is managed by the method `Ball:changeColor()`.

```lua
function Ball:changeColor(dt)
    for i=1,#self.currentColor do
        self.currentColor[i] = self.currentColor[i] + self.colorChange[i] * dt
    end
end
```

The `Ball:changeColor()` method makes use of the `self.colorChange` attribute to gradually change the circle's colours by a specific value per RGB value. The changing value is calculated by the `Ball:setChange()` parameter.

```lua
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
```

The collision is checked in the `Ball:update()` method. If it returns _True_, the circle is adjusted, the sound is played, the colour is reset to its original starting colour, and the turning direction is flipped.

The actual movement of the circle is controlled by the `Ball:calculatePosition()` method. Just like `Ball:adjust()`, the circle's position is calculated with **Pythagoras' Theorem**.

```lua
function Ball:calculatePosition()
    self.prevX = self.x
    -- Calculate new X and Y positions
    self.x = screenCenter.x + self.areaRadius * math.cos(self.currentAngle)
    self.y = screenCenter.y - self.areaRadius * math.sin(self.currentAngle)
end
```

#### Lines 🧶
The line objects are dependant on the circles. Their colour and angle are taken from circles in the `main.lua` file and used as parameters in the `Line:update()` method to change their colour and position. 

```lua
function Line:update(angle, color)
    self:calculatePosition(angle)
    self.color = {unpack(color)}
end
```

### Main File ⚡
The `main.lua` file manges the entire program. It makes use of the _Object_ files to generate the lines and the circles in the animation. The objects generation takes place in the `love.load()` function.

```lua
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
```

A _for loop_ repeats _ballsNumber_ times. On each cycle a circle and its line are generated and inserted in their corresponding lists: `balls`, `lines`. On every circle generation, the object speed and imaginary circle's radius are changed by previously declared _variables_.

The sound sources are taken from the _mp3_ files stored in the `notes` folder.

```lua
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
```

The function uses the `love.filesystem.getInfo` method to check if the file exists. Not all of the notes have a _sharp_ version ('-' included in the name). The notes are stored in the `notes` list so that the last one is the one with the highest pitch. For a matter of sound quality, for each circle generation, the sound assigned to is at a lower volume than the previous one.

## Reference Links 🔗
**Where the Idea comes from - Project JDM**: [Project JDM - YouTube](https://www.youtube.com/watch?v=WULMIjhMFmE&list=PLuCgt64IoZ1sTXvIEb07F0L_0c2Ycfr5l&index=11&t=2s) 

**LÖVE Website**: [LOVE2D](https://love2d.org/wiki/Main_Page)

**Classes Library (classic)**: [GitHub/rxi/classic](https://github.com/rxi/classic)

**Rainbow Colors Values**: [RapitTables](https://www.rapidtables.com/web/color/RGB_Color.html)

**Music notes**: [MediaFire](https://www.mediafire.com/download/zd1mqtazulgv28a/mp3_Notes.rar)

## Licence 🖋️
This module is free software; you can redistribute it and/or modify it under
the terms of the MIT license. See [LICENSE](../LICENCE) for details.