{Grid, Node} = require( './util/pathfindingWarp')
{ConstructionSite} = require('./construction')
{Pos} = require('./util/helper')
#
# postion info store in the room [x][y]:ref-object
#
class Room
  constructor:(mapGener,@name, @_map) ->
    @_grid = new Grid(mapGener.getMatrix())
    @_posRef
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


  #_checkPos


Room.serializePath = (pathArray) ->
  pathArray.toString()

Room.deserializePath = (pathStr) ->
  Array.parse(pathStr)


