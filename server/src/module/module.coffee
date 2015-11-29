class Module
  constructor: () ->
    @property =  { }
    @interface =  { }
    @frame = null
    @maxLife = 20
    @life = @maxLife

  caculateCost:(count) -> return false
  attach : (@frame) ->
  detach : () -> @frame = null
  getType : () -> return null

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
    


