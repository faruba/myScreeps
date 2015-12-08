{Room} = require('../src/room')
{Wheel} = require('../src/module/base/wheel')
{Data} = require('../src/util/helper')
{RoomPosition} = require('../src/util/roomPos')
{eql, equal, runTestSuit} = require('../src/util/testTool')
{_} = require('lodash')

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
          d = new Data()
          frame = new RoomPosition({x:1,y:0,roomName:"test",layer:1})
          #print(_.functions(frame))
          frame._room = r
          w = new Wheel(d,{progress:100,proAppend:10})
          w._attach(frame)
          return w
        ,
        do:(w, {act,x1,y1,times}) ->
          ret = OK
          switch act
            when 'g'
              for i in [1..times]
                console.log("===run ",i)
                ret = w._doJob({x:x1,y:y1,roomName:"test"})
          #print(w)
          return {ret:ret,t:w.tick,tar:w.target,p:w.plant}
        ,
        assert : eql
        tests : [
          {input: {act:'g',x1:2,y1:2,times:1},
          expect :{
            p:[[1,0],[2,0],[3,0],[3,1],[3,2],[2,2]],
            t:10,tar:{x:2,y:2},ret:OK
          }},
        ]
      },
    ]
  },

]


runTestSuit(testSuitList )
