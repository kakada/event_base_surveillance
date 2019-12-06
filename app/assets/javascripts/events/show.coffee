EBS.EventsShow = do ->
  modalMap = null

  init = ->
    _initEventMap()
    _intitModalMap()
    _onSubmitModalMap()

  _onSubmitModalMap = ->
    $('.btn-submit').on 'click', ->
      $.ajax({
        url: $('.location-form').attr('action'),
        data: EBS.Util.getFormData($('.location-form')),
        type: $('.location-form').attr('method'),
        success: (result) ->
          console.log(result)
          window.location.reload()
      });

  _intitModalMap = ->
    modalMap = new (L.Map)('locationMap')

    _renderOSM(modalMap)
    _onClickModalMap()
    _onShowModal()

  _onClickModalMap = ->
    self = this
    self.layerGroup = L.layerGroup().addTo(modalMap)

    modalMap.on 'click', (e)->
      self.layerGroup.clearLayers()
      _addMarker(modalMap, e)

  _addMarker = (modalMap, e)->
    latlng = [e.latlng.lat, e.latlng.lng]
    L.circleMarker(latlng, {
      fillOpacity: 0.8,
      weight: 1,
      opacity: 1,
      radius: 5,
    }).addTo(layerGroup);

    _updateLatlongView(latlng)

  _updateLatlongView = (latlng)->
    $('.lat').val(latlng[0])
    $('.lng').val(latlng[1])

  _onShowModal = ->
    $('#locationModal').on 'shown.bs.modal', ->
      modalMap.setView new (L.LatLng)(12.33233, 104.875305), 7

  _initEventMap = ->
    map = new (L.Map)('map')
    latlng = $('#map').data('latlng')

    if !!latlng && latlng.length
      map.setView new (L.LatLng)(latlng[0], latlng[1]), 9
      _renderMarker(map)
    else
      map.setView new (L.LatLng)(12.33233, 104.875305), 7

    _renderOSM(map)

  _renderMarker = (map)->
    data = $('#map').data()
    msg = 'Event type: <b>' + data.eventType + '</b><br>Number of case: <b>' + data.numberOfCase + '</b>'

    L.circleMarker(data.latlng, {
      fillOpacity: 0.8,
      weight: 1,
      opacity: 1,
      radius: 5
    }).addTo(map).bindPopup(msg).openPopup()

  _renderOSM = (map)->
    osmUrl = 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png'
    osmAttrib = 'Map data © <a href="https://openstreetmap.org">OpenStreetMap</a> contributors'
    osm = new (L.TileLayer)(osmUrl,
      minZoom: 6
      maxZoom: 15
      attribution: osmAttrib)
    map.addLayer osm

  { init: init }
