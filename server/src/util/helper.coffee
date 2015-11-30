require('../define')

{_} = require('underscore')
class HightOrderFuncPair
	constructor : (pair ={}) ->
		@pair =pair
	
	map : (func,args) ->
		ret = new HightOrderFuncPair()
		for k, v of @pair
			[key,value] = func(k,v, args)
			ret.pair[key] = value
		return ret
	filter : (func, args) ->
		ret = new HightOrderFuncPair()
		for k, v of @pair
			if func(k,v, args)
				ret.pair[k] = v
		return ret
	reduce : (func, initValue) ->
		arr = []
		ret = new HightOrderFuncPair()
		for k,v of @pair
			arr.push({k:k,v:v})
		return arr.reduce(func,initValue)
	valueOf : () ->
		return @pair
	toString :() ->
		return @pair.toString()
	isEmpty: () ->
		return Object.keys(@pair).length is 0

exports.HightOrderFuncPair = HightOrderFuncPair

boundaries = (min, max, value) ->
	return min if value < min
	return max if value > max
	return value


class Pos
	constructor: (@x = 0, @y =0) ->

	add: (point) ->
		@x += point.x
		@y += point.y

	offset: (point) ->
		new Pos(@x + point.x, @y + point.y)

	scale: (times) ->
		new Pos(@x * times, @y * times)
	isValidatePos: () ->
		return @x >=0 and @y >=0
	
exports.Pos = Pos

MoveMitrix = [
	new Pos(0,1),
	new Pos(1,1),
	new Pos(1,0),
	new Pos(1,-1),
	new Pos(0,-1),
	new Pos(-1,-1),
	new Pos(-1,0),
	new Pos(-1,1),
]
exports.MoveMitrix = MoveMitrix

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


exports.Data = Data

exports.Error = (err) -> {err:err}

['Flag','Creep','Struct','Spawn'].forEach((name) =>
  exports['gen'+name+'Id'] = () -> _.uniqueId(name))

exports.ClassWarp = (owner, clazz) ->

