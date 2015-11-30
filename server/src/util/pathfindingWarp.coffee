Pf = require( 'pathfinding')

Node = Pf.Node
Grid = Pf.Grid
class MyNode extends Node
  constructor:(x,y,walkable)->
    super(x,y,walkable)
    @ref=null
    @bak = true
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
      Object.defineProperty(@, 'walkable', {
        writable:true,
        configurable: true,
        enumerable:true,
      })
      @walkable = @bak
      console.log('======', @walkable, @bak)
    return old

  _setwlkable:(@walkable) ->
    @bak=@walkable

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
        newNodes[i][j] = new MyNode(j, i, thisNodes[i][j].walkable)
 
    newGrid.nodes = newNodes

    return newGrid
setWalkableAt:(x,y,walkable) ->
  @nodes[y][x]._setwlkable(walkable)


Pf.Grid = MyGrid
module.exports=Pf

