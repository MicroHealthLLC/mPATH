import                          'core-js/stable'
import                          'regenerator-runtime/runtime'
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
var current_user = JSON.parse(window.current_user.replace(/&quot;/g,'"'))
var permissions = {}
for (var key in current_user.privilege) {
  if (['id', 'created_at', 'updated_at', 'user_id'].includes(key)) continue
  var value = current_user.privilege[key]
  permissions[key] = {
    read: value.includes('R'),
    write: value.includes('W'),
    delete: value.includes('D')
  }
}

Vue.prototype.$currentUser = current_user
Vue.prototype.$permissions = permissions

// eslint-disable-next-line no-unused-vars
const app = new Vue({
  router,
  el: '#users',
  template: '<Users />',
  components: { Users }
})
