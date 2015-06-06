_ = require('lodash')
Bacon = require('baconjs')

Vector = require('./vector')
{Keys} = require('./inputs')

# Returns a stream or property of snake head direction
snakeHeadDirection = (initialSnakeHeadDirection, keyPresses) ->
  equalTo = (expected) ->
    return (actual) -> actual == expected

  lefts = keyPresses.filter(equalTo(Keys.LEFT))
  rights = keyPresses.filter(equalTo(Keys.RIGHT))

  leftTurns = lefts.map (press) ->
    return (vector) -> vector.turnLeft()

  rightTurns = lefts.map (press) ->
    return (vector) -> vector.turnLeft().turnLeft().turnLeft()

  turns = rightTurns.merge(leftTurns)

  headDirection = rights.scan initialSnakeHeadDirection, (currentHeadDirection, rightKeyPress) ->
    return currentHeadDirection.turnRight()

  return headDirection


# Returns a stream or property of snake head positions
snakeHeadPosition = (initialSnakeHeadPosition, snakeHeadDirection, keyPresses) ->
  equalTo = (expected) ->
    return (actual) -> actual == expected

  ups = keyPresses.filter(equalTo(Keys.UP))
  movements = snakeHeadDirection.sampledBy(ups)

  headPosition = movements.scan initialSnakeHeadPosition, (headPosition, movement) ->
    return headPosition.add(movement)

  return headPosition

snake = (width, height, keyPresses) ->
  initialPosition = Vector(3, 5)
  initialDirection = Vector(0,-1)
  headDirection = snakeHeadDirection(initialDirection, keyPresses)
  headPosition = snakeHeadPosition(initialPosition, headDirection, keyPresses)

  snakeRenderData = Bacon.combineTemplate
    head: headPosition # (Stream/property of) a vector
    tail: Bacon.constant([]) # (Steam/property of) a list of vectors, can include head
    food: null # (Stream/property of) a Vector, possibly null

  return snakeRenderData

module.exports = {snake, snakeHeadPosition}
