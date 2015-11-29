class Attackable
  constructor:(@data, @cfg) ->
    @key = @cfg.name+'.hp'
    @data.set(@key,@cfg.maxHp)

  _onDamage:(damage) ->
    hp = @data.get(@key) - damage
    @data.set(@key, hp)
    if(hp <= 0) then @_onDie()

  _isAlive:() -> @data.get(@key) > 0
  
  _onDie:() ->



class Frame
  constructor: () ->
    @power = {}
    @slots = new Array(CONST_MAX_SLOT_NUM)
    @func ={}

  #getPos: -> return @slots[Slot_Base].pos
  getModule: (moduleType) ->
    return @slots.filter((module) ->return module.getType() is moduleType)


  remove: (pos) ->
    @install(null,pos)


  install: (module, pos) ->
    return false if pos < 0 or pos >= CONST_MAX_SLOT_NUM
    if module? and module.getType() is ModeType.Type_Wheel
      pos = Slot_Base


    originMode = @_replace(module,pos)

    if originMode?
      @unregisteFunction(originMode, pos)
      originMode.detach()
    if module?
      module.attach(@)
      @registeFunction(module,pos)

  registeFunction :(module,pos) ->
    thiz = @
    @enumFunctionName(module)
      .forEach((functionName) ->
        if not thiz[functionName]?
          thiz[functionName] = (arg) -> thiz._dispatcher(functionName,arg)
        thiz.func[functionName] = new HightOrderFuncPair() unless thiz.func[functionName]?
        thiz.func[functionName].pair[pos] = true)

  unregisteFunction : (module, pos) ->
    thiz = @
    @enumFunctionName(module)
      .forEach((functionName) ->
        delete thiz.func[functionName].pair[pos] if thiz.func[functionName].pair[pos]?
        if thiz.func[functionName].isEmpty()
          delete thiz.func[functionName]
          delete thiz[functionName]
      )


  enumFunctionName : (module) ->
    ret = []
    for k , v of module
      ret.push(k) if typeof v is 'function'
    ret = ret.filter((name) -> return name isnt 'constructor')
      .filter((name) -> name.charAt(0) isnt '_')
    return ret


  policy : (idx, module) -> return true

  _dispatcher : (functionName,arg) ->
    thiz = @
    moduleRef = @func[functionName]
    return {err:Err_Function_not_exist} unless moduleRef?
    return moduleRef.map((index) ->return [index,thiz.slots[+index]])
      .filter(thiz.policy)
      .map((idx,module) ->
        return [idx, module[functionName](arg)])
          .valueOf()

  _replace : (module, pos) ->
    originMode = @slots.splice(pos,1,module)
    if originMode.length is 0
      return null
    return originMode[0]


exports.Frame = Frame



