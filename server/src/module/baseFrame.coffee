{_} = require('undersocre')
Event = require('events')
Util = require('util')

class BaseFrame extends Frame
  constructor:(@owner,@id,@cfg) ->
    @_tickStore
    @_scheduledAction
    Event.call(@)

  _tick:() ->
    @_tickStore -= 1
    @_scheduledAction()

  _scheduleActionWithCD:(tick,checker,func, args) ->
    cRet = checker(args)
    return cRet unless cRet is OK
    @_tickStore = tick
    @_scheduledAction =  () =>
      return _ERR_CD unless @_tickStore is 0
      @_tickStore = tick
      return func(args)
  
  _onDamage:(damageValue) ->
    activeModule = _.find(@slots, (module) -> module._isAlive())
    return ERR_NO_BODYPART unless activeModule?
    return activeModule._onDamage(damageValue)

  isMine:(owner) -> owner is @owner
  _getFrameType:()-> ""
  _isSameFrame:(frame) -> @id is frame?.id
    
Util.inherits(BaseFrame, Event)
