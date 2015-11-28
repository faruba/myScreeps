class Wheel extends Module
	constructor: (speed =5, direction = Direction.North, pos = new P()) ->
		super()
		@speed = speed
		@direction = direction
		@pos = pos

	getType : () -> return ModeType.TType_Wheel
	slowDown: (percent) ->
		percent = boundaries(0,100,percent)
		@speed = Math.floor(@speed * (100 - percent) / 100)


	getPos :() -> return @pos
	forward: () ->
		move = MoveMitrix[@direction].scale(@speed)
		@pos.add(move) if @canMove(move)

	backward: () ->
		move = MoveMitrix[opposite(@direction)].scale(@speed)
		@pos.add(move) if @canMove(move)

	turnTo: (@direction) ->
	
	canMove: (offset) ->
		return isValidatePos(@pos.offset(offset))


exports.Wheel = Wheel


