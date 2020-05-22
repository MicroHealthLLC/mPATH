//= require active_admin/base
//= require jquery_ujs
//= require 'node_modules/vue2-google-maps/dist/vue-google-maps.js'
//= require 'node_modules/vue-slide-bar/lib/vue-slide-bar.min.js'
//= require 'node_modules/vue-phone-number-input/dist/vue-phone-number-input.umd.js'

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
  if ($("#gmaps-tab").is(":visible"))
  {
    var google_map_key = $("#gmap-key") ? $("#gmap-key").data().key : ""
    Vue.use(VueGoogleMaps, {
      load: {
        key: google_map_key,
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
      template: `<li class='string input required stringish' id='facility_address_input_gmap'><label for='facility_address_input_gmap' class='label'>Address<abbr title="required">*</abbr></label><GmapAutocomplete class='gmap-input' :class="{'error' : apiError}" @place_changed="updateAddress" :value="address" @input.stop="address=$event.target.value" @keypress.enter="$event.preventDefault"></GmapAutocomplete><div v-if="isAddressDrawn" class='gmap-wraper'><GmapMap map-type-id="terrain" ref="googlemap" :zoom="15" :options="{rotateControl: false, minZoom: 2, zoomControl: true, mapTypeControl: false, scaleControl: false, streetViewControl: false, fullscreenControl: false}" style="width: 100%; height: 99%" :center="center"><GmapMarker :animation="4" :position="getLatLng" /></GmapMap></div><p v-if="apiError" class="inline-errors">{{apiError}}</p></li>`
    });
  }

  // User form google-map
  if ($("#user-gmaps-tab").is(":visible"))
  {
    var google_map_key = $("#gmap-key") ? $("#gmap-key").data().key : ""
    Vue.use(VueGoogleMaps, {
      load: {
        key: google_map_key,
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
    Vue.component('vue-phone-number-input', window['vue-phone-number-input'])
    var phone_number = new Vue({
      el: "#f_phone_number-tab",
      data() {
        return {
          phoneData: {},
          phoneNumber: '',
          countryCode: '',
          loading: true,
          error: false,
          apiError: ''
        }
      },
      mounted() {
        this.setApiError();
        this.phoneNumber = $("#facility_phone_number").val();
        this.countryCode = $("#facility_country_code").val();
        this.loading = false
      },
      methods: {
        setApiError() {
          this.apiError = $("#facility_phone_number_input p").text() || '';
        },
        onUpdate(data) {
          this.phoneData = data
          this.error = !data.isValid
          if (data.formattedNumber)
          {
            this.phoneNumber = data.formattedNumber
            this.countryCode = data.countryCode
          }
        }
      },
      watch: {
        phoneNumber(value) {
          var ph_number = this.error ? '' : this.phoneNumber;
          $("#facility_phone_number").val(ph_number);
        },
        countryCode(value) {
          var code = this.error ? '' : this.countryCode;
          $("#facility_country_code").val(code);
        }
      },
      computed: {
        phone() {
          return this.phoneData.phoneNumber ? this.phoneData.formatNational : this.phoneNumber
        },
        code() {
          return this.phoneData.phoneNumber ? this.phoneData.countryCode : this.countryCode
        }
      },
      template: `<li class='string input required stringish' id='facility_phone_number_input_tel'><label for='facility_phone_number_input_tel' class='label'>Phone number<abbr title="required">*</abbr></label><div v-if="!loading"><vue-phone-number-input :value="phone" @update="onUpdate" id="phone-number__input" :default-country-code="code" ></vue-phone-number-input></div><p v-if="apiError" class="inline-errors">{{apiError}}</p></li>`
    });
  }

  // settings page
  if ($("#settings_container").is(":visible"))
  {
    var settings = new Vue({
      el: "#settings_container",
      data() {
        return {
          currentTab: 1,
          isEditing: false,
          loading: true,
          settings: {
            office365_key: '',
            office365_secret: '',
            google_map_key: '',
            google_oauth_key: '',
            google_oauth_secret: ''
          }
        }
      },
      mounted() {
        this.fetchSettings()
      },
      computed: {
        textType() {
          return this.isEditing ? 'text' : 'password'
        }
      },
      methods: {
        submitSettings() {
          $.post("/api/settings.json", {settings: this.settings}, (data) => {
            window.location.href = "/admin/settings"
          });
        },
        fetchSettings() {
          $.get("/api/settings.json", (data) => {
            for (var key in this.settings) {
              this.settings[key] = data[key] || ''
            }
            this.loading = false
          });
        }
      },
      template: `<div>
        <button class="edit-creds" :class="{'vue__disabled': isEditing}" @click.stop="isEditing=true">Edit</button>
        <form v-if="!loading" class="formtastic settings" @submit.prevent="submitSettings">
          <div class="tabs ui-tabs ui-corner-all ui-widget ui-widget-content">
            <ul class="nav nav-tabs ui-tabs-nav ui-corner-all ui-helper-reset ui-helper-clearfix ui-widget-header" role="tablist">
              <li role="tab" tabindex="0" class="ui-tabs-tab ui-corner-top ui-state-default ui-tab" aria-controls="office365" aria-labelledby="ui-id-1" :class="{'ui-tabs-active ui-state-active': currentTab == 1}"><a @click.stop.prevent="currentTab = 1" role="presentation" tabindex="-1" class="ui-tabs-anchor" id="ui-id-1">Office 365</a></li>
              <li role="tab" tabindex="-1" class="ui-tabs-tab ui-corner-top ui-state-default ui-tab" aria-controls="google_oauth" aria-labelledby="ui-id-2" :class="{'ui-tabs-active ui-state-active': currentTab == 2}"><a @click.stop.prevent="currentTab = 2" role="presentation" tabindex="-1" class="ui-tabs-anchor" id="ui-id-2">Google OAuth</a></li>
              <li role="tab" tabindex="-1" class="ui-tabs-tab ui-corner-top ui-state-default ui-tab" aria-controls="google_map" aria-labelledby="ui-id-3" :class="{'ui-tabs-active ui-state-active': currentTab == 3}"><a @click.stop.prevent="currentTab = 3" role="presentation" tabindex="-1" class="ui-tabs-anchor" id="ui-id-3">Google Maps</a></li>
            </ul>
            <div class="tab-content">
              <div id="office365" aria-labelledby="ui-id-1" role="tabpanel" class="ui-tabs-panel ui-corner-bottom ui-widget-content" aria-hidden="false" v-show="currentTab === 1">
                <fieldset class="inputs"><legend><span>Office 365</span></legend>
                  <ol>
                    <li class="string input required stringish" id="office365_key_input"><label class="label">Office 365 key<abbr title="required">*</abbr></label><input :readOnly="!isEditing" id="office365_key" v-model="settings.office365_key" type="text"></li>
                    <li class="string input required stringish" id="office365_secret_input"><label class="label">Office 365 secret<abbr title="required">*</abbr></label><input :readOnly="!isEditing" id="office365_secret" v-model="settings.office365_secret" :type="textType"></li>
                  </ol>
                </fieldset>
              </div>
              <div id="google_oauth" aria-labelledby="ui-id-2" role="tabpanel" class="ui-tabs-panel ui-corner-bottom ui-widget-content" aria-hidden="true" v-show="currentTab === 2">
                <fieldset class="inputs"><legend><span>Google OAuth</span></legend>
                  <ol>
                    <li class="string input required stringish" id="google_oauth_key_input"><label class="label">Google oauth key<abbr title="required">*</abbr></label><input :readOnly="!isEditing" id="google_oauth_key" v-model="settings.google_oauth_key" type="text"></li>
                    <li class="string input required stringish" id="google_oauth_secret_input"><label class="label">Google oauth secret<abbr title="required">*</abbr></label><input :readOnly="!isEditing" id="google_oauth_secret" v-model="settings.google_oauth_secret" :type="textType"></li>
                  </ol>
                </fieldset>
              </div>
              <div id="google_map" aria-labelledby="ui-id-3" role="tabpanel" class="ui-tabs-panel ui-corner-bottom ui-widget-content" aria-hidden="true" v-show="currentTab === 3">
                <fieldset class="inputs"><legend><span>Google Maps</span></legend>
                  <ol>
                    <li class="string input required stringish" id="google_maps_key_input"><label class="label">Google maps key<abbr title="required">*</abbr></label><input :readOnly="!isEditing" id="google_maps_key" v-model="settings.google_map_key" type="text"></li>
                  </ol>
                </fieldset>
              </div>
            </div>
          </div>
          <fieldset class="actions" v-show="isEditing">
            <ol>
              <li class="action input_action " id="submit_settings"><input :readOnly="!isEditing" type="submit"></li>
            </ol>
          </fieldset>
        </form>
      </div>`
    });
  }

  // user role previliges
  if ($("#user_privileges_collection_input").is(":visible"))
  {
    var previliges = $("input#user_privileges").val();
    previliges.split(",").map(p => {
      $(`input[value=${p}]`).prop("checked", true);
    });
  }

  $(document).on('ready page:load turbolinks:load', function() {

    // add assign/unassign inputs in dialog_form
    $("a[data-action='Assign/Unassign Facility Group']").click(function(e) {
      e.stopPropagation();
      e.preventDefault();

      var input = $("form#dialog_confirm input[name=assign]")
      var li = input.parent()
      var ul = li.parent()
      li.remove()
      ul.prepend("<li class='radio__group'><input name='assign' type='radio' value='assign' checked><label>Assign</label><input name='assign' type='radio' value='unassign'><label>Unassign</label></li>");
    })

    // task form #slider
    $('a[data-action=add_task]').click(function(e) {
      e.stopPropagation();
      e.preventDefault();

      var input = $("form#dialog_confirm input[name=Progress]")
      var parent = input.parent()
      input.css({display: 'none'})
      parent.append("<div id='progress_slider'></div>");

      if ($("#progress_slider").is(":visible"))
      {
        Vue.component('vue-slide-bar', vueSlideBar)
        var progress_slider = new Vue({
          el: "#progress_slider",
          data() {
            return {
              progress: 0
            }
          },
          mounted() {
            $("input[name=Progress]").val(this.progress)
          },
          watch: {
            progress(value) {
              $("input[name=Progress]").val(value)
            }
          },
          template: `<div class="progress-slide"><vue-slide-bar v-model="progress" :line-height="8" /></div>`
        });
      }
    })
  }());

});
