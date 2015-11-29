{Container} = require('../src/module/base/container')
{Data} = require('../src/util/helper')
{eql, equal, runTestSuit} = require('../src/util/testTool')

gdata = null
testSuitList =[
  {
    describe: 'Container',
    its : [
      {
        it: '1 simple get and set and default',
        init : () ->
          gdata = new Data()
          c = new Container(gdata,{capacity:10, name:'c1', maxHp:10})
          c._attach(null)
          return c
        ,
        do:(c, {act,value}) ->
          #console.log(c,'----')
          switch act
            when 'put' then ret = c._put(value)
            when 'get' then ret = c._get(value)
          return [c.carry(),c.carryCapacity(),ret]
        ,
        assert : eql
        tests : [
          {input: {act:'get',value:1}, expect :[0,10,0]},
          {input: {act:'put',value:2}, expect :[2,10,0]},
          {input: {act:'put',value:2}, expect :[4,10,0]},
          {input: {act:'put',value:8}, expect :[10,10,2]},
          {input: {act:'get',value:2}, expect :[8,10,2]},
          {input: {act:'get',value:12}, expect :[0,10,8]},
        ]
      },
      {
        it: '2 2 Continer',
        init : () ->
          gdata = new Data()
          c1 = new Container(gdata,{capacity:10, name:'c1', maxHp:10})
          c2 = new Container(gdata,{capacity:20, name:'c2', maxHp:10})
          c1._attach(null)
          c2._attach(null)
          return c1
        ,
        do:(c, {act,value}) ->
          switch act
            when 'put' then ret = c._put(value)
            when 'get' then ret = c._get(value)
          return [c.carry(),c.carryCapacity(),ret]
        ,
        assert : eql
        tests : [
          {input: {act:'get',value:1}, expect :[0,30,0]},
          {input: {act:'put',value:2}, expect :[2,30,0]},
          {input: {act:'put',value:2}, expect :[4,30,0]},
          {input: {act:'put',value:8}, expect :[12,30,0]},
          {input: {act:'put',value:20}, expect :[30,30,2]},
          {input: {act:'get',value:2}, expect :[28,30,2]},
          {input: {act:'get',value:30}, expect :[0,30,28]},
        ]
      },
      {
        it: '2 2 Continer',
        init : () ->
          gdata = new Data()
          c1 = new Container(gdata,{capacity:10, name:'c1', maxHp:10})
          c2 = new Container(gdata,{capacity:20, name:'c2', maxHp:10})
          c1._attach(null)
          c2._attach(null)
          return c1
        ,
        do:(c, {act,value}) ->
          switch act
            when 'put' then ret = c._put(value)
            when 'get' then ret = c._get(value)
            when 'dt'
              c._detach()
              ret = null
          return [c.carry(),c.carryCapacity(),ret]
        ,
        assert : eql
        tests : [
          {input: {act:'put',value:25}, expect :[25,30,0]},
          {input: {act:'dt'}, expect :[20,20,null]},
          {input: {act:'put',value:8}, expect :[20,20,8]},
          {input: {act:'get',value:2}, expect :[18,20,2]},
        ]
      }
    ]
  },

]


runTestSuit(testSuitList )
