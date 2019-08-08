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

    const osmUrl='https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';
    const osmAttrib='Map data © <a href="https://openstreetmap.org">OpenStreetMap</a> contributors';
    const osm = new L.TileLayer(osmUrl, { minZoom: 6, maxZoom: 19, attribution: osmAttrib });

    // start the map in South-East England
    map.setView(new L.LatLng(11.5564, 104.9282), 14);
    map.addLayer(osm);
  }
})();