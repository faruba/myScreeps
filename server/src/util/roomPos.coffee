{gMap} = require('../map')
{genFlagId} = require('./helper')
class RoomPosition
  constructor:(@x,@y,@roomName)->
    @_room = gMap._getRoom(@roomName)

  createConstructionSite:(type) ->
    return ERR_INVALID_ARGS unless @_room?
    return @_room.createConstructionSite(@x,@y,type)
  createFlag:(name =genFlagId(),color = COLOR_WHITE) ->
    return ERR_INVALID_ARGS
    return @_room.createFlag(@x,@y,name,color)

  findClosestByPath:(type,opt={filter,algorithm})->
    return ERR_INVALID_ARGS unless @_room?

  findClosestByPath:(objects, [opts]) ->
    return ERR_INVALID_ARGS unless @_room?
  findClosestByRange:(type, [opts]) ->
    return ERR_INVALID_ARGS unless @_room?
  findClosestByRange:(objects, [opts]) ->
    return ERR_INVALID_ARGS unless @_room?
  findInRange:(type, range, [opts]) ->
    return ERR_INVALID_ARGS unless @_room?
  findInRange:(objects, range, [opts]) ->
    return ERR_INVALID_ARGS unless @_room?
  findPathTo:(x, y, [opts]) ->
    return ERR_INVALID_ARGS unless @_room?
  findPathTo:(target, [opts]) ->
    return ERR_INVALID_ARGS unless @_room?
  getDirectionTo:(x,y) ->
    return ERR_INVALID_ARGS unless @_room?
  getDirectionTo:(target) ->
    return ERR_INVALID_ARGS unless @_room?
  getRangeTo:(x,y) ->
    return ERR_INVALID_ARGS unless @_room?
  getRangeTo:(target) ->
    return ERR_INVALID_ARGS unless @_room?
  inRangeTo:(toPos, range) ->
    return ERR_INVALID_ARGS unless @_room?
  isEqualTo:(x,y) ->
    return ERR_INVALID_ARGS unless @_room?
  isEqualTo:(target) ->
    return ERR_INVALID_ARGS unless @_room?
  isNearTo:(x,y) ->
    return ERR_INVALID_ARGS unless @_room?
  isNearTo:(target) ->
    return ERR_INVALID_ARGS unless @_room?
  look:() ->
    return ERR_INVALID_ARGS unless @_room?
  lookFor:(type) ->
    return ERR_INVALID_ARGS unless @_room?


