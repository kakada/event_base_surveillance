EBS.MapsIndex = (() => {
  let map;
  const start = moment().subtract(29, 'days');
  const end = moment();

  const publicApi = {
    init: init
  };

  return publicApi;

  function init() {
    _filterLocation();

    if (eventData.length) {
      _renderMap();
    }
    _renderDateFilter();
  }

  function _renderMap() {
    map = new L.Map('map');
    _renderMarker();
    _renderLegend();
    _renderOSM();
  }

  function _renderOSM() {
    const osmUrl='https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';
    const osmAttrib='Map data © <a href="https://openstreetmap.org">OpenStreetMap</a> contributors';
    const osm = new L.TileLayer(osmUrl, { minZoom: 6, maxZoom: 19, attribution: osmAttrib });

    map.addLayer(osm);
  }

  function _renderMarker() {
    let variant = 0;
    let latCursor;
    let markers = [];

    eventData.sort((a, b) => (a.lat > b.lat) ? 1 : -1);

    eventData.forEach( (data) => {
      variant += 0.001;

      if (latCursor != data.lat) {
        latCursor = data.lat;
        variant = 0;
      }

      const extraRadius = Math.floor(data.count / 10) * 25;
      const latlng = [ data.lat + variant, data.lng + variant];

      const marker = L.circle(latlng, {
        color: data.color,
        fillColor: data.color,
        fillOpacity: 0.8,
        weight: 1,
        opacity: 1,
        radius: 200 + extraRadius
      }).addTo(map);

      markers.push(latlng);

      marker.bindPopup(`Event count: ${data.count}<br>Event type: ${data.event_type}<br>geopoint: ${data.lat},${data.lng}`);
    });

    const locationCount = [...new Set(eventData.map(x => x.lat))].length;
    if (locationCount == 1) {
      map.setView(new L.LatLng(markers[0][0], markers[0][1]), 13);
    } else {
      map.fitBounds(markers);
    }
  }

  function _renderLegend() {
    const legend = L.control({ position: "bottomright" });
    const div = L.DomUtil.create("div", "legend");
    const mapLegend = _getLegendData();

    mapLegend.forEach( (data) => {
      div.innerHTML += `<div><i style="background: ${data.color}"></i><span>${data.name}</span></div>`;
    });

    legend.onAdd = function(map) {
      return div;
    };

    legend.addTo(map);
  }

  function _getLegendData() {
    const result = [];
    const mapLegend = new Map();
    for (const item of eventData) {
      if(!mapLegend.has(item.event_id)){
        mapLegend.set(item.event_id, true);
        result.push({
          name: item.event_type,
          color: item.color
        });
      }
    }

    return result;
  }

  function cb(start, end) {
    $('#reportrange span').html(start.format('MMMM D, YYYY') + ' - ' + end.format('MMMM D, YYYY'));
  }

  function _renderDateFilter() {

    $('#reportrange').daterangepicker({
      startDate: startDate,
      endDate: endDate,
      ranges: {
          'Today': [moment(), moment()],
          'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
          'Last 7 Days': [moment().subtract(6, 'days'), moment()],
          'Last 30 Days': [moment().subtract(29, 'days'), moment()],
          'This Month': [moment().startOf('month'), moment().endOf('month')],
          'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')]
      }
    }, cb);

    cb(start, end);
  }

  function _filterLocation() {
    $('#filter-location-input').on('click', () => {
      $("#filter-location").show();
    });

    $('#location-action').on('click', function() {
      $("#filter-location").hide();
    });

    _renderSelectedValue();
  }

  function _showLocationFilter() {
    $("#filter-location").addClass("show");
  }

  function _renderSelectedValue() {
    $('.select-location').change( () => {
      let text = '';
      $('.select-location option:selected').toArray().forEach( (item, index) => {
        if (item.value) {
          text += `${item.text} `;
        }
      });

      $('#filter-location-input').val(text);
    });
  }
})();