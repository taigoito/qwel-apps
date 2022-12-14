// Generated by CoffeeScript 1.12.7

/*
  Skech
  Last update: 2018/03/29
 */
var Particle, Sketch, Vector,
  bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

Vector = (function() {
  function Vector(x, y) {
    this.x = x;
    this.y = y;
    return;
  }

  Vector.prototype.set = function(x, y) {
    this.x = x;
    this.y = y;
  };

  Vector.prototype.add = function(v) {
    return new Vector(this.x + v.x, this.y + v.y);
  };

  Vector.prototype.mult = function(x, y) {
    y || (y = x);
    return new Vector(this.x * x, this.y * y);
  };

  return Vector;

})();

Particle = (function() {
  function Particle(x, y, min1, max1, radius1, force1, hue1) {
    this.min = min1;
    this.max = max1;
    this.radius = radius1;
    this.force = force1;
    this.hue = hue1;
    this.throughCount = 0;
    this.location = new Vector(x, y);
    this.velocity = new Vector(0, 0);
    this.acceleration = new Vector(0, 0);
    this.gravity = new Vector(0, 1 / 100);
    this.mass = this.radius / 100;
    this.frictionX = 0;
    this.frictionY = 1 / 1000;
    this.acceleration = this.force.mult(this.mass);
    return;
  }

  Particle.prototype.update = function() {
    this.acceleration = this.acceleration.add(this.gravity);
    this.velocity = this.velocity.add(this.acceleration);
    this.velocity = this.velocity.mult(1 - this.frictionX, 1 - this.frictionY);
    this.location = this.location.add(this.velocity);
    this.acceleration.set(0, 0);
    if (this.throughCount) {
      this.through();
    } else {
      this.bound();
    }
  };

  Particle.prototype.bound = function() {
    if (this.location.x < this.min.x + this.radius) {
      this.location.x = this.min.x + this.radius;
      this.velocity.x *= -1;
    }
    if (this.location.x > this.max.x - this.radius) {
      this.location.x = this.max.x - this.radius;
      this.velocity.x *= -1;
    }
    if (this.location.y < this.min.y - this.radius) {
      this.location.y = this.min.y - this.radius;
      this.velocity.y *= -1;
    }
    if (this.location.y > this.max.y - this.radius) {
      this.location.y = this.max.y - this.radius;
      this.velocity.y *= -1;
    }
  };

  Particle.prototype.through = function() {
    if (this.location.x < this.min.x + this.radius) {
      this.location.x = this.min.x + this.radius;
      this.velocity.x *= -1;
    }
    if (this.location.x > this.max.x - this.radius) {
      this.location.x = this.max.x - this.radius;
      this.velocity.x *= -1;
    }
    if (this.location.y < this.min.y) {
      this.location.y = this.max.y;
      this.throughCount--;
      this.hue += 60;
    }
    if (this.location.y > this.max.y) {
      this.location.y = this.min.y;
      this.throughCount--;
      this.hue += 60;
    }
  };

  return Particle;

})();

Sketch = (function() {
  function Sketch($el) {
    this.resize = bind(this.resize, this);
    this.change = bind(this.change, this);
    this.handleEvents = bind(this.handleEvents, this);
    this.draw = bind(this.draw, this);
    this.setup = bind(this.setup, this);
    this.canvas = document.createElement('canvas');
    this.canvas.id = 'canvas';
    $el.append(this.canvas);
    this.setup();
    this.handleEvents();
    return;
  }

  Sketch.prototype.setup = function() {
    this.count = 0;
    this.hue = 0;
    this.particles = [];
    this.frameRate = 60;
    this.resize();
    this.creation(10, this.hue);
    this.draw();
  };

  Sketch.prototype.creation = function(num, hue) {
    var force, i, j, max, min, r, radius, ref, x, y;
    for (i = j = 0, ref = num; 0 <= ref ? j < ref : j > ref; i = 0 <= ref ? ++j : --j) {
      x = Math.floor(Math.random() * 180) + this.canvas.width / 2 - 90;
      y = Math.floor(Math.random() * 180) + 180;
      if ($(window).width() < 1024) {
        radius = Math.floor(Math.random() * $(window).width() / 12) + $(window).width() / 24;
      } else {
        radius = Math.floor(Math.random() * 60) + 30;
      }
      min = new Vector(0, 0);
      max = new Vector(this.canvas.width, this.canvas.height);
      r = this.canvas.height / this.canvas.width;
      force = new Vector(Math.random() * 4 - 2, Math.random() * r * 4 - 2);
      this.particles[i] = new Particle(x, y, min, max, radius, force, hue);
    }
  };

  Sketch.prototype.draw = function() {
    var ctx, ellipseGradient, i, j, len, ref;
    this.count++;
    ctx = this.canvas.getContext('2d');
    ctx.fillStyle = 'hsla(0, 0%, 100%, .15)';
    ctx.fillRect(0, 0, this.canvas.width, this.canvas.height);
    len = this.particles.length;
    for (i = j = 0, ref = len; 0 <= ref ? j < ref : j > ref; i = 0 <= ref ? ++j : --j) {
      this.particles[i].update();
      ctx.beginPath();
      ellipseGradient = ctx.createRadialGradient(this.particles[i].location.x - this.particles[i].radius / 3, this.particles[i].location.y - this.particles[i].radius / 3, 0, this.particles[i].location.x, this.particles[i].location.y, this.particles[i].radius * 2);
      ellipseGradient.addColorStop(0, 'hsla(' + this.particles[i].hue + ', 85%, 100%, .7)');
      ellipseGradient.addColorStop(1, 'hsla(' + this.particles[i].hue + ', 85%, 70%, .7)');
      ctx.fillStyle = ellipseGradient;
      ctx.arc(this.particles[i].location.x, this.particles[i].location.y, this.particles[i].radius, 0, Math.PI * 2);
      ctx.closePath();
      ctx.fill();
    }
    if (this.count > 3600) {
      this.change();
    }
    requestAnimationFrame(this.draw);
  };

  Sketch.prototype.handleEvents = function() {
    $(window).on('resize', this.resize);
  };

  Sketch.prototype.change = function() {
    var i, j, len, ref, results;
    this.count = 0;
    len = this.particles.length;
    results = [];
    for (i = j = 0, ref = len; 0 <= ref ? j < ref : j > ref; i = 0 <= ref ? ++j : --j) {
      results.push(this.particles[i].throughCount++);
    }
    return results;
  };

  Sketch.prototype.resize = function() {
    var i, j, len, ref;
    if ($(window).width() < 1024) {
      this.canvas.width = $(window).width();
      this.canvas.height = $(window).height();
    } else {
      this.canvas.width = 1024;
      this.canvas.height = $(window).height() / $(window).width() * 1024;
    }
    len = this.particles.length;
    for (i = j = 0, ref = len; 0 <= ref ? j < ref : j > ref; i = 0 <= ref ? ++j : --j) {
      this.particles[i].max.set(this.canvas.width, this.canvas.height);
    }
  };

  return Sketch;

})();
