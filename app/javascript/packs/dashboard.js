import                           '@babel/polyfill'
import                           'leaflet/dist/leaflet.css'
import                           'vue-multiselect/dist/vue-multiselect.min.css'
import                           'vue-slim-tabs/themes/default.css'
import _                    from 'lodash'
import Leaflet              from 'leaflet'
import Multiselect          from 'vue-multiselect'
import VModal               from 'vue-js-modal'
import * as VueGoogleMaps   from 'vue2-google-maps'
import GmapCustomMarker     from 'vue2-gmap-custom-marker'
import Dashboard            from 'components/dashboard/dashboard.vue'
import router               from 'routers/dashboard'
import VeeValidate          from 'vee-validate'
import GmapCluster          from 'vue2-google-maps/dist/components/cluster'
import VueTelInput          from 'vue-tel-input'
import DatePicker           from 'vuejs-datepicker'
import * as Tabs            from 'vue-slim-tabs'
import VueSlideBar          from 'vue-slide-bar'
import FadeLoader           from 'vue-spinner/src/FadeLoader.vue'
import VTooltip             from 'v-tooltip'


Vue.use(VTooltip)
Vue.use(Tabs)
Vue.use(VModal)
Vue.use(VueTelInput)
Vue.prototype.$leaflet = Leaflet
Vue.component('loader', FadeLoader)
Vue.component('vue-slide-bar', VueSlideBar)
Vue.component('date-picker', DatePicker)
Vue.component('GmapCluster', GmapCluster)
Vue.component('GmapCustomMarker', GmapCustomMarker)
Vue.component('multiselect', Multiselect)
Vue.config.productionTip = false
Vue.use(VeeValidate);


Vue.use(VueGoogleMaps, {
  load: {
    key: window.google_api_key,
    libraries: 'places',
  },
  installComponents: true
})

Vue.prototype.$currentUser = JSON.parse(window.current_user.replace(/&quot;/g,'"'));

// eslint-disable-next-line no-unused-vars
const dashboardApp = new Vue({
  router,
  el: '#dashboard',
  template: '<Dashboard />',
  components: { Dashboard }
})
