@[method] = Math[method] for method in ["cos", "sin", "sqrt", "atan2", "PI"]

cartesian2polar = (x,y) ->
  # ahol az x és y a kör középpontjáig az x,y távolság
  r = sqrt(x*x + y*y)
  theta = atan2(y, x)
  return [r,theta]

polar2cartesian = (r, theta) ->
  x = r * cos(theta)
  y = r * sin(theta)
  return [x,y]

deg2rad = (deg) ->
  degree * (PI/180)

rad2deg = (theta) ->
  theta * (180/PI)

document.addEventListener 'DOMContentLoaded', ->
    window.dial = new Dial("tarcsa")
    dial.rotate("360deg", 2)
  , false

class Dial
  constructor: (el) ->
    @el = document.getElementById(el)

    #@el.addEventListener "click", @start, false
    for event in ["start", "move", "end"]
      @el.addEventListener "touch#{event}", @[event], false 

    {top, left, width, height} = @el.getBoundingClientRect()
    @centerX = width/2 + left
    @centerY = height/2 + top


  getRotation: ->
    try
      angle = @el.style.webkitTransform.match(/([0-9.-]*)deg/)[1]
      return parseInt(angle,10)
    catch e
      return false 

  calculateTheta: (e) ->
    if e.touches and e.touches.length
      e.clientX = e.touches[0].clientX
      e.clientY = e.touches[0].clientY
    [_, theta] = cartesian2polar(@centerX - e.clientX, @centerY - e.clientY)
    return theta

  calculateAngle: (e) ->
    x = @calculateTheta(e)
    if x > 0 then rad2deg x else (2*PI + x) * 360 / (2*PI)



  rotate: (angle, speed=0, ease="linear") ->
    @el.style.webkitTransition = "all #{speed}s #{ease}"
    @el.style.webkitTransform = "rotate(#{angle})"


  start: (e) =>
    e.preventDefault()
    @startTheta = @calculateTheta(e)
    #@startAngle = @calculateAngle(e) 

  move: (e) =>
    e.preventDefault()
    #angle = @calculateAngle(e)
    theta = @calculateTheta(e)
    document.getElementById("msg").innerHTML = theta
    @currentTheta = theta

    @rotate @currentTheta - @startTheta + "rad"

  end: (e) =>
    e.preventDefault()
    difference = @currentAngle - @startAngle
    @rotate "0rad", 1
    delete @[a + "Angle"] for a in ["start", "current"]

