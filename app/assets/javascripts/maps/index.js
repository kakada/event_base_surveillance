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

    EBS.DatepickerPopup.init();
    _renderMap();
    _initLegendSliding();
  }

  function _initLegendSliding() {
    $('.btn-slide').on('click', function() {
      posRight = $(this).parents('.slide-wrapper').width() - $(this).width();
      right = '-=' + posRight;

      if(parseInt($('.slide-wrapper').css('right')) != 10) {
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

    map.setView(new L.LatLng(cambodiaLat, cambodiaLng), 7);

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
        color: data.color,
        fillColor: data.color,
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
    content += `<li><span class='type'>Event(suspected):</span> <span class='value'>${data.event_type_name}</span></li>`;
    content += `<li><span class='type'>Location:</span> <span class='value'>${data.location}</span></li>`;
    content += `<li><span class='type'>Reported count:</span> <span class='value'>${data.total_count}</span></li>`;
    content += `<li><span class='type'>Total case:</span> <span class='value'>${data.number_of_case || 0}</span></li>`;

    if(data.hasOwnProperty('number_of_hospitalized')) {
      content += `<li><span class='type'>Total hospitalized:</span> <span class='value'>${data.number_of_hospitalized || 0}</span></li>`;
    }

    content += `<li><span class='type'>Total death:</span> <span class='value'>${data.number_of_death || 0}</span></li>`;
    content += `</ul>`;

    return content;
  }
})();
