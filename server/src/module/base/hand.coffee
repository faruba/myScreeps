class Hand extends Module
	constructor: (capacity = 1, good = null) ->
		@capacity = capacity
		@good = good
		super()

	getType : () -> return ModeType.TType_Hand
	grab: (container) ->
		if container? and not @good?
			@good = container.getFrom({count:@capacity})

	drop: (container) ->
		if container? and @good?
			{left:left} = container.putIn(@good)
			if left is 0
				@good = null
			else
				@good.count = left
	store: () ->
		[container] = @frame.getModule(ModeType.Type_Container)
		@drop(container)

exports.Hand = Hand

