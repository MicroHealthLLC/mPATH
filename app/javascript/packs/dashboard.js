import                       '@babel/polyfill'
import Leaflet          from 'leaflet'
import VModal           from 'vue-js-modal'
import * as Vue2Leaflet from 'vue2-leaflet'
import Dashboard        from 'components/dashboard/dashboard.vue'
import router           from 'routers/dashboard'
import                       'leaflet/dist/leaflet.css'

delete Leaflet.Icon.Default.prototype._getIconUrl
Leaflet.Icon.Default.mergeOptions({
  iconRetinaUrl: require('leaflet/dist/images/marker-icon.png'),
  iconUrl: require('leaflet/dist/images/marker-icon.png'),
  shadowUrl: require('leaflet/dist/images/marker-shadow.png')
});

Vue.use(VModal)
Vue.prototype.$leaflet = Leaflet
Vue.component('l-map', Vue2Leaflet.LMap);
Vue.component('l-polyline', Vue2Leaflet.LPolyline);
Vue.component('l-tile-layer', Vue2Leaflet.LTileLayer);
Vue.component('l-marker', Vue2Leaflet.LMarker);
Vue.component('l-tooltip', Vue2Leaflet.LTooltip);
Vue.component('l-popup', Vue2Leaflet.LPopup);
Vue.component('l-control-zoom', Vue2Leaflet.LControlZoom);
Vue.component('l-geo-json', Vue2Leaflet.LGeoJson);
Vue.component('l-feature-group', Vue2Leaflet.LFeatureGroup);
Vue.config.productionTip = false

// eslint-disable-next-line no-unused-vars
const dashboardApp = new Vue({
  router,
  el: '#dashboard',
  template: '<Dashboard />',
  components: { Dashboard }
})
