
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


class P
	constructor: (x = 0, y =0) ->
		@x = x
		@y = y

	add: (point) ->
		@x += point.x
		@y += point.y

	offset: (point) ->
		new P(@x + point.x, @y + point.y)

	scale: (times) ->
		new P(@x * times, @y * times)
	isValidatePos: () ->
		return @x >=0 and @y >=0
	

MoveMitrix = [
	new P(0,1),
	new P(1,1),
	new P(1,0),
	new P(1,-1),
	new P(0,-1),
	new P(-1,-1),
	new P(-1,0),
	new P(-1,1),
]



