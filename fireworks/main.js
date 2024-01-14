// Restricted Bouncing

// Copyright(c) 2023, Alessandro Amatucci Girlanda

// This module is free software; you can redistribute it and / or modify it under
// the terms of the MIT license.See LICENSE for details.

window.onload = function () {
    const canvas = document.getElementById("canvas");
    const context = canvas.getContext("2d");
    let width = canvas.width = window.innerWidth;
    let height = canvas.height = window.innerHeight;

    let fireworks = [];

    main();

    // Adjust canvas
    window.addEventListener("resize", function () {
        width = canvas.width = window.innerWidth;
        height = canvas.height = window.innerHeight;
    });

    window.addEventListener("click", function (event) {
        generateFireworks(event.clientX, event.clientY);
    });

    function main() {
        update();
        render();

        requestAnimationFrame(main);
    }

    function update() {
        for (let i = fireworks.length - 1; i >= 0; i--) {
            fireworks[i].update();

            // Remove firework
            if (fireworks[i].finished()) {
                fireworks.splice(i, 1);
            }

        }
    }

    function render() {
        context.clearRect(0, 0, width, height);
        for (let i = fireworks.length - 1; i >= 0; i--) {
            fireworks[i].render(context);
        }
    }

    function generateFireworks(x, y) {
        const firework = Firework.newFirework(x, height, y, 5, 5, height);
        fireworks.push(firework);
    }
}