window.StateMachine =
  VERSION: '2.0.0'
  create: (cfg, target) ->
    initial   = (if (typeof cfg.initial == 'string') then state: cfg.initial else cfg.initial)
    fsm       = target || cfg.target || {}
    events    = cfg.events || []
    callbacks = cfg.callbacks || {}
    map       = {}

    add = (e) ->
      froms = (if (e.from instanceof Array) then e.from else [ e.from ])
      map[e.name] = map[e.name] || {}
      for from in froms
        map[e.name][from] = e.to

    if initial
      initial.event = initial.event || 'startup'
      add { name: initial.event, from: 'none', to: initial.state }

    add event for event in events

    for name of map
      fsm[name] = window.StateMachine.buildEvent(name, map[name])  if map.hasOwnProperty(name)

    for callback of callbacks
      fsm[callback] = callbacks[callback]  if callbacks.hasOwnProperty(callback)

    fsm.current = 'none'

    fsm.is = (state) -> @current == state
    fsm.can = (event) -> !!map[event][@current] && !@transition
    fsm.cannot = (event) -> !@can(event)

    fsm[initial.event]()  if initial && !initial.defer
    fsm

  beforeEvent: (name, from, to, args) ->
    func = @["onbefore#{name}"]
    func.apply @, [ name, from, to ].concat(args)  if func

  afterEvent: (name, from, to, args) ->
    func = @["onafter#{name}"] || @["on" + name]
    func.apply @, [ name, from, to ].concat(args)  if func

  leaveState: (name, from, to, args) ->
    func = @["onleave#{from}"]
    func.apply @, [ name, from, to ].concat(args)  if func

  enterState: (name, from, to, args) ->
    func = @["onenter#{to}"] || @["on#{to}"]
    func.apply @, [ name, from, to ].concat(args)  if func

  changeState: (name, from, to, args) ->
    func = @onchangestate
    func.apply @, [ name, from, to ].concat(args)  if func

  buildEvent: (name, map) ->
    ->
      throw "event #{name} innapropriate because previous transition did not complete"  if @transition
      throw "event #{name} innapropriate in current state " + @current  if @cannot(name)
      from = @current
      to = map[from]
      args = Array::slice.call(arguments)
      unless @current == to
        return  if false == window.StateMachine.beforeEvent.call(@, name, from, to, args)
        self = @
        @transition = ->
          self.transition = null
          self.current = to
          window.StateMachine.enterState.call  self, name, from, to, args
          window.StateMachine.changeState.call self, name, from, to, args
          window.StateMachine.afterEvent.call  self, name, from, to, args

        @transition()  if @transition  if false != window.StateMachine.leaveState.call(@, name, from, to, args)
