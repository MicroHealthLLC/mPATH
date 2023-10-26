<template>
  <div id="users_wrapper" v-if="!loading">

    <form @submit.prevent="handleSubmit" class="w-100" autocomplete="off">
    <h5 class="my-3 bg-secondary text-light px-2">Edit User Profile</h5>
      <div class="form-group row">
        <label class="col-sm-2 col-form-label">Position</label>
        <div class="col-sm-10">
          <input type="text" class="form-control" v-model="profile.title" placeholder="Mr.">
        </div>
      </div>
      <div class="form-group row">
        <label class="col-sm-2 col-form-label">Firt Name<abbr title="required">*</abbr></label>
        <div class="col-sm-10">
          <input type="text" name="firstName" v-validate="'required'" class="form-control" v-model="profile.firstName" placeholder="John" :class="{'error': errors.has('firstName')}">
          <div v-show="errors.has('firstName')" class="text-danger mt-1">
            {{errors.first('firstName')}}
          </div>
        </div>
      </div>
      <div class="form-group row">
        <label class="col-sm-2 col-form-label">Last Name<abbr title="required">*</abbr></label>
        <div class="col-sm-10">
          <input type="text" name="lastName" v-validate="'required'" class="form-control" v-model="profile.lastName" placeholder="John" :class="{'error': errors.has('lastName') }">
          <div v-show="errors.has('lastName')" class="text-danger mt-1">
            {{errors.first('lastName')}}
          </div>
        </div>
      </div>
      <div class="form-group row">
        <label class="col-sm-2 col-form-label">Email<abbr title="required">*</abbr></label>
        <div class="col-sm-10">
          <input type="email" readOnly class="form-control" v-model="profile.email" placeholder="johndoe@example.com" autocomplete="off" required>
        </div>
      </div>
      <div class="form-group row">
        <label class="col-sm-2 col-form-label">Password <span class="font-sm text-success" @click.prevent.stop="editPass=true">(click to edit)</span></label>
        <div class="col-sm-10">
          <input type="password" class="form-control" placeholder="Password" v-model="profile.password" :readOnly="!editPass" autocomplete="off">
          <div class="ml-1">
            <div v-if="C_passValidationCheck.length" class="font-sm text-danger">{{C_passValidationCheck.length}}</div>
            <div v-if="C_passValidationCheck.uppercase" class="font-sm text-danger">{{C_passValidationCheck.uppercase}}</div>
            <div v-if="C_passValidationCheck.smallcase" class="font-sm text-danger">{{C_passValidationCheck.smallcase}}</div>
            <div v-if="C_passValidationCheck.digits" class="font-sm text-danger">{{C_passValidationCheck.digits}}</div>
            <div v-if="C_passValidationCheck.specialcase" class="font-sm text-danger">{{C_passValidationCheck.specialcase}}</div>
          </div>
        </div>
      </div>
      <div class="form-group row">
        <label class="col-sm-2 col-form-label">Password Confirmation</label>
        <div class="col-sm-10">
          <input type="password" :readOnly="!editPass" class="form-control" placeholder="Password Confirm" v-model="profile.passwordConfirmation" autocomplete="off">
          <span v-if="!C_passCheck" class="font-sm text-danger">Password mismatch</span>
        </div>
      </div>
      <div class="form-group row">
        <label class="col-sm-2 col-form-label">Phone Number</label>
        <div class="col-sm-10">
          <vue-phone-number-input
            :value="C_phone"
            @update="onUpdatePhone"
            id="phone-number__input"
            :default-country-code="C_code"
          />
        </div>
      </div>
      <div class="form-group row">
        <label class="col-sm-2 col-form-label">Address</label>
        <div class="col-sm-10">
          <GmapAutocomplete
            class='gmap-input form-control'
            @place_changed="updateAddress"
            :value="profile.address"
            @input.stop="profile.address.address=$event.target.value"
            @keypress.enter="$event.preventDefault"
          />
          <div v-if="C_addressDrawn" class='gmap-wraper'>
            <GmapMap
              map-type-id="terrain"
              ref="googlemap"
              :zoom="15"
              :options="{
                rotateControl: false,
                minZoom: 2,
                zoomControl: true,
                mapTypeControl: false,
                scaleControl: false,
                streetViewControl: false,
                fullscreenControl: false
              }"
              style="width: 100%; height: 99%"
              :center="center"
              >
              <GmapMarker
                :animation="4"
                :position="C_latLng"
              />
            </GmapMap>
          </div>
        </div>
      </div>

      <h5 class="my-3 bg-secondary text-light px-2">Preferences</h5>

      <div class="form-group row">
        <label class="col-sm-2 col-form-label">Program</label>
        <div class="col-sm-10">
             <el-select
              v-model="selectedProgram"
           
              class="w-100"
              track-by="id"
              value-key="id"
              clearable
              filterable
              placeholder="Search and select Program"
                  
            >
            <el-option
              v-for="item in programOptions"
              :value="item"
              :key="item.id"
              :label="item.name"         
            >
            </el-option>
          </el-select>       
        </div>
      </div>


      <div class="form-group row">
        <label class="col-sm-2 col-form-label">Group</label>
        <div class="col-sm-10">
            <el-select
              v-model="selectedProjectGroup"
              class="w-100"
              track-by="id"
              value-key="id"
              clearable
              filterable                 
              placeholder="Search and select Group"
              :disabled="!this.selectedProgram"
            >
            <el-option
              v-for="item in projectGroupOptions"
              :value="item"
              :key="item.id"
              :label="item.name"            
            >
            </el-option>
          </el-select>          
        </div>
      </div>

      <div class="form-group row">
        <label class="col-sm-2 col-form-label">Project</label>
        <div class="col-sm-10">
           <el-select
              v-model="selectedProject"
              class="w-100" 
              track-by="id"
              value-key="id"
              clearable
              filterable
              placeholder="Search and select Project"
              :disabled="!this.selectedProjectGroup"
            >
            <el-option
              v-for="item in projectOptions"
              :value="item"
              :key="item.id"
              :label="item.name"
            >
            </el-option>
          </el-select>        
        </div>
      </div>

      <h5 class="my-3 bg-secondary text-light px-2">Start On</h5>

      <div class="form-group row">
        <label class="col-sm-2 col-form-label">Navigation</label>
        <div class="col-sm-10">
            <el-select
              v-model="selectedNavigation"
              class="w-100"
              track-by="id"
              value-key="id"
              clearable
              filterable
              placeholder="Search and select Navigation"
              :disabled="!this.selectedProject"
               @change="navigationSelectChange"
            >
            <el-option
              v-for="item in navigationOptions"
              :value="item"
              :key="item.id"
              :label="item.name"
            >
            </el-option>
          </el-select>        
        </div>
      </div>

      <div class="form-group row">
        <label class="col-sm-2 col-form-label">Sub Navigation</label>
        <div class="col-sm-10">
            <el-select
              v-model="selectedSubNavigation"
              class="w-100"
              track-by="id"
              value-key="id"
              clearable
              filterable
              placeholder="Search and select Sub Navigation"
              :disabled="!this.selectedProject || !this.selectedNavigation"
            
            >
            <el-option
              v-for="item in subNavigationOptions"
              :value="item"
              :key="item.id"
              :label="item.name"
            >
            </el-option>
          </el-select>         
        </div>
      </div>

      <div class="form-group row d-flex justify-content-end mx-1 my-4">
        <button class="btn btn-sm btn-light mr-3 profile-btns" @click.prevent.stop="gotoDashboard">Cancel</button>
        <button class="btn btn-sm btn-primary profile-btns" :disabled="!enableEdit">Update</button>
      </div>
    </form>
  </div>
