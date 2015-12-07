Pf = require( 'pathfinding')
{_} = require('lodash')

Node = Pf.Node
Grid = Pf.Grid
class MyNode extends Node
  constructor:(x,y,walkable)->
    super(x,y,walkable)
    @ref = []
    @bak = true
  bind:(ref)->
    if _.isNull(ref)
      old = @ref
      @ref = []
    else
      if _.isNumber(ref)
        layer = ref
        ref = null
      else
        layer = ref._layer
      old = @ref[layer]
      @ref[layer] = ref
      @ref.pop() if not ref? and layer is @ref.length-1
    if @ref.length >0
      Object.defineProperty(@, 'walkable', {
        get : () -> @ref[@ref.length-1]._walkable() ,
        set : (val) ->@ref[@ref.length-1]._setwlkable(val),
        enumerable : true,
        configurable : true
       })
    else
      Object.defineProperty(@, 'walkable', {
        value:@bak
        writable:true,
        configurable: true,
        enumerable:true,
      })
      #@walkable = @bak
    return old

  _setwlkable:(@walkable) ->
    @bak=@walkable

  hasType:(type) -> _.findIndex(@ref,(elm)->elm._getFrameType() is type) isnt -1

Pf.Node = MyNode

class MyGrid extends Grid
  _buildNodes:(width,height,matrix)->
    nodes = new Array(height)
    for i in [0..height-1]
      nodes[i] = new Array(width)
      for j in [0..width-1]
        nodes[i][j] = new MyNode(j, i)


    return nodes unless matrix?

    if matrix.length isnt height || matrix[0].length isnt width
      throw new Error('Matrix size does not fit')

    for i in [0..height-1]
      for j in [0..width-1]
        if (matrix[i][j])
          # 0, false, null will be walkable
          # while others will be un-walkable
          nodes[i][j]._setwlkable(false)
    return nodes

  clone:() ->
    width = this.width
    height = this.height
    thisNodes = this.nodes
    newGrid = new Grid(width, height)
    newNodes = new Array(height)
    for i in [0..height-1]
      newNodes[i] = new Array(width)
      for j in [0..width-1]
        n = thisNodes[i][j]
        #don't copy ref, it's more easy to rewrite walkable property
        newNodes[i][j] = new MyNode(j, i, n.walkable)
 
    newGrid.nodes = newNodes

    return newGrid
  setWalkableAt:(x,y,walkable) ->
    @nodes[y][x]._setwlkable(walkable)

  forEach:(func)->
    for i in [0..@height-1]
      for j in [0..@width-1]
          func(nodes[i][j],j,i)


Pf.Grid = MyGrid
module.exports=Pf

