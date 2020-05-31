import                          '@babel/polyfill'
import _                   from 'lodash'
import Users               from 'components/users'
import router              from 'routers/users'
import VeeValidate         from 'vee-validate'
import * as VueGoogleMaps  from 'vue2-google-maps'
import FadeLoader          from 'vue-spinner/src/FadeLoader.vue'
import VuePhoneNumberInput from 'vue-phone-number-input'
import 'vue-phone-number-input/dist/vue-phone-number-input.css'


Vue.component('vue-phone-number-input', VuePhoneNumberInput)
Vue.component('loader', FadeLoader)
Vue.use(VeeValidate)

Vue.use(VueGoogleMaps, {
  load: {
    key: window.google_api_key,
    libraries: 'places',
  },
  installComponents: true
})

Vue.config.productionTip = false
Vue.prototype.$currentUser = JSON.parse(window.current_user.replace(/&quot;/g,'"'));

// eslint-disable-next-line no-unused-vars
const app = new Vue({
  router,
  el: '#users',
  template: '<Users />',
  components: { Users }
})
