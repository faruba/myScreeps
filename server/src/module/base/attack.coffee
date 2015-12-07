{Error} = require('../../util/helper')
{Module} = require('../module')

class HpModifier extends Module
  _doJob:(@target,cfg) ->
    @target._onDamage(cfg.damage)
  
  _preCheck:(target)->
    return Room.distanceP2(target,@) <= @cfg.rangP2
    

