EBS.MapsIndex = (() => {
  let map = null;
  let eventData = [];
  const osmUrl='https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';
  const osmAttrib='Map data © <a href="https://openstreetmap.org">OpenStreetMap</a> contributors';
  const cambodiaLat = 12.33233;
  const cambodiaLng = 104.875305;
  const publicApi = {
    init: init
  };

  return publicApi;

  function init() {
    eventData = $('#map').data('event-data');

    EBS.DateRangePicker.init();

    _renderMap();
    _initLegendSliding();
  }

  function _initLegendSliding() {
    $('.btn-slide').on('click', function() {
      posRight = $(this).parents('.slide-wrapper').width() - $(this).parent().width();
      right = '-=' + posRight;

      if(parseInt($('.slide-wrapper').css('right')) < 0) {
        right = '+=' + posRight;
      }

      $('.slide-wrapper').animate({'right': right});
      $(this).find('i').toggleClass('fa-angle-double-right');
    });
  }

  function _renderMap() {
    map = new L.Map('map');
    if (eventData.length) {
      _renderMarker();
    }

    let province = $('#map').data('province');
    let program = $('#map').data('program');
    let provinceZoomable = !!province && !!province.latitude && !!province.longitude;

    let latitude = provinceZoomable ? province.latitude : cambodiaLat;
    let longitude = provinceZoomable ? province.longitude : cambodiaLng;
    let zoomLevel = provinceZoomable ? program.provincial_zoom_level : program.national_zoom_level;

    map.setView(new L.LatLng(latitude, longitude), zoomLevel);

    _renderOSM();
  }

  function _renderOSM() {
    let osm = new L.TileLayer(osmUrl, { minZoom: 6, maxZoom: 15, attribution: osmAttrib });
    map.addLayer(osm);
  }

  function _renderMarker() {
    let variant = 0;
    let latCursor;
    let markers = [];

    eventData.sort((a, b) => (a.lat > b.lat) ? 1 : -1);

    eventData.forEach( (data) => {
      variant += 0.00025;

      if (latCursor != data.lat) {
        latCursor = data.lat;
        variant = 0;
      }

      const extraRadius = Math.floor(data.total_count / 10) + 0.5;
      const latlng = [ data.lat + variant, data.lng + variant];

      const marker = L.circleMarker(latlng, {
        color: data.event_type.color,
        fillColor: data.event_type.color,
        fillOpacity: 0.8,
        weight: 1,
        opacity: 1,
        radius: 5 + extraRadius
      }).addTo(map);

      markers.push(latlng);
      marker.bindPopup(_buildMarkerPopupContent(data));
    });
  }

  function _buildMarkerPopupContent(data) {
    let content = `<ul class='popup-content-wrapper'>`;
    content += `<li><span class='type'>${locale.suspected_event}:</span> <span class='value'>${data.event_type.name}</span></li>`;
    content += `<li><span class='type'>${locale.location}:</span> <span class='value'>${data.location}</span></li>`;
    content += `<li><span class='type'>${locale.reported_count}:</span> <span class='value'>${data.total_count} (${locale.times})</span></li>`;
    content += `<li><span class='type'>${locale.total_case}:</span> <span class='value'>${data.number_of_case || 0}</span></li>`;

    if(data.hasOwnProperty('number_of_hospitalized')) {
      content += `<li><span class='type'>${locale.total_hospitalized}:</span> <span class='value'>${data.number_of_hospitalized || 0}</span></li>`;
    }

    content += `<li><span class='type'>${locale.total_death}:</span> <span class='value'>${data.number_of_death || 0}</span></li>`;
    content += `</ul>`;

    return content;
  }
})();
