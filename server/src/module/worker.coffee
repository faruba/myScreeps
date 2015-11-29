{Error} = require('../../util/helper')
{Module} = require('../module')

class Worker extends Module
  constructor: (_store, @cfg) ->
    super(@cfg,_store)

  _attach:(@frame)->
    super(@frame)
    @_store.set(@key,0) unless @_store.get(@key)?
    @_store.append(@cap,@cfg.capacity)

  _detach:() ->
    super()
    @_store.set(@cap, @carryCapacity() - @cfg.capacity)
    @_store.set(@key,Math.min(@carry(),@carryCapacity()))

  _doJob:(cost, target) ->
    
