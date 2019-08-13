EBS.MapsIndex = (() => {
  let map;

  const publicApi = {
    init: init
  };

  return publicApi;

  function init() {
    _renderMap();
  }

  function _renderMap() {
    map = new L.Map('map');

    // map.setView(new L.LatLng(11.5564, 104.9282), 7);

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
      variant += 0.003;

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

      marker.bindPopup(`Event count: ${data.count}<br>Event type: ${data.event_type}`);
    });

    // var group = new L.featureGroup(markers);

    map.fitBounds(markers);
  }

  function _renderLegend() {
    const legend = L.control({ position: "bottomright" });

    const div = L.DomUtil.create("div", "legend");

    eventLegend.forEach( (data, index) => {
      div.innerHTML += `<div><i style="background: ${data.color}"></i><span>${data.name}</span></div>`;
    });

    legend.onAdd = function(map) {
      return div;
    };

    legend.addTo(map);
  }
})();