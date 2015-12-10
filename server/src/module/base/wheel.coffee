{bindProperty} = require('../../util/helper')
{Module} = require('../module')
class Wheel extends Module
  constructor: (_store, cfg) ->
    super(_store,cfg)
    bindProperty(@,'whCnt', _store,'wheel',0)
    bindProperty(@,'plant', _store,'wheel')
    bindProperty(@,'target',_store,'wheel')
    bindProperty(@,'tick',  _store,'wheel',0)

  _attach:(@frame)->
    super(@frame)
    @whCnt = @whCnt+1

  _detach:() ->
    super()
    @whCnt = @whCnt-1

  _doJob:(target) ->
    return OK if @frame._isSame(target)
    if not (@target? and @target._isSame(target))
      ret = @_caculatePath(target)
      return ret unless ret is OK
    @_doCount()
    return OK
 
  _caculatePath:(target)->
    @target = target
    @plant = @frame.findPathTo(target)
    @plant.shift()
    if @plant.length <= 0
      return ERR_INVALID_TARGET
    return OK

  _doCount:() ->
    if @tick >= @cfg.progress
      step = @plant[0]
      return unless step?
      ret = @frame._moveTo({x:step[0],y:step[1]})
      switch ret
        when TEMP_UNWALKABLE then @tick -= 10
        when UNWALKABLE then @_caculatePath(@target)
        when OK
          @tick = 0
          @plant.shift()
      return ret
    else
      @tick += @_caculateProgress()
      return OK

  _caculateProgress:() -> @cfg.proAppend
      
      
	getType : () -> return ModeType.TType_Wheel

exports.Wheel = Wheel


