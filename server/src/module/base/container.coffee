class Container extends Module
	constructor: (capacity = 10, goods = {}) ->
		@capacity = capacity
		@goods = goods
		super()

	getType : () -> return ModeType.Type_Container
	putIn: (good) ->
		capacityLeft = @capacityLeft()
		ret = {left:good.count }
		return ret if capacityLeft is 0
		solt = if @goods[good.type]? then @goods[good.type] else  new Good(good.type)
		if good.count > capacityLeft
			ret.left = good.count - capacityLeft
			solt.count = capacityLeft
		else
			ret.left = 0
			solt.count += good.count

		@_set(good.type, solt)
		return ret

	getFrom: (need) ->
		needType = need.type
		needType = @getDefaultType() unless needType?
		return null unless @isHave(needType)
		ret = new Good(needType)
		solt = @_get(needType)
		if solt.count > need.count
			ret.count = need.count
			solt.count -= need.count
		else
			ret.count = solt.count
			solt = null
		@_set(needType, solt)
		return ret

	getDefaultType : () ->
		for type, good of @goods
			return type
		return null

	isHave : (type) -> return type? and @_get(type)?
	isFull : ()  -> return @capacityLeft() is 0
	capacityLeft: () ->
		sum = 0
		for type, good of @goods
			sum += good.count

		return @capacity - sum


	_get: (type) -> return @goods[type]
	_set: (type, value) ->
		if value?
			@goods[type] = value
		else
			delete @goods[type]

exports.Container = Container


