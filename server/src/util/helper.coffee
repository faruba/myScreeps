require('../define')
{_} = require('lodash')

boundaries = (min, max, value) ->
	return min if value < min
	return max if value > max
	return value

exports.boundaries =  boundaries

#MoveMitrix = [
#	new Pos(0,1),
#	new Pos(1,1),
#	new Pos(1,0),
#	new Pos(1,-1),
#	new Pos(0,-1),
#	new Pos(-1,-1),
#	new Pos(-1,0),
#	new Pos(-1,1),
#]
#exports.MoveMitrix = MoveMitrix

class Data
  constructor:(initData = {}) ->
    @data = _.extend({}, initData)
    @hooks ={s:{},g:{}}
  set:(key, value) ->
    old = @data[key]
    @hooks.s[key]?.forEach((func) -> func(key,old, value))
    @data[key] =value
  get:(key, defaults) ->
    value =  if @data[key]? then @data[key] else defaults
    @hooks.g[key]?.forEach((func) -> func(key,value))
    return value
  setHook:(key,isSet,func) ->
    hook = if isSet then @hooks.s else @hooks.g
    hook[key] ?= []

    return if hook[key].indexOf(func) isnt -1
    hook[key].push(func)
  append:(key,value) ->
    v= @data[key] ? 0
    v+=value
    @set(key, v)

  sub:(key,value) ->
    v= @data[key] ? 0
    v-=value
    @set(key, v)
    return v


exports.Data = Data

exports.Error = (err) -> {err:err}

['Flag','Creep','Struct','Spawn'].forEach((name) =>
  exports['gen'+name+'Id'] = () -> _.uniqueId(name))

ClassWarp = (owner, clazz, cfg={prefix:'__',checkLst:[]}) ->
  genFunc = (_owner, func) ->
    return () ->
      newArgs = [_owner].concat(arguments)
      for check in cfg.checkLst
        ret = _.partial(check,_owner).apply(@,arguments)
        if ret isnt OK
          return ret
      return _.partial(func,_owner).apply(@,arguments)

  funcLst = _.filter(Object.keys(clazz::),
    (fname) -> _.startsWith(fname,cfg.prefix))
      
  for funName in funcLst
    exportName = _.trimLeft(funName,cfg.prefix)
    clazz::[exportName] = genFunc(owner,clazz::[funName])
    #console.log(clazz::[exportName], exportName)
  return clazz
exports.ClassWarp = ClassWarp

exports.bindProperty= (obj,name,store,prefix="", defV) ->
  Object.defineProperty(obj, name,{
    enumerable:false
    configurable:false
    get:() -> store.get(prefix+name)
    set:(value) -> store.set(prefix+name,value)
  })
  obj[name] = defV
exports.myGc=() ->
  if(global.gc?)
    global.gc()
  else
    error("""Garbage collection unavailable.  Pass --expose-gc 
          when launching node to enable forced garbage collection.""")
