{gMap} = require('../map')
{genFlagId} = require('./helper')
{_} = require('lodash')
class RoomPosition
  constructor:(@x,@y,@roomName)->
    @_room = gMap._getRoom(@roomName)

  __createConstructionSite:(player,type) ->
    return @_room.createConstructionSite(@x,@y,type)
  __createFlag:(player,name =genFlagId(),color = COLOR_WHITE) ->
    return @_room.createFlag(@x,@y,name,color)
  __findClosestByPath:(player,typeOrObject,{filter,algorithm='dijkstra'}=opt)->
    objs = @_filterObject(typeOrObject,opt)
    pathRet = _.map(objs, (obj) =>@_room.findPath(@,obj.position,{}))
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
  __findPathTo:(player,x, y, {filter,algorithm='dijkstra'}=opt) ->
  __findPathTo:(player,target, {filter,algorithm='dijkstra'}=opt) ->
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

  _filterObject:(typeOrObject,{filter,algorithm='dijkstra'}=opt)->
    if _.isObject(typeOrObject)
      objs = typeOrObject
    else
      objs = @_room.find(typeOrObject,filter)
    return objs
  _isSame:({x,y,roomName}) ->
    return @x is x and @y is y and @roomName is roomName



exports.RoomPosition =  RoomPosition
