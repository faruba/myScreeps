{_} = require('underscore')
graff = require('graff')

exports.testMapCfg = {
  rooms:[
    {
      name:'A'
      #otherCfg
    },
    {
      name:'B'
    },
    {
      name:'C'
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
      @rooms[roomCfg.name] = new Room(roomCfg, roomCfg.name, @)

    describeExits:(roomName) ->
      return @_roomPath.vertices[roomName]

    findRoute:(from, to) ->
      @_roomPath.get_path(from,to)[0]

    isRoomProtected:(roomName)->
      @rooms[roomName]?.isProtected()


    _tick:(dt) ->
      _.each(@_rooms,(elm, idx,list) ->
        elm._tick(dt)
        return list
      ,null)

    _createMap:(name) ->
      return ERR_NAME_EXISTS if @_rooms[name]?
      @_rooms[name] = new Room(name)

    _getRoom:(name) -> @_rooms[name]

exports.gMap = new Map()
