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
      template: `<li class='string input required stringish' id='user_address_input_gmap'><label for='user_address_input_gmap' class='label'>Address</label><GmapAutocomplete class='gmap-input' :class="{'error' : apiError}" @place_changed="updateAddress" :value="address" @input.stop="address=$event.target.value" @keypress.enter="$event.preventDefault"></GmapAutocomplete><div v-if="isAddressDrawn" class='gmap-wraper'><GmapMap map-type-id="terrain" ref="googlemap" :zoom="15" :options="{rotateControl: false, minZoom: 2, zoomControl: true, mapTypeControl: false, scaleControl: false, streetViewControl: false, fullscreenControl: false}" style="width: 100%; height: 99%" :center="center"><GmapMarker :animation="4" :position="getLatLng" /></GmapMap></div><p v-if="apiError" class="inline-errors">{{apiError}}</p></li>`
    });
  }

  // user form phone_number_tab
  if ($("#user_phone_number-tab").is(":visible"))
  {
    Vue.component('vue-phone-number-input', window['vue-phone-number-input'])
    var phone_number = new Vue({
      el: "#user_phone_number-tab",
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
        this.phoneNumber = $("#user_phone_number").val();
        this.countryCode = $("#user_country_code").val();
        this.loading = false
      },
      methods: {
        setApiError() {
          this.apiError = $("#user_phone_number_input p").text() || '';
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
          $("#user_phone_number").val(ph_number);
        },
        countryCode(value) {
          $("#user_country_code").val(this.countryCode);
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
      template: `<li class='string input required stringish' id='user_phone_number_input_tel'><label for='user_phone_number_input_tel' class='label'>Phone number</label><div v-if="!loading"><vue-phone-number-input :value="phone" @update="onUpdate" id="phone-number__input" :default-country-code="code" ></vue-phone-number-input></div><p v-if="apiError" class="inline-errors">{{apiError}}</p></li>`
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
          $("#facility_country_code").val(this.countryCode);
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

  // task/issue form slider tab
  if ($("#progress_slider-tab").is(":visible"))
  {
    Vue.component('vue-slide-bar', vueSlideBar)
    var slider = new Vue({
      el: "#progress_slider-tab",
      data() {
        return {
          progress: 0
        }
      },
      mounted() {
        this.progress = $("#task_progress").val() || $("#issue_progress").val() || 0
      },
      watch: {
        progress(value) {
          $("#task_progress").val(value)
          $("#issue_progress").val(value)
        }
      },
      template: `<li class='string input required stringish' id='task_progress_input_slider'><label  class='label'>Progress<abbr title="required">*</abbr></label><div class="task-progress-slide"><vue-slide-bar v-model="progress" :line-height="8" /></div></li>`
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

  // facilities projects list
  if ($("#facility_projects-tab").css('display') === 'block')
  {
    var facility_id = $("#facility_projects-tab") ? $("#facility_projects-tab").data().key : ''
    var facility_projects_tab = new Vue({
      el: "#facility_projects-tab",
      data() {
        return {
          loading: true,
          editable: false,
          projects: [],
          project: {}
        }
      },
      mounted() {
        var cb = () => this.loading = false;
        this.fetchFacilityProjects(cb);
      },
      methods: {
        fetchFacilityProjects(cb) {
          $.get(`/facilities/${facility_id}/facility_projects.json`, (data) => {
            this.projects = data;
            this.fetchStatuses(cb);
          });
        },
        fetchStatuses(cb) {
          $.get("/api/statuses.json", (data) => {
            this.statuses = data.statuses;
            return cb();
          });
        },
        openEditModal(project) {
          $("body").append('<div id="dimmer" class="ui-widget-overlay ui-front" style="z-index: 1001;"></div>');
          this.editable = true;
          this.project = Object.assign({}, project);
        },
        handleClose() {
          this.editable = false;
          $("#dimmer").remove();
          this.project = {};
        },
        handleSubmit() {
          var data = {facility_project: {due_date: this.project.due_date, status_id: this.project.status_id}}
          var _this = this
          $.ajax({
            url: `/facilities/${facility_id}/facility_projects/${this.project.id}.json`,
            type: 'PUT',
            data: data,
            success: function(res) {
              var index = _this.projects.findIndex(p => p.id === res.id)
              _this.projects[index] = res
              _this.handleClose()
            }
          });
        }
      },
      computed: {
        shouldVisible() {
          return true
          return $('#advanced').css('display') === 'block'
        }
      },
      template: `<div v-if="!loading">
        <div v-show="shouldVisible" id='project_vue_tab' class="index_as_table">
          <table border="0" cellspacing="0" cellpadding="0" class="index_table index" paginator="true">
            <thead>
              <tr>
                <th class="sortable col col-project"><a href="#">Project</a></th>
                <th class="sortable col col-due_date"><a href="#">Due Date</a></th>
                <th class="sortable col col-status"><a href="#">Status</a></th>
                <th class="col col-actions"></th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="project in projects" :key="project.id">
                <td class="col col-project">{{project.project.name}}</td>
                <td class="col col-due_date">{{project.due_date || '-'}}</td>
                <td class="col col-status">{{project.status_name || '-'}}</td>
                <td class="col col-actions">
                  <div class="table_actions">
                    <a class="edit_link member_link" title="Edit" href="#" @click.prevent="openEditModal(project)">Edit</a>
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
        <div v-if="editable">
          <div tabindex="-1" role="dialog" style="position: fixed; height: auto; width: 300px; top: 155.625px; left: 489.578px;" class="ui-dialog ui-corner-all ui-widget ui-widget-content ui-front active_admin_dialog ui-dialog-buttons ui-draggable ui-resizable" aria-describedby="dialog_confirm" aria-labelledby="ui-id-1">
            <div class="ui-dialog-titlebar ui-corner-all ui-widget-header ui-helper-clearfix ui-draggable-handle">
              <span id="ui-id-1" class="ui-dialog-title">Are you sure you want to do this?</span>
              <button type="button" class="ui-button ui-corner-all ui-widget ui-button-icon-only ui-dialog-titlebar-close" title="Close">
                <span class="ui-button-icon ui-icon ui-icon-closethick"></span>
                <span class="ui-button-icon-space"> </span>Close</button>
            </div>
            <form id="dialog_confirm" class="ui-dialog-content ui-widget-content" style="width: auto; min-height: 49.25px; max-height: none; height: auto;">
              <ul>
                <li>
                  <label>Project</label>
                  <input name="project" class="text" type="text" readOnly :value="project.project.name">
                </li>
                <li>
                  <label>Status</label>
                  <select name="Status" class="" v-model="project.status_id">
                    <option v-for="status in statuses" :value="status.id">{{status.name}}</option>
                  </select>
                </li>
                <li>
                  <label>Due Date</label>
                  <input name="Due Date" class="datepicker" type="date" v-model="project.due_date">
                </li>
              </ul>
            </form>
            <div class="ui-dialog-buttonpane ui-widget-content ui-helper-clearfix">
              <div class="ui-dialog-buttonset">
                <button type="button" class="ui-button ui-corner-all ui-widget" @click.prevent="handleSubmit">OK</button>
                <button type="button" class="ui-button ui-corner-all ui-widget" @click="handleClose">Cancel</button>
              </div>
            </div>
          </div>
        </div>
      </div>`
    });
  }

  // user role previliges
  if ($("#user_privileges_collection_input").is(":visible"))
  {
    var previliges = $("input#user_privileges").val();
    if(previliges !== undefined)
      previliges.split(",").map(p => {
        if (p) $(`input[value=${p.trim()}]`).prop("checked", true);
      });
  }

  var togglePrivileges = function () {
    var show = $("#user_role").val() === 'subscriber'
    $("#__privileges").css({display: show ? 'block' : 'none'})
  }

  $(document).on('ready page:load turbolinks:load', function() {

    if ($("#user_role").is(":visible"))
    {
      togglePrivileges()
      $("#user_role").change(function(e) {
        togglePrivileges()
      })
    }

    // add assign/unassign inputs in dialog_form
    $("a[data-action='Assign/Unassign Facility Group'], a[data-action='Assign/Unassign Project']").click(function(e) {
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

  // password generator tab
  if ($("#user-password__tab").is(":visible"))
  {
    var settings = new Vue({
      el: "#user-password__tab",
      data() {
        return {
          password: '',
          confirm_password: '',
          range: 12,
          uppercase: true,
          lowercase: true,
          numbers: true,
          special_chars: true
        }
      },
      mounted() {
        var user_id = $("#user_email").data().id
        if (!user_id) this.generatePassword()
      },
      methods: {
        generatePassword() {
          var chars = [...Array(Number(this.range))].map(i=>(~~(Math.random()*36)).toString(36)).join('');
          var pass = "";
          if (this.uppercase || this.lowercase || this.numbers || this.special_chars)
          {
            chars = "";
            if (this.uppercase) chars = chars + "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
            if (this.numbers) chars = chars + "1234567890"
            if (this.special_chars) chars = chars + "!@#$%^&*()";
            if (this.lowercase) chars = chars + "abcdefghijklmnopqrstuvwxyz";
            for (var i=0; i<Number(this.range); i++) {
              pass += chars.charAt(Math.floor(Math.random() * chars.length));
            }
          }
          else {
            var pass = chars;
          }
          this.password = pass;
        },
        copyPassword() {
          var copyText = document.getElementById("__password");
          copyText.select();
          copyText.setSelectionRange(0, 99999);
          document.execCommand("copy");
        }
      },
      watch: {
        password(value) {
          $("#user_password").val(value);
          $("#user_password_confirmation").val(value);
        }
      },
      template: `<div id="pass-word-generator-tab" class="ui-tabs-panel ui-corner-bottom ui-widget-content" aria-hidden="false">
        <fieldset class="inputs">
          <legend><span>Password Generator</span></legend>
          <ol>
            <li class="string input optional stringish">
              <label class="label">Password</label>
              <input id="__password" maxlength="25" type="text" v-model="password" readOnly="true">
              <input maxlength="25" v-model="confirm_password" type="hidden">
            </li>
            <li>
              <div class="ml-20">
                <a href="javascript:;" @click.prevent="generatePassword">Regenerate Password</a>
                <a href="javascript:;" style="margin-left: 20px" @click.prevent="copyPassword">Copy Password</a>
              </div>
            </li>
          </ol>
          <fieldset class="choices ml-20 p-5">
            <legend class="label"><label>Password Strength</label></legend>
            <ol class="choices-group">
              <li class="choice">
                <label>Length ({{range}})</label>
                <input type="range" v-model="range" min="8" max="25">
              </li>
              <li class="choice">
                <label><input type="checkbox" v-model="uppercase">A-Z</label>
              </li>
              <li class="choice">
                <label><input type="checkbox" v-model="lowercase">a-z</label>
              </li>
              <li class="choice">
                <label><input type="checkbox" v-model="numbers">0-9</label>
              </li>
              <li class="choice">
                <label><input type="checkbox" v-model="special_chars">!@#$%^&*</label>
              </li>
            </ol>
          </fieldset>
        </fieldset>
      </div>`
    });
  }
});
