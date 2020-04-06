//= require active_admin/base
//= require jquery_ujs
//= require 'node_modules/vue2-google-maps/dist/vue-google-maps.js'

jQuery(function($) {
  // project index page
  $("#index_table_projects td.col-status").each(function() {
    this.parentElement.classList.value = "";
    this.parentElement.classList.add(`status_${$(this).text()}`);
  })

  // facility form google-map
  if ($("#gmaps-tab").is(":visible"))
  {
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
          center: {lat: 40.64, lng: -74.66},
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
        if (this.isAddressDrawn) {
          this.center = {lat: this.lat, lng: this.lng}
        }
      },
      methods: {
        updateAddress(address) {
          this.gmap_address = address;
        }
      },
      computed: {
        isAddressDrawn() {
          return this.lat !== '' && this.lng !== ''
        },
        getLatLng() {
          this.center = {lat: Number(this.lat), lng: Number(this.lng)}
          return this.center
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
      template: `<li class='string input required stringish' id='facility_address_input_gmap'><label for='facility_address_input_gmap' class='label'>Address<abbr title="required">*</abbr></label><GmapAutocomplete class='gmap-input' @place_changed="updateAddress" :value="address" @input.stop="address=$event.target.value" @keypress.enter="$event.preventDefault"></GmapAutocomplete><div v-if="isAddressDrawn" class='gmap-wraper'><GmapMap map-type-id="terrain" ref="googlemap" :zoom="15" :options="{rotateControl: false, minZoom: 2, zoomControl: true, mapTypeControl: false, scaleControl: false, streetViewControl: false, fullscreenControl: false}" style="width: 100%; height: 99%" :center="center"><GmapMarker :animation="4" :position="getLatLng" /></GmapMap></div></li>`
    });
  }
});
