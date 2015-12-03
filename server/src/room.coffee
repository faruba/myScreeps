{Grid,AStarFinder} = require( './util/pathfindingWarp')
{ConstructionSite} = require('./construction')
{Pos} = require('./util/helper')
{_} = require('lodash')
#
# postion info store in the room [x][y]:ref-object
#
gAStartFinder = new AStarFinder({allowDiagonal:true,dontCrossCorners:true})
class Room
  constructor:(mapGener,@name, @_map,@owner) ->
    @_grid = new Grid(mapGener())
    @_posRef
    @_spawns = []
    @_creeps = []
    @_structures = []

    @storage = []
    @memory = {}
    @_genIDVal = null

  createConstructionSite: (x,y,structType) ->


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
  __find:(palyer,type, [opts])->
  __findExitTo:(palyer,room)->
  __findPath:(palyer,fromPos, toPos
    ,{avoid,ignore})->
      #TODO some opt
      tempGrid = @_grid.clone()
      avoid?.forEach(({x,y}) ->tempGrid.setWalkableAt(x,y,false))
      ignore?.forEach(({x,y}) ->tempGrid.setWalkableAt(x,y,true))
      return gAStartFinder.findPath(fromPos.x,fromPos.y, toPos.x,toPos.y,tempGrid)

  __getPositionAt:(palyer,x, y)->
    if @_grid.getNodeAt(x,y)?
      return new RoomPosition(x,y,@name)
    return null
  __lookAt:(palyer,x, y)->
    @getPositionAt(x,y).ref
  __lookAt:(palyer,target)->
  __lookAtArea:(palyer,top, left, bottom, right)->
  __lookForAt:(palyer,type, x, y)->
  __lookForAt:(palyer,type, target)->
  __lookForAtArea:(palyer,type, top, left, bottom, right)->

  _getSource:(type) ->
    switch(type)
      when FIND_CREEPS then ret=@_creeps
      when FIND_MY_CREEPS then ret=_.filter(@_creeps,@_isMine)
      when FIND_HOSTILE_CREEPS then ret=_.filter(@_creeps,_.negate(@_isMine))
      when FIND_MY_SPAWNS then ret=@_spawns
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
  _isMine:(obj)->
    obj.isMine(@owner)
#_checkPos


Room.serializePath = (pathArray) ->
  pathArray.toString()

Room.deserializePath = (pathStr) ->
  Array.parse(pathStr)

Room.distanceP2 = (pos1, pos2) ->
  Math.pow(pos1.x-pos2.x,2) + Math.pow(pos1.y-pos2.y,2)

exports.Room = Room
