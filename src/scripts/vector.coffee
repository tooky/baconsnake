correctModulo = (a, m) -> ((a % m) + m) % m

randomInt = (max) -> Math.floor(Math.random() * max)

class Vector
  constructor: (@x, @y) ->

  add: (vector) ->
    makeVector(@x + vector.x, @y + vector.y)

  modulo: (xmod, ymod) ->
    makeVector(correctModulo(@x, xmod), correctModulo(@y, ymod))

  turnLeft: () ->
    turns = {}
    turns[makeVector(0,-1)] = makeVector(-1,0)
    turns[makeVector(-1,0)] = makeVector(0,1)
    turns[makeVector(0,1)] = makeVector(1,0)
    turns[makeVector(1,0)] = makeVector(0,-1)
    return turns[this]

  turnRight: () ->
    return @.turnLeft().turnLeft().turnLeft()

  equals: (vector) ->
    vector.x == @x and vector.y == @y

  toString: -> "(#{@x},#{@y})"

vectors = {}

# memoize so you can just use javascripts === for equality
makeVector = (x, y) ->
  key = "#{x}:#{y}"
  if not vectors[key]?
    vectors[key] = new Vector(x, y)
  return vectors[key]

makeVector.randomIntVector = (xmax, ymax) ->
  makeVector(randomInt(xmax), randomInt(ymax))

module.exports = makeVector
