class Life
  constructor:(@data, @cfg) ->
    @key = @cfg.name+'.hp'
    @data.set(@key,@cfg.maxHp)

  _onDamage:(damage) ->
    hp = @data.get(@key) - damage
    @data.set(@key, hp)
    if(hp <= 0) then @_onDie()

  _isAlive:() -> @_hp() > 0
  _hp:() -> @data.get(@key)
  
  _onDie:() ->



class Module extends Life
  constructor: (cfg,@_store) ->
    super(@_store,cfg)
    @frame = null

  _attach : (@frame) ->
  _detach : () -> @frame = null
  _getType : () -> return null

exports.Module = Module


class ModeFactory
  constructor:()->
    @modeCfg={}
  registeMode:(cfg) ->
    @modeCfg[cfg.type] = cfg
  createMode:(type, count, creator) ->
    cfg = @modeCfg[type]
    return null unless cfg?
    if creator.isHaveEngery(cfg.cost(count))
      return cfg.create(creator)
    else
      return null
    


