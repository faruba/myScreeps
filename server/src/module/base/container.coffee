{Error} = require('../../util/helper')
{Module} = require('../module')
class Container extends Module
  constructor: (@_store, @cfg) ->
    super(@cfg,@_store)
    @key='mp'
    @cap='mpMax'

  _attach:(frame)->
    super(frame)
    @_store.set(@key,0) unless @_store.get(@key)?
    @_store.append(@cap,@cfg.capacity)

  _detach:() ->
    super()
    @_store.set(@cap, @carryCapacity() - @cfg.capacity)
    @_store.set(@key,Math.min(@carry(),@carryCapacity()))

  _getType : () -> return ModeType.Type_Container
  _put: (wantPut) ->
    return Error(_Err_should_positive) unless wantPut > 0
    putMax = @_capacityLeft()
    canPut = Math.min(putMax,wantPut)
    @_store.append(@key, canPut)
    return wantPut - canPut

  _get: (need) ->
    have = @carry()
    canGive = Math.min(have,need)
    @_store.sub(@key,canGive)
    return canGive

  _isFull : ()  -> return @_capacityLeft() is 0
  _capacityLeft: () ->
    return @carryCapacity() - @carry()


  carry:() -> @_store.get(@key)
  carryCapacity:()->@_store.get(@cap)

exports.Container = Container


