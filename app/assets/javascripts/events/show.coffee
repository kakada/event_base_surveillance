EBS.EventsShow = do ->
  map = null

  init = ->
    _renderMap()

  _renderMap = ->
    map = new (L.Map)('map')
    latlng = $('#map').data('latlng')

    if !!latlng && latlng.length
      map.setView new (L.LatLng)(latlng[0], latlng[1]), 9
      _renderMarker(latlng)
    else
      map.setView new (L.LatLng)(12.33233, 104.875305), 7

    _renderOSM()

  _renderMarker = ->
    data = $('#map').data()
    msg = 'Event type: <b>' + data.eventType + '</b><br>Number of case: <b>' + data.numberOfCase + '</b>'

    L.circleMarker(data.latlng, {
      fillOpacity: 0.8,
      weight: 1,
      opacity: 1,
      radius: 5
    }).addTo(map).bindPopup(msg).openPopup()

  _renderOSM = ->
    osmUrl = 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png'
    osmAttrib = 'Map data © <a href="https://openstreetmap.org">OpenStreetMap</a> contributors'
    osm = new (L.TileLayer)(osmUrl,
      minZoom: 6
      maxZoom: 15
      attribution: osmAttrib)
    map.addLayer osm

  { init: init }
