{_} = require('undersocre')

class BaseFrame extends Frame
  constructor:() ->
    @_tickStore
    @_scheduledAction

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
    return 
    
