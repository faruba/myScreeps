{Container} = require('../src/room')
{Data} = require('../src/util/helper')
{eql, equal, runTestSuit} = require('../src/util/testTool')
{Grid,Node} = require('../src/util/pathfindingWarp')

class W
  constructor:(@w)->
    @w
  _walkable:()-> @w
  _setwlkable:(v) -> @w=v
walk = new W(true)
nwalk = new W(false)
gdata = null
testSuitList =[
  {
    describe: 'Room',
    its : [
      {
        it: '1 test Node',
        init : () ->
          return new Grid([
            [1,0,0,0,0],
            [0,1,0,0,0],
            [0,0,0,0,0],
            [0,0,0,1,0],
            [0,0,0,0,1]])
        ,
        do:(g, {act,x,y,value}) ->
          node = g.getNodeAt(x,y)
          ret = OK
          switch act
            when 'bw' then ret = node.bind(value)
            when 'cw' then ret = g.isWalkableAt(x,y)
            when 'sw'
              g.setWalkableAt(x,y,value)
              ret = g.isWalkableAt(x,y)
          return ret
        ,
        assert : eql
        tests : [
          {input: {act:'cw',x:0,y:0}, expect :false},
          {input: {act:'cw',x:2,y:2}, expect :true},
          {input: {act:'bw',x:2,y:2,value:nwalk}, expect :null},
          {input: {act:'cw',x:2,y:2}, expect :false},
          {input: {act:'bw',x:2,y:2,value:walk}, expect :nwalk},
          {input: {act:'cw',x:2,y:2}, expect :true},
          {input: {act:'sw',x:2,y:2,value:false}, expect :false},
          {input: {act:'sw',x:2,y:2,value:true}, expect :true},
        ]
      },
      
    ]
  },

]


runTestSuit(testSuitList )
