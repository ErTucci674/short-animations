# Restricted Bouncing
## Introduction 📖
The animation begins with 8 coloured circles moving from left to right, each one faster than the previous one. As the circles reach the black wall on the right side, they bounce back and play their assigned sounds. Same thing happens when bouncing on the wall on the left side. In the meantime, both the walls move at a constat speed towards the center, delimiting the circles' range of motion. When the walls are a circle's diamter distance from each other, the window closes.

## Built with ⌨️
+ Lua (v5.4.2)
+ LÖVE (Framework - v11.4)

## Play Animation (Windows only) ▶️
To play the animation, download the zip folder

```
RestrictedBouncing.zip
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
There are only two _Entities/Objects_ in the animation: the walls and the cicles.

#### Walls 🧱
The `rectangle.lua` file contains the walls' methods. The left and right wall are distinguished by the `self.dir` attribute where the `dir` parameter (1 or -1) is stored. The wall position (left/right) is initiated depending on this attribute.

```lua
if dir == -1 then
    self.x = x - self.width
else
    self.x = x
end
```

In the program, the walls are not actually moving. Although, their width is increased over time depending on their `self.speed`. When a rectangle is generated, the starting point (x = 0, y = 0) is its top left corner. When the width is increased, this point extends to the right. This mechanics perfectly works for the left wall. However, nothing seems to be happening to the right wall. This is because it needs to be shifted to the left at the same _extending_ speed.

```lua
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
```

The `love.event.quit` function closes the game when the walls are touching both sides of the circles (walls being at a _circles' diameter_ distance from each other).

#### Circles 🔴🟠🟡🟢🔵🟣⚪
The `ball.lua` file contains the circles' methods. The main feature of the circles is the `collision()` method that checks if the ball comes in contact with either of the two walls.

In the `Ball:update()`, every time the circles is shifted the collision function is called and two _entities'_ are given as parameters: left and right wall.

```lua
function Ball:update(dt, eL, eR)
    self.x = self.x + self.speed * dt
    self:collision(eL, eR)
end
```

The collision function, first of all, checks which direction the circle is moving to by identifying the `self.speed` sign (+/-). If the speed is a positive number, the function checks if the right side of the circle is colliding (or over) the right wall, and vice versa. To avoid any imprecision, on every collision the circle's _X_ position is set to be touching the wall.

```lua
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
```

The circle's speed flips and its corresponding sound is played.

### Main File ⚡
The `main.lua` file manges the entire program. It makes use of the _Object_ files to generate the walls and the circles in the animation.

```lua
Object = require("classic/classic")
require("rectangle")
require("ball")
```

The walls are stored and controlled by the object-variables `recL` and `recR`.

```lua
recL = Rectangle(0, screenHeight, 1)
recR = Rectangle(screenWidth, screenHeight, -1)
```

The circles, instead, are managed through a list which is setup through a _for loop_. The circles take different parameters as shown in the code below.

```lua
function Ball:new(x, y, speed, color, sound)
```

The individual circle's speed changes from one another by 1. The colours are selected one by one from the `rainbow` list. Each colours is stored as RGB values in separated lists. LÖVE, however, needs values in between 0 and 1. The _for loop_ taking place after the list converts these numbers for us.

```lua
-- Lua works with decimal values
-- Change 'rainbow' values to decimal
for i,color in ipairs(rainbow) do
    for j, num in ipairs(color) do
        rainbow[i][j] = rainbow[i][j] / 255
    end
end
```

An other important attribute the circles have is the sound they produce when colliding with a wall. The sound is manually generated with the _loved2D_ library through the creation of a `newSoundData` and `newSource` where the tone (pitch) changes for every circle.

```lua
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
```

Walls and circles are updated and drawn by the `love.update` and `love.draw` functions.

## Reference Links 🔗
_The idea has been taken online from an other designer. If you find them, please, notify me and I'll include their video link here in the reference list._

**LÖVE Website**: [LOVE2D](https://love2d.org/wiki/Main_Page)

**Classes Library (classic)**: [GitHub/rxi/classic](https://github.com/rxi/classic)

**Rainbow Colors Values** - [WebNots](https://www.webnots.com/vibgyor-rainbow-color-codes/)

## Licence 🖋️
This module is free software; you can redistribute it and/or modify it under
the terms of the MIT license. See [LICENSE](../LICENCE) for details.