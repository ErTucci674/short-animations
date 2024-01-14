// Restricted Bouncing

// Copyright(c) 2023, Alessandro Amatucci Girlanda

// This module is free software; you can redistribute it and / or modify it under
// the terms of the MIT license.See LICENSE for details.

const Firework = {
    position: null,
    velocity: null,
    finalY: 0,
    radius: 0,
    explosion: false,
    bottom: 0,
    sparks: null,

    newFirework: function (x, y, finalY, radius, speed, bottom) {
        const obj = Object.create(this);
        obj.position = Vector.newVector(x, y);
        obj.velocity = Vector.newVector(0, -speed);
        obj.finalY = finalY;
        obj.radius = radius;
        obj.bottom = bottom;
        obj.sparks = [];
        return obj;
    },

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

    render: function (context) {
        if (!this.explosion) {
            context.fillStyle = "black";
            context.beginPath();
            context.arc(this.position.x, this.position.y, this.radius, 0, Math.PI * 2, false);
            context.fill();
        }
        else {
            for (let i = 0, l = this.sparks.length; i < l; i++) {
                this.sparks[i].render(context);
            }
        }
    },

    endPosition: function () {
        if (!this.explosion && this.position.y <= this.finalY) {
            this.explosion = true;
            this.generateSparks();
        }
    },

    // Convert Decimal value to Hexadecimal value
    decToHex: function (value) {
        return Number.isInteger(value) ? value.toString(16).toUpperCase() : "00";
    },

    generateSparks: function () {
        // Generate constant random color
        const rgb = {
            r: 0,
            g: 0,
            b: 0,
        };

        for (let color in rgb) {
            rgb[color] = Math.floor(Math.random() * 256);
        }

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
    },

    finished: function () {
        return (this.explosion && this.sparks.length == 0);
    },
}