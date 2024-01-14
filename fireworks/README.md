# 🎆 Fireworks 🎇
## Introduction 📖
The program makes use of the `canvas` element of HTML to draw and render the fireworks' animations. The user can click anywhere around the window page and, for every clik, a firework starts rocketing from the bottom of the screen till the clicked spot on the window. When the final destination is reached, the firework explodes into many smaller particles of a random colours and various shades.

## Built with ⌨️
+ HTML/CSS
+ JavaScript

## Play Animation ▶️
To play the animation you can download the repository's _Fireworks_ folder in your machine, exctract all the files and open the `index.html` file.

## Files and Code 📄
### Window File 🧱
The `index.html` file contains the structure of the window and the declaration of all of the JavaScript files that have been used.

### Main File ⚡
The `main.js` file controls all of the dynamics of the code, from the rendering to the physics and user's interactions.

All the code in the `main.js` file is enclosed in a function that gets executed when the window is fully loaded, `window.onload()`.

The `canvas` element is controlled by the `canvas` and `context` variables. The canvas size is adjusted every time the window is re-sized. This is done by the `window.addEventLisnteer("resize")` function.

```js
 window.addEventListener("resize", function () {
    width = canvas.width = window.innerWidth;
    height = canvas.height = window.innerHeight;
});
```

The `main()` function is constantly updated by the browser. The `render()` function updates all of the shapes and colours to be displayed on the window. The `update()` function loads all of the dynamics and physics of the animation, instead.

### Spark Object and Vectors ✨↗️
The firework class is assigned to the fireworks when they are generated. The object consists of two phases: the 'rocket' and the explosion. The phase is controlled by the `explosion` attribute. During the 'rocket' phase, the object is updated to move upwards till it reaches the point that has been clicked. At that point, the 'rocket' rendering and updating terminates and the list of spark objects is created. Each spark is 'shot' from the point of the explosion with a random direction but all of them affected by gravity. Hence, tending to fall downwards.

The physics is dynamically configured with the `Vector` class. The position, velocity, and gravity are `Vector` objects which include an 'X' and 'Y' value. The position of the single object is updated by adding the `velocity` vector to it. As sparks are also affected by gravity which is an acceleration, or a change of velocity, hence the `gravity` vector is added to the `velocity` vector.

Sparks' update code:

```js
update: function () {
    this.position.add(this.velocity);
    this.velocity.add(this.gravity);
},
```

As the position is constantly update by adding the vector velocity, only the velocity vector needs to be changed to affect the object. This makes the code more flexible and simpler to manage.

The `spark` class includes the `overBottom()` function which return _True_ whenever the spark goes over the bottom margin of the window. The purpose of it is to tell the corresponding firework object that it can remove that `spark` from the list. Resulting in a less stressed CPU and memory usage. The check is executed in the `update()` function in the `firework.js` file.

```js
update: function () {
    this.endPosition();
    if (!this.explosion) {
        this.position.add(this.velocity);
    }
    else {
        for (let i = this.sparks.length - 1; i >= 0; i--) {
            this.sparks[i].update();

            // Remove Sparks
            if (this.sparks[i].overBottom()) {
                this.sparks.splice(i, 1);
            }
        }
    }
},
```

Same idea applies for the `firework`. Whenever the explosion took place and all of the sparks reached the end of the window, the `finished()` function return _True_ to the `main()` function so the firework object can be removed from the `fireworks` list.

```js
function update() {
    for (let i = fireworks.length - 1; i >= 0; i--) {
        fireworks[i].update();

        // Remove firework
        if (fireworks[i].finished()) {
            fireworks.splice(i, 1);
        }
    }
}
```

In the `firework.js` file, the `generateSparks()` function generates a random colour and many different shades of that same colour which are then assigned to the sparks to be generated.

This is done by taking a random value from 0 to 255 for each RGB value as the main colour.

```js
// Generate constant random color
const rgb = {
    r: 0,
    g: 0,
    b: 0,
};

for (let color in rgb) {
    rgb[color] = Math.floor(Math.random() * 256);
}
```

 Then, for each spark, get a random `multiplier` between 0 and 1 which is used to scale down each RGB value by the same factor. Hence, resulting in a shade of the main colour. Since the `canvas` element works with Hexadecimal values, the obtained decimal values need to be converted before being implemented, this is done by the `decToHex()` function. All the values are then converted to strings and combined in a single attribute contained in the `Spark` class, `color`.

```js
// Generate Sparks
for (let i = 0; i < 100; i++) {
    const tmp = {
        r: rgb["r"],
        g: rgb["g"],
        b: rgb["b"],
    }

    // Set random shade
    const multiplier = Math.random();
    for (c in tmp) {
        tmp[c] = Math.floor(255 - tmp[c] * multiplier);
    }

    const color = "#" + this.decToHex(tmp["r"]) + this.decToHex(tmp["g"]) + this.decToHex(tmp["b"]);
    const spark = Spark.newSpark(this.position.x, this.position.y, this.radius * 0.5, Math.random() * 2 + 1, Math.random() * Math.PI * 2, this.bottom, color);
    this.sparks.push(spark);
}
```

## Licence 🖋️
This module is free software; you can redistribute it and/or modify it under the terms of the MIT license. See [LICENSE](../LICENCE) for details.