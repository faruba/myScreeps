{Grid,AStarFinder} = require( './util/pathfindingWarp')
{ConstructionSite} = require('./construction')
{myGc,Pos,ClassWarp} = require('./util/helper')
{_} = require('lodash')
weak = require('weak')
#
# postion info store in the room [x][y]:ref-object
#
gAStartFinder = new AStarFinder({allowDiagonal:true,dontCrossCorners:true})
class Room
  constructor:(mapGener,@name, @_map,@owner) ->
    @_grid = new Grid(mapGener())
    @_posRef
    @_objs ={
      spawns : {}
      creeps : {}
      structures : {}
      storage : {}
    }
    @memory = {}
    @_genIDVal = null
    @_refs ={
      spawns : {}
      creeps : {}
      structures : {}
      storage : {}
    }
  _getID:() ->
    ret = if @_genIDVal then @_genIDVal else @_randoomID()
    @_genIDVal = null
    return ret
  _randoomID:() ->
    ""

  __createConstructionSite:(palyer,x, y, structureType)->
  __createConstructionSite:(palyer,pos, structureType)->
    pos.createConstructionSite(palyer,structureType)
  __createFlag:(palyer,x, y, name=genFlagId(), color=COLOR_WHITE)->
  __createFlag:(palyer,pos, name=genFlagId(), color=COLOR_WHITE)->
    pos.createFlag(palyer,name,color)

  _createFrame
  __find:(palyer,type, [opts])->
  __findExitTo:(palyer,room)->
  __findPath:(palyer,fromPos, toPos
    ,{avoid=[],ignore=[],ignoreCreeps=true}={})->
      #TODO some opt
      tempGrid = @_grid.clone()
      if ignoreCreeps
        tempGrid.forEach((node) ->
          if node.hasType("creep")
            node._setWalkable(false))
      avoid?.forEach(({x,y}) ->tempGrid.setWalkableAt(x,y,false))
      ignore?.forEach(({x,y}) ->tempGrid.setWalkableAt(x,y,true))
      return gAStartFinder.findPath(fromPos.x,fromPos.y, toPos.x,toPos.y,tempGrid)

  __getPositionAt:(palyer,x, y)-> @_grid.getNodeAt(x,y)
  __lookAt:(player,targetOrX, y)->
    if _.isObject(targetOrX)
      x = targetOrX.x
      y = targetOrX.y
    else
      x = targetOrX
    @__getPositionAt(player,x,y)?.ref
  __lookAtArea:(palyer,top, left, bottom, right)->
  __lookForAt:(palyer,type, x, y)->
  __lookForAt:(palyer,type, target)->
  __lookForAtArea:(palyer,type, top, left, bottom, right)->

  _getSource:(type) ->
    switch(type)
      when FIND_CREEPS then ret=@_refs.creeps
      when FIND_MY_CREEPS then ret=_.filter(@_refs.creeps,@_isMine)
      when FIND_HOSTILE_CREEPS then ret=_.filter(@_refs.creeps,_.negate(@_isMine))
      when FIND_MY_SPAWNS then ret=@_refs.spawns
      when FIND_HOSTILE_SPAWNS then ret={}
      when FIND_SOURCES then ret={}
      when FIND_SOURCES_ACTIVE then ret={}
      when FIND_DROPPED_ENERGY then ret={}
      when FIND_STRUCTURES then ret={}
      when FIND_MY_STRUCTURES then ret={}
      when FIND_HOSTILE_STRUCTURES then ret={}
      when FIND_FLAGS then ret={}
      when FIND_CONSTRUCTION_SITES then ret={}
      when FIND_MY_CONSTRUCTION_SITES then ret={}
      when FIND_HOSTILE_CONSTRUCTION_SITES then ret={}
      when FIND_EXIT_TOP then ret={}
      when FIND_EXIT_RIGHT then ret={}
      when FIND_EXIT_BOTTOM then ret={}
      when FIND_EXIT_LEFT then ret={}
      when FIND_EXIT then ret={}
    
    return ret
  _isMine:(obj)-> obj.isMine(@owner)

  _moveTo:(obj,{x,y})->
    to= @getPositionAt(x,y)
    return UNWALKABLE unless to.walkable
    if @_leave(obj)
      @_enter(obj,x,y)
      return OK
    return UNKNOW

  _leave:(obj)->
    from = @getPositionAt(obj.x,obj.y)
    from.unbind(obj)

  _enter:(obj, x,y)->
    to= @getPositionAt(x,y)
    return UNWALKABLE unless to.walkable
    to.bind(obj)

  _onBirth:(obj) ->
    {_obj,_ref} = @_getStorageByType(obj._getFrameType())
    return UNKNOW if (not _obj?) or _obj[obj.id]?
    _obj[obj.id] = obj
    _ref[obj.id] = weak(obj)
    return _ref[obj.id]

  _onDeath:(obj) ->
    {_obj,_ref} = @_getStorageByType(obj._getFrameType())
    id = obj.id
    _ref[id] = null
    _obj[id] = null
    myGc()
    
  _getStorageByType:(type) ->
    switch type
      when STRUCTURE_SPAWN then where = 'spawns'
      when STRUCTURE_EXTENSION,  STRUCTURE_RAMPART, \
        STRUCTURE_ROAD, STRUCTURE_LINK, STRUCTURE_WALL, \
        STRUCTURE_KEEPER_LAIR, STRUCTURE_CONTROLLER then where = 'structures'
      when STRUCTURE_STORAGE then where = 'storage'
      when FRAME_TYPE_SCREEP then where = 'creeps'
      else where = ''
    return {_obj:@_objs[where], _ref:@_refs[where]}


#_checkPos


Room.serializePath = (pathArray) ->
  pathArray.toString()

Room.deserializePath = (pathStr) ->
  Array.parse(pathStr)

Room.distanceP2 = (pos1, pos2) ->
  Math.pow(pos1.x-pos2.x,2) + Math.pow(pos1.y-pos2.y,2)

exports.Room = ClassWarp("P",Room)
