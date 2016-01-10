{gMap} = require('../map')
{genFlagId,ClassWarp} = require('./helper')
{_} = require('lodash')

isSamePos = (pos1,pos2) ->
  return pos1.x is pos2.x \
    and pos1.y is pos2.y \
    and pos1.roomName is pos2.roomName \
    and pos1._layer is pos2._layer

class RoomPosition
  constructor:({@x,@y,@roomName,@_layer})->
    @_room = gMap._getRoom(@roomName)

  __createConstructionSite:(player,type) ->
    return @_room.createConstructionSite(@x,@y,type)
  __createFlag:(player,name =genFlagId(),color = COLOR_WHITE) ->
    return @_room.createFlag(@x,@y,name,color)
  __findClosestByPath:(player,typeOrObject,{filter,algorithm='dijkstra'}=opt)->
    objs = @_filterObject(typeOrObject,opt)
    pathRet = _.map(objs, (obj) =>@_room.findPath(@,obj.position))
    min = Number.MAX_VALUE
    for path,idx in rathRet
      if(path[1] <=min)
        min = path[1]
        ret = objs[idx]
    return ret

  __findClosestByRange:(player,type, {filter,algorithm='dijkstra'}=opt) ->
  __findClosestByRange:(player,objects, {filter,algorithm='dijkstra'}=opt) ->
  __findInRange:(player,type, range, {filter,algorithm='dijkstra'}=opt) ->
  __findInRange:(player,objects, range, {filter,algorithm='dijkstra'}=opt) ->
  #__findPathTo:(player,x, y, opt) ->
  __findPathTo:(player,target, opt) ->
    @_room.findPath(@,target,opt)
  __getDirectionTo:(player,x,y) ->
  __getDirectionTo:(player,target) ->
  __getRangeTo:(player,x,y) ->
  __getRangeTo:(player,target) ->
  __inRangeTo:(player,toPos, range) ->
  __isEqualTo:(player,x,y) ->
  __isEqualTo:(player,target) ->
  __isNearTo:(player,x,y) ->
  __isNearTo:(player,target) ->
  __look:(player) ->
  __lookFor:(player,type) ->

  _filterObject:(typeOrObject,{filter,algorithm='dijkstra'})->
    if _.isObject(typeOrObject)
      objs = typeOrObject
    else
      objs = @_room.find(typeOrObject,filter)
    return objs
  _isSame:(pos) -> isSamePos(@, pos)
  _moveTo:(pos) ->
    ret = @_room._moveTo(@,pos)
    if ret is OK
      @x = pos.x
      @y = pos.y
      if (pos.roomName? and pos.roomName isnt @roomName)
        @roomName = pos.roomName
        @_room = gMap._getRoom(@roomName)

    return ret
  _walkable:() -> false

exports.SerilaziedRoomPos = (pos) -> _.pick(pos,['x','y','roomName','_layer'])
exports.isSamePos = isSamePos
exports.RoomPosition =  ClassWarp("P",RoomPosition)
