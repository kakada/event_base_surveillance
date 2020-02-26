EBS.MapsIndex = (() => {
  let map = null;

  const publicApi = {
    init: init
  };

  return publicApi;

  function init() {
    const start = moment(new Date(startDate));

    _renderMap();
    EBS.DatepickerPopup.init();
  }

  function _renderMap() {
    map = new L.Map('map');
    if (eventData.length) {
      _renderMarker();
      _renderLegend();
    }

    map.setView(new L.LatLng(12.33233, 104.875305), 7);

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

      marker.bindPopup(`Event(suspected): ${data.event_type_name}<br>Location: ${data.location}<br>Reported count: ${data.total_count}<br>Total case: ${data.number_of_case || 0}<br>Total hospitalized: ${data.number_of_hospitalized || 0}<br>Total death: ${data.number_of_death || 0}`);
    });

    // const locationCount = [...new Set(eventData.map(x => x.lat))].length;
    // if (locationCount == 1) {
    //   map.setView(new L.LatLng(markers[0][0], markers[0][1]), 15);
    // } else {
    //   map.fitBounds(markers);
    // }
  }

  function _renderLegend() {
    const legend = L.control({ position: "bottomright" });
    const div = L.DomUtil.create("div", "legend");
    const mapLegend = _getLegendData();

    mapLegend.forEach( (data) => {
      div.innerHTML += `<div class='flex-row-vertical-center'><i style="background: ${data.color}"></i><div>${data.name}</div></div>`;
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
      if(!mapLegend.has(item.event_type_id)){
        mapLegend.set(item.event_type_id, true);
        result.push({
          name: item.event_type_name,
          color: item.color
        });
      }
    }

    return result;
  }

})();
