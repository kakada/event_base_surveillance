EBS.MapsIndex = (() => {
  let map;

  const publicApi = {
    init: init
  };

  return publicApi;

  function init() {
    const start = moment(new Date(startDate));
    const end = moment(new Date(endDate));

    _filterLocation();
    _renderMap();

    _renderDateFilter(start, end);
  }

  function _renderMap() {
    map = new L.Map('map');
    if (eventData.length) {
      _renderMarker();
      _renderLegend();
    } else {
      map.setView(new L.LatLng(12.33233, 104.875305), 7);
    }

    _renderOSM();
  }

  function _renderOSM() {
    const osmUrl='https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';
    const osmAttrib='Map data © <a href="https://openstreetmap.org">OpenStreetMap</a> contributors';
    const osm = new L.TileLayer(osmUrl, { minZoom: 6, maxZoom: 15, attribution: osmAttrib });

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

      const extraRadius = Math.floor(data.count / 10) + 0.5;
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

      marker.bindPopup(`Event count: ${data.count}<br>Event type: ${data.event_type}<br>Location: ${data.location}`);
    });

    const locationCount = [...new Set(eventData.map(x => x.lat))].length;
    if (locationCount == 1) {
      map.setView(new L.LatLng(markers[0][0], markers[0][1]), 15);
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
    const value = start.format('MMMM D, YYYY') + ' - ' + end.format('MMMM D, YYYY');
    $('#reportrange span').html(start.format('MMMM D, YYYY') + ' - ' + end.format('MMMM D, YYYY'));

    $('#reportrange-input').val(`${moment(start).format('MM/DD/Y')} - ${moment(end).format('MM/DD/Y')}`);
  }

  function _renderDateFilter(start, end) {
    $('#reportrange').daterangepicker({
      startDate: start,
      endDate: end,
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
    $('#filter-location-input').click((event) => {
      $("#filter-location").show();
    });

    $('#location-action').on('click', function() {
      $("#filter-location").fadeOut(200);
    });

    $('body').click(function() {
      $("#filter-location").fadeOut(200);
    });

    $('.location-group').click(function(e) {
      e.stopPropagation();
    });

    _renderSelectedValue();
    _handleFormSubmit();
  }

  function _handleFormSubmit() {
    $('#event-form').submit(function() {
      $(this)
        .find('input[name], select')
        .filter(function () {
          return !this.value;
        })
        .prop('name', '');
    });

    _constructDateRange();
  }

  function _constructDateRange() {
    const dateRangeEle = $('#reportrange-input');
    const dateRange = dateRangeEle.val().split(' - ');
    const startDate = moment(new Date(dateRange[0])).format('DD/MM/Y');
    const endDate = moment(new Date(dateRange[1])).format('DD/MM/Y');
    const startDateEle = $(`<input type='hidden' name='start_date' value='${startDate}' />`);
    const endDateEle = $(`<input type='hidden' name='end_date' value='${endDate}' />`);
    $('#event-form').append(startDateEle, endDateEle);
    dateRangeEle.remove();
  }

  function _renderSelectedValue() {
    $('.select-location').change( () => {
      let text = '';
      $('.select-location option:selected').toArray().forEach( (item) => {
        if (item.value) {
          text += `${item.text} `;
        }
      });

      $('#filter-location-input').val(text);
    });
  }
})();