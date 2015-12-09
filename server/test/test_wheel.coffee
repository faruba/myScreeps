{Room} = require('../src/room')
{Wheel} = require('../src/module/base/wheel')
{Data} = require('../src/util/helper')
{RoomPosition} = require('../src/util/roomPos')
{eql, equal, runTestSuit} = require('../src/util/testTool')
{_} = require('lodash')
{spy} = require('sinon')

class W
  constructor:(@w,@_layer)->
  _walkable:()-> @w
  _setwlkable:(v) -> @w=v
walk = new W(true,0)
nwalk = new W(false,0)
walkL2 = new W(true,1)
walkL3 = new W(true,2)
nwalkL2 = new W(false,1)

class FakeFrame extends RoomPosition
  constructor:(cfg)->
    super(cfg)
  _isSameFrame:(ref) ->return @ is ref
pos1 = new FakeFrame({x:2,y:2,roomName:"test",layer:1})
d = new Data()
w = new Wheel(d,{progress:100,proAppend:10})
fcheck = null
before(() ->
  fcheck = spy(w,'_caculatePath')
)
after(()->
  fcheck.restore()
)

testSuitList =[
  {
    describe: 'Room',
    its : [
      {
        it: '1 test move',
        init : () ->
          r= new Room(
            () ->
              [
                [1,0,0,0,0],
                [1,1,1,0,0],
                [0,0,0,0,0],
                [0,1,1,1,1],
                [0,0,0,0,1]
              ]
            ,"name",r,"ower")
          frame = new  FakeFrame({x:1,y:0,roomName:"test",layer:1})
          r.getPositionAt(1,0).bind(frame)
          frame._room = r
          w._attach(frame)
          return w
        ,
        do:(w, {act,pos,times}) ->
          ret = OK
          console.log('-----begin')
          switch act
            when 'g'
              for i in [1..times]
                ret = w._doJob(pos)
            when 'ct' then return fcheck.callCount
          #print(w)
          return {ret:ret,t:w.tick,tar:w.target,p:w.plant,c:[w.frame.x,w.frame.y]}
        ,
        assert : eql
        tests : [
          # set target
          {input: {act:'g',pos:pos1,times:1},
          expect :{
            p:[[2,0],[3,0],[3,1],[3,2],[2,2]],
            t:10,tar:pos1,ret:OK,c:[1,0]
          }},
          # tick 
          {input: {act:'g',pos:pos1,times:8},
          expect :{
            p:[[2,0],[3,0],[3,1],[3,2],[2,2]],
            t:90,tar:pos1,ret:OK,c:[1,0]
          }},
          #tick
          {input: {act:'g',pos:pos1,times:1},
          expect :{
            p:[[2,0],[3,0],[3,1],[3,2],[2,2]],
            t:100,tar:pos1,ret:OK,c:[1,0]
          }},
          #move
          {input: {act:'g',pos:pos1,times:1},
          expect :{
            p:[[3,0],[3,1],[3,2],[2,2]],
            t:0,tar:pos1,ret:OK,c:[2,0]
          }},
          ## call count
          {input: {act:'ct'}, expect :1},
        ]
      },
    ]
  },

]


runTestSuit(testSuitList )
