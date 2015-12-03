{_} = require('underscore')
graff = require('graff')
{Room} = require('./room')

testGen = () ->
  return [
    [1,0,0,0,0],
    [0,1,0,0,0],
    [0,0,0,0,0],
    [0,0,0,1,0],
    [0,0,0,0,1]]

testMapCfg = {
  rooms:[
    {
      name:'A'
      mapGener:testGen
      #otherCfg
    },
    {
      name:'B'
      mapGener:testGen
    },
    {
      name:'C'
      mapGener:testGen
    },
  ],
  edges:[
    ['A','B',13]
    ['A','C',13]
  ]
}

class Map
  constructor:(mapCfg)->
    @_rooms =  {}

    @_roomPath = new graff.Graph(_.defaults(mapCfg, {directed:false}))
    for roomCfg in mapCfg.rooms
      @_rooms[roomCfg.name] = new Room(roomCfg.mapGener, roomCfg.name, @)

    describeExits:(roomName) ->
      return @_roomPath.vertices[roomName]

    findRoute:(from, to) ->
      @_roomPath.get_path(from,to)[0]

    isRoomProtected:(roomName)->
      @_rooms[roomName]?.isProtected()


    _tick:(dt) ->
      _.each(@_rooms,(elm, idx,list) ->
        elm._tick(dt)
        return list
      ,null)

    _createMap:(name) ->
      return ERR_NAME_EXISTS if @_rooms[name]?
      @_rooms[name] = new Room(name)

    _getRoom:(name) -> @_rooms[name]

exports.gMap = new Map(testMapCfg)
