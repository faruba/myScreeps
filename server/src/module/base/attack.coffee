{Error} = require('../../util/helper')
{Module} = require('../module')

class Attack extends Module
  constructor: (_store, @cfg) ->
    super(@cfg,_store)
    @key ='akCnt'

  _attach:(@frame)->
    super(@frame)
    @_store.append(@key,1)

  _detach:() ->
    super()
    @_store.sub(@key,1)

  _onAttack:(@target) ->
    

