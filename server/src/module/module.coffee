{RoomPosition} = require('../util/roomPos')
{boundaries} = require('../util/helper')

class Life extends RoomPosition
  constructor:(@_store, @cfg) ->
    @key = @cfg.name+'.hp'
    @_store.set(@key,@cfg.maxHp)
    @_store.set(LIFE,@cfg.life)

  _onDamage:(damage) ->
    hp = boundaries(0,@cfg.maxHp,@_store.get(@key) - damage)
    @_store.set(@key, hp)
    if(hp <= 0) then @_onDie()

  _isHealthy:()->@_hp >= @cfg.maxHp
  _isAlive:() -> @_hp() > 0
  _hp:() -> @_store.get(@key)
  _tick:(dt,sender) ->
    leftLife = @_store.sub(LIFE,1)
    if leftLife <= 0
      sender.lifeEnd(@)
  
  _onDie:() ->



class Module extends Life
  constructor: (_store,cfg) ->
    super(_store,cfg)
    @frame = null

  _attach : (@frame) ->
  _detach : () -> @frame = null
  _getType : () -> return null
  _action:(target) ->
    return unless @_preCheck(target)
    tp = target._getType()
    cost = @cfg[tp].cost
    if @frame?.carry() >= cost
      @frame._get(cost)
      @_doJob(target,@cfg[tp])
    else
      return Error(ERR_NOT_ENOUGH_ENERGY)
 
  _preCheck:(target) -> return true

exports.Module = Module


class ModeFactory
  constructor:()->
    @modeCfg={}
  registeMode:(cfg) ->
    @modeCfg[cfg.type] = cfg
  getCost:(typeLst) ->
    ret =0
    for type in typeLst
      cfg = @modeCfg[type]
      return null unless cfg?
      ret += cfg.cost
    return ret

  createMode:(type,  creator) ->
    cfg = @modeCfg[type]
    return null unless cfg?
    return new cfg.create(creator,cfg.cfg)

exports.ModeFactory = ModeFactory
