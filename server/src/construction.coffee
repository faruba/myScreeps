ConstructionSiteCfg =[
  Rode:{
    progressTotal:100
    validatePosType:[1]
  }
]
class ConstructionSite
  constructor:(@structureType, @room, @pos) ->
    @id = @room._getID()
    @progress = 0
    @cfg = ConstructionSiteCfg[@structureType]

  remove: ()->
    @room.remove(@)

ConstructionSite._checkPosValidate(pos, sType) ->
  ConstructionSiteCfg[sType]?.validatePosType?.indexOf(sType) isnt -1
