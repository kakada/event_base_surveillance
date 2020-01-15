EBS.EventsShow = do ->
  map = null

  init = ->
    _renderMap()
    _initChart()

  _initChart = ->
    myBar = new Chart($('#myChart'),
      type: 'bar'
      data: _getBarChartData()
      options:
        title:
          display: true
          text: 'Time Detection'
        tooltips:
          mode: 'index'
          intersect: false
        responsive: true
        scales:
          xAxes: [ { stacked: true } ]
          yAxes: [ { stacked: true } ])

  _getBarChartData = ->
    data = $('#myChart').data('event-logs')
    labels = (x.created_at for x in data)
    fields = $('#myChart').data('tracking-fields')
    datasets = []

    for field in fields
      dd = data.map((x) ->
        x.properties[field]
      )

      datasets.push({
        label: field,
        backgroundColor: _getRandomColor(),
        data: dd
      })

    barChartData = {
      labels: labels,
      datasets: datasets
    }

  _getRandomColor = ->
    letters = '0123456789ABCDEF'
    color = '#'
    i = 0
    while i < 6
      color += letters[Math.floor(Math.random() * 16)]
      i++
    color

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
