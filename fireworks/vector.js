// Restricted Bouncing

// Copyright(c) 2023, Alessandro Amatucci Girlanda

// This module is free software; you can redistribute it and / or modify it under
// the terms of the MIT license.See LICENSE for details.

const Vector = {
    x: 0,
    y: 0,

    newVector: function (x, y) {
        const obj = Object.create(this);
        obj.x = x;
        obj.y = y;
        return obj;
    },

    // Setters
    setLength: function (length) {
        const angle = this.getAngle();
        this.x = Math.cos(angle) * length;
        this.y = Math.sin(angle) * length;
    },

    setAngle: function (angle) {
        const length = this.getLength();
        this.x = Math.cos(angle) * length;
        this.y = Math.sin(angle) * length;
    },

    // Getters
    getLength: function () {
        return Math.sqrt(this.x * this.x + this.y * this.y);
    },

    getAngle: function () {
        return Math.atan2(this.y, this.x);
    },

    add: function (v2) {
        this.x += v2.x;
        this.y += v2.y;
    },

    copy: function (v2) {
        this.x = v2.x;
        this.y = v2.y;
    },
}