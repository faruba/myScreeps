{Error} = require('../../util/helper')
{Module} = require('../module')

class Worker extends Module
  constructor: (_store, @cfg) ->
    super(@cfg,_store)
    @key ='wkCnt'

  _attach:(@frame)->
    super(@frame)
    @_store.append(@key,1)

  _detach:() ->
    super()
    @_store.sub(@key,1)

  _doJob:(target) ->
    mul = @_store.get(@key)
    tp = target._getType()
    cost = @cfg[tp].cost*mul
    if @frame.carry() >= cost
      @frame._get(cost)
      target._process(@cfg[tp].progress*mul,@frame)
    else
      return Error(ERR_NOT_ENOUGH_ENERGY)
    
exports.Worker = Worker
