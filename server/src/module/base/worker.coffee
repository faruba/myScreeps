{Error} = require('../../util/helper')
{Module} = require('../module')

class Worker extends Module

  _doJob:(target,cfg) ->
      target._process(cfg.progress,@frame)
    
exports.Worker = Worker
