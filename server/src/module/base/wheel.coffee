class Wheel extends Module
  constructor: (_store, cfg) ->
    super(cfg,_store)
    @key ='whCnt'
    @plant = null

  _attach:(@frame)->
    super(@frame)
    @_store.append(@key,1)

  _detach:() ->
    super()
    @_store.sub(@key,1)

  _doJob:(target) ->
    if not @dest._isSame(target)
      @_caculatePath(target)
    @_doCount()
 
  _caculatePath:(target)->
    @dest = target
    @plant = @findPathTo(target)
	getType : () -> return ModeType.TType_Wheel

exports.Wheel = Wheel


