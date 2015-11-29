{Data} = require('../src/util/helper')
{eql, equal, runTestSuit} = require('../src/util/testTool')

gdata = 0

gd1 = () ->
  gdata +=1

gd2 = () ->
  gdata +=2

dataTestFun = (data, {act,key,value,def,isSet}) ->
  switch act
    when 'set' then data.set(key,value)
    when 'get' then data.get(key,def)
    when 'hook' then data.setHook(key, isSet,value)
  return gdata

testSuitList =[
  {
    describe: 'Data',
    its : [
      {
        it: '1 simple get and set and default',
        init : () -> return new Data(),
        do:(data, {act,key,value,def,isSet}) ->
          switch act
            when 'set'
              data.set(key,value)
              return data.get(key,def)
            when 'get' then data.get(key,def)
        ,
        assert : equal
        tests : [
          {input: {act:'set',key:'newKey',value:1,def:null}, expect :1},
          {input: {act:'set',key:'newKey',value:2,def:3}, expect :2},
          {input: {act:'get',key:'n2',value:null,def:null}, expect :null},
          {input: {act:'get',key:'n2',value:null,def:2}, expect :2},
        ]
      },
      {
        it: '2 hooks',
        init : () ->
          gdata = 0
          return new Data()
        ,
        do: dataTestFun,
        assert : equal
        tests : [
          #no hook yet
          {input: {act:'set',key:'newKey',value:1,def:null}, expect :0},
          {input: {act:'hook',isSet:true,value:gd1, key:'newKey'}, expect :0},
          {input: {act:'set',key:'newKey',value:1,def:null}, expect :1, lable: 'only set change data'},
          {input: {act:'get',key:'newKey',value:null,def:2}, expect :1},
# get hook
          {input: {act:'hook',isSet:false, key:'newKey',value:gd2}, expect :1},
          {input: {act:'set',key:'newKey',value:1,def:null}, expect :2},
          {input: {act:'get',key:'newKey',value:null,def:2}, expect :4},
# same function will not add again
          {input: {act:'hook',isSet:true,value:gd1, key:'newKey'}, expect :4},
          {input: {act:'set',key:'newKey',value:1,def:null}, expect :5},
          {input: {act:'get',key:'newKey',value:null,def:2}, expect :7},
# add other function .attation here, although same meaning, still not "same func"
          {input: {act:'hook',isSet:true, key:'newKey',value:()-> gdata+=1}, expect :7},
          {input: {act:'set',key:'newKey',value:1,def:null}, expect :9},
        ]
      },
      {
        it: '3 append',
        init : () -> return new Data(),
        do:(data, {act,key,value}) ->
          switch act
            when 'a'
              data.append(key,value)
              return data.get(key)
            when 's'
              data.sub(key,value)
              return data.get(key)
        ,
        assert : equal
        tests : [
          {input: {act:'a',key:'newKey',value:1}, expect :1},
          {input: {act:'a',key:'newKey',value:2}, expect :3},
          {input: {act:'s',key:'newKey',value:4}, expect :-1},
          {input: {act:'s',key:'n2',value:3}, expect :-3},
        ]
      },

    ]
  },

]


runTestSuit(testSuitList )
