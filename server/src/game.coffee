{_} = require('underscore')
{Config} = require('./cfg')
class GlobalCtlLevel
  constructor: (@level) ->
    @progress = 0

class Game
  constructor:() ->
    @tickInteral = 20
    @flags ={}
    @glc = new GlobalCtlLevel(0)
    @map = new Map()
    @rooms = @map._rooms #{}
    @spawns = @map._spawns #{}
    @creeps = @map._creeps #{}
    @structures = @map._structures
    @time=0

  getObjectById:(id) ->
    switch @_getGroup(id)
      when "s" then h = @spawns
      when "st" then h = @structures
      when "c" then h = @creeps
    return h[id]

  _tick:(dt) ->
    @map._tick(dt)
    