</template>

<script>
  import http from './../../common/http'
  import { API_BASE_PATH } from '../../mixins/utils';

  export default {
    data() {
      return {
        loading: true,
        editPass: false,
        navigationOptions: [],
        subNavigationOptions: [],
        programOptions: [],
        projectGroupOptions: [],
        projectOptions: [],
        allPrograms: [],
        allProjectGroups: [],
        allProjects: [],
        selectedNavigation: null,
        selectedSubNavigation: null,
        selectedProgram: null,
        selectedProject: null,
        selectedProjectGroup: null,
        profile: {
          email: '',
          firstName: '',
          lastName: '',
          title: '',
          phoneNumber: '',
          address: '',
          lat: '',
          lng: '',
          password: '',
          passwordConfirmation: '',
          countryCode: ''
        },
        // Do not change this property name.
        preferences: {
          navigationMenu: null,
          subNavigationMenu: null,
          programId: null,
          projectId: null,
          projectGroupId: null
        },
        phoneData: {},
        gmap_address: {},
        center: {lat: 40.64, lng: -74.66}
      }
    },
    mounted() {
      this.fetchProfile()
      this.navigationOptions = allowed_navigation_tabs
      this.subNavigationOptions = allowed_sub_navigation_tabs
    },
    methods: {
      navigationSelectChange(value){
        this.selectedSubNavigation = ''
        if(value.id == "kanban" || value.id == "calendar"){
          this.subNavigationOptions = _.filter(allowed_sub_navigation_tabs[this.selectedProgram.id][this.selectedProject.id], h => ["tasks", "issues", "risks"].includes(h.id))
        }else if(value.id == "map" || value.id == "sheet"){
          this.subNavigationOptions = allowed_sub_navigation_tabs[this.selectedProgram.id][this.selectedProject.id]
        }else if(['gantt_chart', 'members', 'settings'].includes(value.id) ){
          this.subNavigationOptions = []
        }
      },
      fetchProfile() {
        http.get(`${API_BASE_PATH}/current_user.json`)
          .then((res) => {

            this.profile = {...this.profile, ...res.data.currentUser}
            this.preferences = {...this.preferences, ...res.data.preferences}

            this.allPrograms  = res.data.programs
            this.allProjectGroups = res.data.projectGroups
            this.allProjects = res.data.projects
            
            let program_id = this.preferences.programId
            let project_id = this.preferences.projectId

            this.programOptions = this.allPrograms
            if(this.preferences.programId)
              this.selectedProgram = this.programOptions.find((t) => t.id === this.preferences.programId );

            if(this.selectedProgram){
              this.projectGroupOptions = this.getProjectGroups(this.selectedProgram)
              this.selectedProjectGroup = this.projectGroupOptions.find((t) => t.id === this.preferences.projectGroupId );

              if(this.selectedProjectGroup){

                this.projectOptions = this.getProjects(this.selectedProgram, this.selectedProjectGroup)
                this.selectedProject = this.projectOptions.find((t) => t.id === this.preferences.projectId );
              }
            }
            if(program_id && project_id){
              this.selectedNavigation = this.navigationOptions.find((t) => t.id === this.preferences.navigationMenu );
            }

            // this.selectedSubNavigation = this.subNavigationOptions.find((t) => t.id === this.preferences.subNavigationMenu );
            if(program_id && project_id && allowed_sub_navigation_tabs[program_id] && allowed_sub_navigation_tabs[program_id][project_id]){
              let subNavigationMenu = allowed_sub_navigation_tabs[program_id][project_id]
              if(subNavigationMenu){
                this.selectedSubNavigation = subNavigationMenu.find((t) => t.id === this.preferences.subNavigationMenu );
              }
            }else{
              this.subNavigationOptions = []
            }

            // if(!this.selectedSubNavigation && this.subNavigationOptions.length > 0){
              
            //   console.log(this.preferences.subNavigationMenu)
            //   this.selectedSubNavigation = this.subNavigationOptions[0]
            // }
            if(this.selectedNavigation){
              if(['kanban', 'calendar'].includes(this.selectedNavigation.id)){
                // this.subNavigationOptions = _.filter(allowed_sub_navigation_tabs, h => !["overview", "notes"].includes(h.id))
                this.subNavigationOptions = _.filter(allowed_sub_navigation_tabs[program_id][project_id], h => !["overview", "notes"].includes(h.id))
              }else if(this.selectedNavigation.id == "map" || this.selectedNavigation.id == "sheet"){
                if(program_id && project_id && allowed_sub_navigation_tabs[program_id][project_id]){
                  this.subNavigationOptions = allowed_sub_navigation_tabs[program_id][project_id]
                }else{
                  this.subNavigationOptions = []
                }                
              }else if(['gantt_chart', 'members', 'settings'].includes(this.selectedNavigation.id) ){
                this.subNavigationOptions = []
              }
            }

            this.gmap_address.formatted_address = this.profile.address
            if (this.C_addressDrawn) {
              this.center = {lat: this.profile.lat, lng: this.profile.lng}
            }
            this.loading = false
          })
          .catch((err) => {
            console.log(err)
          })
      },
      onUpdatePhone(data) {
        this.phoneData = data
        this.profile.phoneNumber = data.formattedNumber || ''
        this.profile.countryCode = data.countryCode || 'US'
      },
      updateAddress(address) {
        this.gmap_address = address
      },
      handleSubmit(event) {
        this.$validator.validate().then((success) => {
          if (!success || !this.enableEdit) return;
          let data = Object.assign({}, this.profile)
          let preferences = Object.assign({}, this.preferences)

          if (!this.editPass) {
            delete data.password
            delete data.passwordConfirmation
          }
          delete data.email

          if(this.selectedNavigation){
            preferences.navigationMenu = this.selectedNavigation.id
          }else{
            preferences.navigationMenu = ''
          }
          if(this.selectedSubNavigation){
            preferences.subNavigationMenu = this.selectedSubNavigation.id
          }else{
            preferences.subNavigationMenu = ''
          }

          if(this.selectedProgram){
            preferences.programId = this.selectedProgram.id
          }else{
            preferences.programId = ''
          }

          if(this.selectedProjectGroup){
            preferences.projectGroupId = this.selectedProjectGroup.id
          }else{
            preferences.projectGroupId = ''
          }

          if(this.selectedProject){
            preferences.projectId = this.selectedProject.id
          }else{
            preferences.projectId = ''
          }
          delete(data["preferences"])

          http
            .post(`${API_BASE_PATH}/profile.json`, {profile: data, preferences: preferences})
            .then((res) => {
              console.log("profile-updated")
              var pref = res.data.preferences
              if(res.data.preferenceUrl){
                window.location.pathname = res.data.preferenceUrl
              }else{
                this.gotoDashboard()
              }
              MessageDialogService.showDialog({
                response: res
              })

            })
            .catch((err) => {
              console.log(err)
            })
        })
      },
      gotoDashboard() {
        window.location.pathname = "/"
      },
      getProjectGroups(program){
        return _.filter(this.allProjectGroups, f => program.projectGroupIds.includes(f.id) )
      },
      getProjects(program, projectGroup){
        var projects = _.filter(this.allProjects, (p) => program.projectIds.includes(p.id) )
        return _.filter(projects, p => p.facilityGroupId == projectGroup.id )
      }
    },
    computed: {
      C_phone() {
        return this.phoneData.phoneNumber ? this.phoneData.formatNational : this.profile.phoneNumber
      },
      C_code() {
        return this.phoneData.phoneNumber ? this.phoneData.countryCode : this.profile.countryCode
      },
      C_addressDrawn() {
        return this.profile.lat !== '' && this.profile.lng !== ''
      },
      C_latLng() {
        this.center = {lat: Number(this.profile.lat), lng: Number(this.profile.lng)}
        return this.center
      },
      C_passCheck() {
        if (this.editPass) {
          return this.profile.password === this.profile.passwordConfirmation
        } else {
          return true
        }
      },
      C_passValidationCheck() {
        let validations = Vue.prototype.$password_key || {}
        var pass = this.profile.password
        var errors = {}
        if (this.editPass) {
          if (pass.length < Number(validations.range)) {
            errors.length = `Password should be at least ${Number(validations.range)} characters.`
          }
          if (validations.uppercase && !(/([A-Z])/g).test(pass)) {
            errors.uppercase = "Contain at least 1 uppercase letter."
          }
          if (validations.lowercase && !(/([a-z])/g).test(pass)) {
            errors.smallcase = "Contain at least 1 lowercase letter."
          }
          if (validations.numbers && !(/([\d])/g).test(pass)) {
            errors.digits = "Contain at least 1 digit."
          }
          if (validations.special_chars && !(/[ `!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?~]/g).test(pass)) {
            errors.specialcase = "Contain at least 1 special character."
          }
        }
        return errors
      },
      enableEdit() {
        let pass = this.editPass ? this.C_passCheck && this.C_passValidationCheck : true

        return pass && this.profile.email !== '' &&
               this.profile.firstName !== '' &&
               this.profile.lastName !== ''
      }
    },
    watch: {
      gmap_address: {
        handler: function(value) {
          this.profile.address = value.formatted_address
          if (value.geometry) {
            this.profile.lat = value.geometry.location.lat()
            this.profile.lng = value.geometry.location.lng()
          }
        }, deep: true
      },
      selectedProgram: {
        handler: function(value) {
          if (value){           
              this.projectGroupOptions = this.getProjectGroups(value)
              this.selectedProgram = value           
              this.selectedProject = '' 
          }else{
              this.selectedProgram = null
              this.selectedProjectGroup = null
          }
        }, deep: true
      }, 
      selectedProjectGroup: {
        handler: function(value) {
          if (value){           
            this.projectOptions = this.getProjects(this.selectedProgram, value)    
            this.selectedProjectGroup = value 
            this.selectedProject = this.projectOptions.find((t) => t.id === this.preferences.projectId )
          }else{
            this.selectedProject = null
          }
         }
      },
      selectedProject: {
        handler: function(value){
          if(!value){
            // this.selectedNavigation = null
          }
        }
      },
      selectedNavigation: {
        handler: function(value){
          if(!value){
            // this.selectedSubNavigation = null
          }
        }
      }
    }
  };
</script>

<style lang="scss" scoped>
  #users_wrapper {
    padding: 20px;
    height: calc(100vh - 94px);
    width: 80%;
    margin: 0 auto;
    display: flex;
    flex-wrap: wrap;
  }
  .gmap-wraper {
    width: 100%;
    height: 300px;
    margin-top: 10px;
  }
  abbr {
    border: 0;
    text-decoration: none;
    color: #dc3545;
  }
  input.error {
    border-color: #dc3545;
  }


</style>
