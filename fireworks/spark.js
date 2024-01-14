// Restricted Bouncing

// Copyright(c) 2023, Alessandro Amatucci Girlanda

// This module is free software; you can redistribute it and / or modify it under
// the terms of the MIT license.See LICENSE for details.

const Spark = {
    position: null,
    velocity: null,
    gravity: null,
    radius: 0,
    bottom: 0,
    color: null,

    newSpark: function (x, y, radius, speed, angle, bottom, color) {
        const obj = Object.create(this);
        obj.position = Vector.newVector(x, y);
        obj.velocity = Vector.newVector(0, 0);
        obj.velocity.setLength(speed);
        obj.velocity.setAngle(angle);
        obj.gravity = Vector.newVector(0, 0.05);
        obj.radius = radius;
        obj.bottom = bottom;
        obj.color = color;
        return obj;
    },

    update: function () {
        this.position.add(this.velocity);
        this.velocity.add(this.gravity);
    },

    render: function (context) {
        context.fillStyle = this.color;
        context.beginPath();
        context.arc(this.position.x, this.position.y, this.radius, 0, Math.PI * 2, false);
        context.fill();
    },

    overBottom: function () {
        return (this.position.y >= this.bottom);
    }
}