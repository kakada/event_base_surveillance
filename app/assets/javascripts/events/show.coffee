EBS.EventsShow = do ->
  map = null

  init = ->
    _renderMap()

  _renderMap = ->
    map = new (L.Map)('map')
    eventData = []
    if eventData.length
      _renderMarker()
      _renderLegend()
    else
      map.setView new (L.LatLng)(12.33233, 104.875305), 7
    _renderOSM()
    return

  _renderOSM = ->
    osmUrl = 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png'
    osmAttrib = 'Map data © <a href="https://openstreetmap.org">OpenStreetMap</a> contributors'
    osm = new (L.TileLayer)(osmUrl,
      minZoom: 6
      maxZoom: 15
      attribution: osmAttrib)
    map.addLayer osm
    return

  { init: init }
