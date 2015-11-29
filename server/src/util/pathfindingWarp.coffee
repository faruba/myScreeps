Pf = require( 'pathfinding')

Node = Pf.Node
Grid = Pf.Grid
class MyNode extends Node
  constructor:(x,y,walkable)->
    super(x,y,walkable)
    @ref=null
  bind:(ref)->
    old = @ref
    @ref = ref
    if ref?
      Object.defineProperty(@, 'walkable', {
        get : () -> @ref._walkable() ,
        set : (val) ->@ref._setwlkable(val),
        enumerable : true,
        configurable : true
       })
    else
      Object.defineProperty(@, 'walkable', null)
      @walkable = true
    return old

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
          nodes[i][j].walkable = false
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
        newNodes[i][j] = new MyNode(j, i, thisNodes[i][j].walkable)
 
    newGrid.nodes = newNodes

    return newGrid


Pf.Grid = MyGrid
module.exports=Pf

