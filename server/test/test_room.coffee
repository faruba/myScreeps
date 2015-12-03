{Container} = require('../src/room')
{Data} = require('../src/util/helper')
{eql, equal, runTestSuit} = require('../src/util/testTool')
{Grid,Node} = require('../src/util/pathfindingWarp')

class W
  constructor:(@w,@_layer)->
  _walkable:()-> @w
  _setwlkable:(v) -> @w=v
walk = new W(true,0)
nwalk = new W(false,0)
walkL2 = new W(true,1)
walkL3 = new W(true,2)
nwalkL2 = new W(false,1)
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
          {input: {act:'bw',x:0,y:0,value:null}, expect :[]},
          {input: {act:'cw',x:0,y:0}, expect :false},
          {input: {act:'bw',x:0,y:0,value:walk}, expect :null},
          {input: {act:'cw',x:0,y:0}, expect :true},
          {input: {act:'bw',x:0,y:0,value:null}, expect :[walk]},
          {input: {act:'cw',x:0,y:0}, expect :false},
          #bind second layer
          {input: {act:'cw',x:0,y:1}, expect :true},
          {input: {act:'bw',x:0,y:1,value:nwalk}, expect :null},
          {input: {act:'cw',x:0,y:1}, expect :false},
          {input: {act:'bw',x:0,y:1,value:walkL2}, expect :null},
          {input: {act:'cw',x:0,y:1}, expect :true},
          {input: {act:'bw',x:0,y:1,value:nwalkL2}, expect :walkL2},
          {input: {act:'cw',x:0,y:1}, expect :false},
          {input: {act:'bw',x:0,y:1,value:1}, expect :nwalkL2},
          {input: {act:'cw',x:0,y:1}, expect :false},
          {input: {act:'bw',x:0,y:1,value:null}, expect :[nwalk]},
        ]
      },
      
    ]
  },

]


runTestSuit(testSuitList )
