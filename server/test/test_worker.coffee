require('../src/define')
{Worker} = require('../src/module/base/worker')
{Data} = require('../src/util/helper')
{eql, equal, runTestSuit} = require('../src/util/testTool')

cfg = {
  1:{cost:0,progress:1}
  2:{cost:2,progress:20}
}
resource ={
  _getType:() ->1
  _process:(n,source) ->
    source.res+=n
    return OK
}
heal ={
  _getType:() ->2
  _process:(n,source) ->
    source.hp +=n
    return OK
}

class F
  constructor:()->
    @hp=0
    @res =0
  carry:() ->@res
  _get:(n) -> @res -=n

testSuitList =[
  {
    describe: 'Worker',
    its : [
      {
        it: '1 run worker',
        init : () ->
          gdata = new Data()
          c = new Worker(gdata,cfg)
          f = new F()
          c._attach(f)
          return {c,f}
        ,
        do:({c,f}, {act,target}) ->
          #console.log(c,'----')
          switch act
            when 'd' then ret = c._action(target)
            when 'get' then ret = c._get(target)
          return [f.hp,f.res,ret]
        ,
        assert : eql
        tests : [
          {input: {act:'d',target:heal}, expect :[0,0,Error(ERR_NOT_ENOUGH_ENERGY)]},
          {input: {act:'d',target:resource}, expect :[0,1,OK]},
          {input: {act:'d',target:heal}, expect :[0,1,Error(ERR_NOT_ENOUGH_ENERGY)]},
          {input: {act:'d',target:resource}, expect :[0,2,OK]},
          {input: {act:'d',target:heal}, expect :[20,0,OK]},
        ]
      },
      #{
      #  it: '2 run 2 workers',
      #  init : () ->
      #    gdata = new Data()
      #    c = new Worker(gdata,cfg)
      #    c2 = new Worker(gdata,cfg)
      #    f = new F()
      #    c._attach(f)
      #    c2._attach(f)
      #    return {c,f}
      #  ,
      #  do:({c,f}, {act,target}) ->
      #    #console.log(c,'----')
      #    switch act
      #      when 'd' then ret = c._action(target)
      #      when 'get' then ret = c._get(target)
      #    return [f.hp,f.res,ret]
      #  ,
      #  assert : eql
      #  tests : [
      #    {input: {act:'d',target:heal}, expect :[0,0,Error(ERR_NOT_ENOUGH_ENERGY)]},
      #    {input: {act:'d',target:resource}, expect :[0,2,OK]},
      #    {input: {act:'d',target:heal}, expect :[0,2,Error(ERR_NOT_ENOUGH_ENERGY)]},
      #    {input: {act:'d',target:resource}, expect :[0,4,OK]},
      #    {input: {act:'d',target:heal}, expect :[40,0,OK]},
      #  ]
      #},
    ]
  },

]


runTestSuit(testSuitList )
