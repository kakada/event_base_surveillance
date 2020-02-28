EBS.EventsShow = do ->
  map = null

  init = ->
    _renderMap()
    _initChart()
    initTruncate()
    onClickTracingTextModalTrigger()

  initTruncate = ->
    $('.fv-body-wrapper').each (index, dom)->
      if dom.scrollHeight > 120
        $(dom).parents('.value').addClass('overflow-content')

    onClickBtnTruncate()

  onClickBtnTruncate = ->
    $('.btn-truncate').on 'click', ->
      $(this).parents('.value').toggleClass('detail-on')

  onClickTracingTextModalTrigger = ->
    $('.tracing-text-modal-trigger').on 'click', ->
      data = $(this).data('tracings')
      dom = ''
      i = 0

      while i < data.length
        dom += '<li class="li complete">'
        dom += '<div class="status"><span>'+data[i].field_value+'</span></div>'
        dom += '<div class="timestamp"><div class="date">'+_formatDateTime(data[i].created_at)+'</div></div>'
        dom += '</li>'
        i++

      $('#modal-label').html($(this).data('title'))
      $('#timeline').html(dom)

  _formatDateTime = (datetime)->
    d = new Date(datetime)
    year = d.getFullYear()
    month = ("0" + (d.getMonth() + 1)).slice(-2)
    date = ("0" + d.getDate()).slice(-2)

    return year + '-' + month + '-' + date + ' ' + d.getHours() + ':' + d.getMinutes()

  _initChart = ->
    data = _getBarChartData()

    if !data
      return

    myBar = new Chart($('#myChart'),
      type: 'bar'
      data: data
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
    data = $('#myChart').data('eventTracings')

    if !data
      return

    labels = (_formatDateTime(x.created_at) for x in data)
    fields = $('#myChart').data('trackingNumberFields')
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

    L.circleMarker(data.latlng, {
      fillOpacity: 0.8,
      weight: 1,
      opacity: 1,
      radius: 5
    }).addTo(map).bindPopup(_buildMarkerPopupContent(data)).openPopup()

  _buildMarkerPopupContent = (data)->
    fvs = data.eventFvs
    content = "<ul class='popup-content-wrapper'>"
    content += "<li><span class='type'>Event(suspected):</span> <span class='value'>" + data.eventType + "</span></li>"
    content += "<li><span class='type'>Total case:</span> <span class='value'>" + fvs.number_of_case + "</span></li>"

    if fvs.hasOwnProperty('number_of_hospitalized')
      content += "<li><span class='type'>Total hospitalized:</span> <span class='value'>" + fvs.number_of_hospitalized + "</span></li>"

    content += "<li><span class='type'>Total death:</span> <span class='value'>" + fvs.number_of_death + "</span></li>"
    content += "</ul>"

    return content;

  _renderOSM = ->
    osmUrl = 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png'
    osmAttrib = 'Map data © <a href="https://openstreetmap.org">OpenStreetMap</a> contributors'
    osm = new (L.TileLayer)(osmUrl,
      minZoom: 6
      maxZoom: 15
      attribution: osmAttrib)
    map.addLayer osm

  {
    init: init
    onClickTracingTextModalTrigger: onClickTracingTextModalTrigger
    initTruncate: initTruncate
  }
