//= require active_admin/base
//= require jquery_ujs
//= require 'node_modules/vue2-google-maps/dist/vue-google-maps.js'

jQuery(function($) {
  Vue.use(VueGoogleMaps, {
    load: {
      key: 'AIzaSyCAE5VIs52m1DN5Acuk9NudjSEKYmQwmi0',
      libraries: 'places',
    },
    installComponents: true
  });

  var GmapAutocomplete = VueGoogleMaps.Autocomplete;
  var test = new Vue({
    el: "#gmaps-tab",
    components: {GmapAutocomplete},
    data() {
      return {
        address: '',
        lat: '',
        lng: '',
        gmap_address: {}
      }
    },
    mounted() {
      this.address = $("#facility_address").val();
      this.gmap_address.formatted_address = this.address;
      this.lat = $("#facility_lat").val();
      this.lng = $("#facility_lng").val();
    },
    methods: {
      updateAddress(address) {
        this.gmap_address = address;
      }
    },
    watch: {
      gmap_address: {
        handler: function(value) {
          this.address = value.formatted_address;
          $("#facility_address").val(this.address);
          if (value.geometry) {
            this.lat = value.geometry.location.lat();
            this.lng = value.geometry.location.lng();
            $("#facility_lat").val(this.lat);
            $("#facility_lng").val(this.lng);
          }
        }, deep: true
      }
    },
    template: `<li class='string input required stringish' id='facility_address_input_gmap'><label for='facility_address_input_gmap' class='label'>Address<abbr title="required">*</abbr></label><GmapAutocomplete class='gmap-input' @place_changed="updateAddress" :value="address" @input.stop="address=$event.target.value" @keypress.enter="$event.preventDefault"></GmapAutocomplete></li>`
  });
});
