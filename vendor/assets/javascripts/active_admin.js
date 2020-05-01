//= require active_admin/base
//= require jquery_ujs
//= require 'node_modules/vue2-google-maps/dist/vue-google-maps.js'
//= require 'node_modules/vue-tel-input/dist/vue-tel-input.min.js'

jQuery(function($) {
  // project index page
  $("#index_table_projects td.col-status").each(function() {
    this.parentElement.classList.value = "";
    this.parentElement.classList.add(`status_${$(this).text()}`);
  })

  // facility_group index page
  $("#index_table_facility_groups td.col-status").each(function() {
    this.parentElement.classList.value = "";
    this.parentElement.classList.add(`status_${$(this).text()}`);
  })

  // facility form google-map
  if ($("#gmaps-tab").is(":visible")){
    Vue.use(VueGoogleMaps, {
      load: {
        key: 'AIzaSyCAE5VIs52m1DN5Acuk9NudjSEKYmQwmi0',
        libraries: 'places',
      },
      installComponents: true
    });

    var GmapAutocomplete = VueGoogleMaps.Autocomplete;
    var gmap = new Vue({
      el: "#gmaps-tab",
      components: {GmapAutocomplete},
      data() {
        return {
          center: {lat: 40.64, lng: -74.66},
          address: '',
          lat: '',
          lng: '',
          apiError: '',
          gmap_address: {}
        }
      },
      mounted() {
        this.setApiError();
        this.address = $("#facility_address").val();
        this.gmap_address.formatted_address = this.address;
        this.lat = $("#facility_lat").val();
        this.lng = $("#facility_lng").val();
        if (this.isAddressDrawn) {
          this.center = {lat: this.lat, lng: this.lng}
        }
      },
      methods: {
        setApiError() {
          this.apiError = $("#facility_address_input p").text() || '';
        },
        updateAddress(address) {
          this.gmap_address = address;
        }
      },
      computed: {
        isAddressDrawn() {
          return this.lat !== '' && this.lng !== '';
        },
        getLatLng() {
          this.center = {lat: Number(this.lat), lng: Number(this.lng)}
          return this.center;
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
      template: `<li class='string input required stringish' id='facility_address_input_gmap'>
          <label for='facility_address_input_gmap' class='label'>Address<abbr title="required">*</abbr></label>
          <GmapAutocomplete class='gmap-input' :class="{'error' : apiError}" @place_changed="updateAddress" :value="address" @input.stop="address=$event.target.value" @keypress.enter="$event.preventDefault"></GmapAutocomplete>
          <div v-if="isAddressDrawn" class='gmap-wraper'><GmapMap map-type-id="terrain" ref="googlemap" :zoom="15" :options="{rotateControl: false, minZoom: 2, zoomControl: true, mapTypeControl: false, scaleControl: false, streetViewControl: false, fullscreenControl: false}" style="width: 100%; height: 99%" :center="center"><GmapMarker :animation="4" :position="getLatLng" /></GmapMap></div><p v-if="apiError" class="inline-errors">{{apiError}}</p></li>`
    });
  }
// User form google-map
  if ($("#user-gmaps-tab").is(":visible"))
  {
    Vue.use(VueGoogleMaps, {
      load: {
        key: 'AIzaSyCAE5VIs52m1DN5Acuk9NudjSEKYmQwmi0',
        libraries: 'places',
      },
      installComponents: true
    });

    var GmapAutocomplete = VueGoogleMaps.Autocomplete;
    var gmap = new Vue({
      el: "#user-gmaps-tab",
      components: {GmapAutocomplete},
      data() {
        return {
          center: {lat: 40.64, lng: -74.66},
          address: '',
          lat: '',
          lng: '',
          apiError: '',
          gmap_address: {}
        }
      },
      mounted() {
        this.setApiError();
        this.address = $("#user_address").val();
        this.gmap_address.formatted_address = this.address;
        this.lat = $("#user_lat").val();
        this.lng = $("#user_lng").val();
        if (this.isAddressDrawn) {
          this.center = {lat: this.lat, lng: this.lng}
        }
      },
      methods: {
        setApiError() {
          this.apiError = $("#user_address_input p").text() || '';
        },
        updateAddress(address) {
          this.gmap_address = address;
        }
      },
      computed: {
        isAddressDrawn() {
          return this.lat !== '' && this.lng !== '';
        },
        getLatLng() {
          this.center = {lat: Number(this.lat), lng: Number(this.lng)}
          return this.center;
        }
      },
      watch: {
        gmap_address: {
          handler: function(value) {
            this.address = value.formatted_address;
            $("#user_address").val(this.address);
            if (value.geometry) {
              this.lat = value.geometry.location.lat();
              this.lng = value.geometry.location.lng();
              $("#user_lat").val(this.lat);
              $("#user_lng").val(this.lng);
            }
          }, deep: true
        }
      },
      template: `<li class='string input required stringish' id='user_address_input_gmap'><label for='user_address_input_gmap' class='label'>Address<abbr title="required">*</abbr></label><GmapAutocomplete class='gmap-input' :class="{'error' : apiError}" @place_changed="updateAddress" :value="address" @input.stop="address=$event.target.value" @keypress.enter="$event.preventDefault"></GmapAutocomplete><div v-if="isAddressDrawn" class='gmap-wraper'><GmapMap map-type-id="terrain" ref="googlemap" :zoom="15" :options="{rotateControl: false, minZoom: 2, zoomControl: true, mapTypeControl: false, scaleControl: false, streetViewControl: false, fullscreenControl: false}" style="width: 100%; height: 99%" :center="center"><GmapMarker :animation="4" :position="getLatLng" /></GmapMap></div><p v-if="apiError" class="inline-errors">{{apiError}}</p></li>`
    });
  }

  // facility form phone_number_tab
  if ($("#f_phone_number-tab").is(":visible"))
  {
    Vue.use(VueTelInput)
    var phone_number = new Vue({
      el: "#f_phone_number-tab",
      data() {
        return {
          phoneNumber: '',
          phoneError: false,
          apiError: ''
        }
      },
      mounted() {
        this.setApiError();
        this.phoneNumber = $("#facility_phone_number").val();
      },
      methods: {
        setApiError() {
          this.apiError = $("#facility_phone_number_input p").text() || '';
        },
        checkPhoneValidation(input, {isValid}) {
          this.phoneError = !isValid;
        }
      },
      watch: {
        phoneNumber(value) {
          var ph_number = this.phoneError ? '' : this.phoneNumber;
          $("#facility_phone_number").val(ph_number);
        }
      },
      template: `<li class='string input required stringish' id='facility_phone_number_input_tel'><label for='facility_phone_number_input_tel' class='label'>Phone number<abbr title="required">*</abbr></label><vue-tel-input v-model="phoneNumber" :required="true" :valid-characters-only="true" name="phonenumber" default-country="US" @input="checkPhoneValidation" class="form-control" :class="{'error': phoneError || apiError}"></vue-tel-input><p v-if="apiError" class="inline-errors">{{apiError}}</p></li>`
    });
  }
});
