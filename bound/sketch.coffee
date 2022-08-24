###
  Skech
  Last update: 2018/03/29
###

class Vector
  constructor: (x, y) ->
    @x = x
    @y = y
    return

  set: (x, y) ->
    @x = x
    @y = y
    return

  add: (v) ->
    new Vector @x + v.x, @y + v.y
  
  mult: (x, y) ->
    y ||= x 
    new Vector @x * x, @y * y

class Particle
  constructor: (x, y, @min, @max, @radius, @force, @hue) ->
    @throughCount = 0
    @location = new Vector x, y
    @velocity = new Vector 0, 0
    @acceleration = new Vector 0, 0
    @gravity = new Vector 0, 1 / 100
    @mass = @radius / 100
    @frictionX = 0
    @frictionY = 1 / 1000
    @acceleration = @force.mult @mass
    return
  
  update: ->
    @acceleration = @acceleration.add @gravity
    @velocity = @velocity.add @acceleration
    @velocity = @velocity.mult(1 - @frictionX, 1 - @frictionY)
    @location = @location.add @velocity
    @acceleration.set 0, 0
    if @throughCount then @through() else @bound()
    return
  
  bound: ->
    if @location.x < @min.x + @radius
      @location.x = @min.x + @radius
      @velocity.x *= -1
    if @location.x > @max.x - @radius
      @location.x = @max.x - @radius
      @velocity.x *= -1
    if @location.y < @min.y - @radius
      @location.y = @min.y - @radius
      @velocity.y *= -1
    if @location.y > @max.y - @radius
      @location.y = @max.y - @radius
      @velocity.y *= -1
    return

  through: ->
    if @location.x < @min.x + @radius
      @location.x = @min.x + @radius
      @velocity.x *= -1
    if @location.x > @max.x - @radius
      @location.x = @max.x - @radius
      @velocity.x *= -1
    if @location.y < @min.y
      @location.y = @max.y
      @throughCount--
      @hue += 60
    if @location.y > @max.y
      @location.y = @min.y
      @throughCount--
      @hue += 60
    return

class Sketch
  constructor: ($el) ->
    @canvas = document.createElement 'canvas'
    @canvas.id = 'canvas'
    $el.append @canvas
    @setup()
    @handleEvents()
    return

  setup: =>
    @count = 0
    @hue = 0
    @particles = []
    @frameRate = 60
    @resize()
    @creation(10, @hue)
    @draw()
    return
  
  creation: (num, hue) ->
    for i in [0...num]
      x = Math.floor(Math.random() * 180) + @canvas.width / 2 - 90
      y = Math.floor(Math.random() * 180) + 180
      if $(window).width() < 1024
        radius = Math.floor(Math.random() * $(window).width() / 12) + $(window).width() / 24
      else
        radius = Math.floor(Math.random() * 60) + 30
      min = new Vector 0, 0
      max = new Vector @canvas.width, @canvas.height
      r = @canvas.height / @canvas.width 
      force = new Vector Math.random() * 4 - 2, Math.random() * r * 4 - 2
      @particles[i] = new Particle x, y, min, max, radius, force, hue
    return
  
  draw: =>
    @count++
    ctx = @canvas.getContext '2d'
    ctx.fillStyle = 'hsla(0, 0%, 100%, .15)'
    ctx.fillRect(0, 0, @canvas.width, @canvas.height)
    len = @particles.length
    for i in [0...len]
      @particles[i].update()
      ctx.beginPath()
      ellipseGradient = ctx.createRadialGradient @particles[i].location.x - @particles[i].radius / 3, @particles[i].location.y - @particles[i].radius / 3, 0, @particles[i].location.x, @particles[i].location.y, @particles[i].radius * 2
      ellipseGradient.addColorStop 0, 'hsla(' + @particles[i].hue + ', 85%, 100%, .7)'
      ellipseGradient.addColorStop 1, 'hsla(' + @particles[i].hue + ', 85%, 70%, .7)'
      ctx.fillStyle = ellipseGradient
      ctx.arc @particles[i].location.x, @particles[i].location.y, @particles[i].radius, 0, Math.PI * 2
      ctx.closePath()
      ctx.fill()
    if @count > 3600 then @change()
    requestAnimationFrame @draw
    return

  handleEvents: =>
    $(window).on 'resize', @resize
    return
  
  change: =>
    @count = 0
    len = @particles.length
    for i in [0...len]
      @particles[i].throughCount++
  
  resize: =>
    if $(window).width() < 1024
      @canvas.width = $(window).width()
      @canvas.height = $(window).height()
    else 
      @canvas.width = 1024
      @canvas.height = $(window).height() / $(window).width() * 1024
    len = @particles.length
    for i in [0...len]
      @particles[i].max.set @canvas.width, @canvas.height
    return