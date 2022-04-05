import                           'core-js/stable'
import                           'regenerator-runtime/runtime'
import                           'vue-multiselect/dist/vue-multiselect.min.css'
import                           'vue2-datepicker/index.css'
import                           'bootstrap-vue/dist/bootstrap-vue.css'
import _                    from 'lodash'
import Multiselect          from 'vue-multiselect'
import VModal               from 'vue-js-modal'
import * as VueGoogleMaps   from 'vue2-google-maps'
import GmapCustomMarker     from 'vue2-gmap-custom-marker'
import Dashboard            from 'components/dashboard/index.vue'
import router               from 'routers/dashboard'
import store                from './../store'
import utils                from './../mixins/utils'
import VeeValidate          from 'vee-validate'
import GmapCluster          from 'vue2-google-maps/dist/components/cluster'
import VueTelInput          from 'vue-tel-input'
import DatePicker           from 'vuejs-datepicker'
import VueSlideBar          from 'vue-slide-bar'
import FadeLoader           from 'vue-spinner/src/FadeLoader.vue'
import VTooltip             from 'v-tooltip'
import V2DatePicker         from 'vue2-datepicker'
import GanttElastic         from 'gantt-elastic'
import GanttElasticHeader   from 'gantt-elastic-header'
import VuePaginate          from 'vue-paginate'
import vco                  from "v-click-outside"
import { FontAwesomeIcon }  from '@fortawesome/vue-fontawesome'
import VueDataTables        from 'vue-data-tables'


Vue.use(vco)
Vue.mixin(utils)
Vue.use(VTooltip)
Vue.use(VModal)
Vue.use(VueTelInput)
Vue.use(VuePaginate)
Vue.use(VueDataTables)
Vue.component('loader', FadeLoader)
Vue.component('gantt-elastic', GanttElastic)
Vue.component('font-awesome-icon', FontAwesomeIcon)
Vue.component('gantt-elastic-header', GanttElasticHeader)
Vue.component('vue-slide-bar', VueSlideBar)
Vue.component('date-picker', DatePicker)
Vue.component('v2-date-picker', V2DatePicker)
Vue.component('GmapCluster', GmapCluster)
Vue.component('GmapCustomMarker', GmapCustomMarker)
Vue.component('multiselect', Multiselect)
Vue.config.productionTip = false
ELEMENT.locale(ELEMENT.lang.en)
Vue.use(VeeValidate,  { fieldsBagName: 'veeFields' })

if(!window.google){
  Vue.use(VueGoogleMaps, {
    load: {
      key: window.google_api_key,
      libraries: 'places',
    },
    installComponents: true
  })
}

Vue.prototype.$mpath_instance = window.mpath_instance
var current_user = JSON.parse(window.current_user.replace(/&quot;/g,'"'))
// Format: {<program_id> : {
    // <project_id>:{
    //   modules: ["R", "W", "D"]
    // }
// }}
var projectPrivileges = JSON.parse(window.project_privilegs.replace(/&quot;/g,'"'))
var programPrivileges = JSON.parse(window.program_privilegs.replace(/&quot;/g,'"'))
var contractPrivileges = JSON.parse(window.contract_privilegs.replace(/&quot;/g,'"'))
var programSettingPrivileges = JSON.parse(window.program_settings_privileges.replace(/&quot;/g,'"'))

var projectPrivilegesRoles = JSON.parse(window.project_privilegs_roles.replace(/&quot;/g,'"'))
var programPrivilegesRoles = JSON.parse(window.program_privilegs_roles.replace(/&quot;/g,'"'))
var contractPrivilegesRoles = JSON.parse(window.contract_privilegs_roles.replace(/&quot;/g,'"'))
var programSettingPrivilegesRoles = JSON.parse(window.program_settings_privileges_roles.replace(/&quot;/g,'"')) 
var projectFacilityHash = JSON.parse(window.project_facility_hash.replace(/&quot;/g,'"')) 
 
var preferences = JSON.parse(window.preferences.replace(/&quot;/g,'"'))

var privilege = JSON.parse(window.privilege.replace(/&quot;/g,'"'))

var topNavigationPermissions = {}
for (var key in privilege) {
  if (['id', 'created_at', 'updated_at', 'user_id'].includes(key)) continue
  var value = privilege[key]
  topNavigationPermissions[key] = {
    read: value.includes('R'),
    write: value.includes('W'),
    delete: value.includes('D')
  }
}

Vue.prototype.$currentUser = current_user
Vue.prototype.$topNavigationPermissions = topNavigationPermissions
Vue.prototype.$projectPrivileges = projectPrivileges
Vue.prototype.$programPrivileges = programPrivileges
Vue.prototype.$contractPrivileges = contractPrivileges
Vue.prototype.$programSettingPrivileges = programSettingPrivileges
Vue.prototype.$projectFacilityHash = projectFacilityHash

Vue.prototype.$projectPrivilegesRoles = projectPrivilegesRoles
Vue.prototype.$programPrivilegesRoles = programPrivilegesRoles
Vue.prototype.$contractPrivilegesRoles = contractPrivilegesRoles
Vue.prototype.$programSettingPrivilegesRoles = programSettingPrivilegesRoles


Vue.prototype.$preferences = preferences

Vue.prototype.checkPrivileges = (page, salut, route, extraData) => {
  // console.log("***************** ", page)
  

  return Vue.prototype.checkPrivilegesByRoles(page, salut, route, extraData)

  
  // if(["portfolio_issue_form", "KanbanIssues", "issue_sheets_index", "issue_index", "issue_calendar", "issue_form"].includes(page) ){
  //   if (route.params.contractId) {
  //     let fPrivilege = Vue.prototype.$contractPrivileges[route.params.programId][route.params.contractId]    
  //     let permissionHash = {"write": "W", "read": "R", "delete": "D"}
  //     let s = permissionHash[salut]
  //     return fPrivilege.issues.includes(s);
  //   } else {
  //     let fPrivilege = Vue.prototype.$projectPrivileges[route.params.programId][route.params.projectId]    
  //     let permissionHash = {"write": "W", "read": "R", "delete": "D"}
  //     let s = permissionHash[salut]
  //     return fPrivilege.issues.includes(s); 
  //   }
  // }else if(["ProjectSidebar"].includes(page)){
  //   if(extraData["method"] == "isallowedProgramSettings"){
  //     let pPrivilege = Vue.prototype.$programSettingPrivileges[route.params.programId]
  //     let permissionHash = {"write": "W", "read": "R", "delete": "D"}
  //     let s = permissionHash[salut]
  //     return pPrivilege.admin_groups.includes(s) ||
  //            pPrivilege.admin_contracts.includes(s) ||
  //            pPrivilege.admin_facilities.includes(s);
  //   }else if(extraData["method"] == "isallowedContracts"){
  //     let pPrivilege = Vue.prototype.$contractPrivileges[route.params.programId][c.id]
  //     let permissionHash = {"write": "W", "read": "R", "delete": "D"}
  //     let s = permissionHash[salut]
  //     return pPrivilege.tasks.includes(s) || pPrivilege.issues.includes(s) || pPrivilege.risks.includes(s) || pPrivilege.overview.includes(s);
  //   }else{
  //     return false
  //   }

  // }
  // else if(["ContractLessons", "SheetLessons", "portfolio_lesson_form", "MapLessons", "LessonContextMenu", "ContractLessonForm", "LessonForm"].includes(page) ){
  //   if (route.params.contractId) {
  //     let fPrivilege = Vue.prototype.$contractPrivileges[route.params.programId][route.params.contractId]    
  //     let permissionHash = {"write": "W", "read": "R", "delete": "D"}
  //     let s = permissionHash[salut]
  //     return fPrivilege.lessons.includes(s);
  //   } else {
  //     let fPrivilege = Vue.prototype.$projectPrivileges[route.params.programId][route.params.projectId]    
  //     let permissionHash = {"write": "W", "read": "R", "delete": "D"}
  //     let s = permissionHash[salut]
  //     return fPrivilege.lessons.includes(s); 
  //   }

  // }else if( ["notes_show", "notes_sheets", "contract_notes_form", "notes_form", "notes_index","notes_sheets_index"].includes(page) ){
  //   if (route.params.contractId) {
  //     let fPrivilege = Vue.prototype.$contractPrivileges[route.params.programId][route.params.contractId]    
  //     let permissionHash = {"write": "W", "read": "R", "delete": "D"}
  //     let s = permissionHash[salut]
  //     return fPrivilege.notes.includes(s);
  //   } else {
  //     let fPrivilege = Vue.prototype.$projectPrivileges[route.params.programId][route.params.projectId]    
  //     let permissionHash = {"write": "W", "read": "R", "delete": "D"}
  //     let s = permissionHash[salut]
  //     return fPrivilege.notes.includes(s); 
  //   }

  // }else if( ["KanbanRisks", "risk_sheets_index", "risk_calendar", "risk_index", "risk_show", "risk_form"].includes(page) ){
  //   if (route.params.contractId) {
  //     let fPrivilege = Vue.prototype.$contractPrivileges[route.params.programId][route.params.contractId]    
  //     let permissionHash = {"write": "W", "read": "R", "delete": "D"}
  //     let s = permissionHash[salut]
  //     return fPrivilege.risks.includes(s);
  //   } else {
  //     let fPrivilege = Vue.prototype.$projectPrivileges[route.params.programId][route.params.projectId]    
  //     let permissionHash = {"write": "W", "read": "R", "delete": "D"}
  //     let s = permissionHash[salut]
  //     return fPrivilege.risks.includes(s); 
  //   }

  // }else if(["portfolio_task_form", "KanbanTasks", "task_sheet", "facility_show", "task_sheets_index", "task_index", "task_calendar", "task_form"].includes(page) ){
  //   if (route.params.contractId) {
  //     let fPrivilege = Vue.prototype.$contractPrivileges[route.params.programId][route.params.contractId]    
  //     let permissionHash = {"write": "W", "read": "R", "delete": "D"}
  //     let s = permissionHash[salut]
  //     return fPrivilege.tasks.includes(s);
  //   } else {
  //     let fPrivilege = Vue.prototype.$projectPrivileges[route.params.programId][route.params.projectId]    
  //     let permissionHash = {"write": "W", "read": "R", "delete": "D"}
  //     let s = permissionHash[salut]
  //     return fPrivilege.tasks.includes(s); 
  //   }

  // }else if( ["SheetContract", "MapAnalytics", "MapOverview", "MapProject", "SheetAnalytics", "SheetProject", "ContractAnalytics"].includes(page)){
  //   var programId = route.params.programId;
  //   var projectId = route.params.projectId
  //   let fPrivilege = Vue.prototype.$projectPrivileges[programId][projectId]
  //   let permissionHash = {"write": "W", "read": "R", "delete": "D"}
  //   let s = permissionHash[salut]
  //   return  fPrivilege.overview.includes(s);  

  // }else if( ["ProgramContractsSheet", "ProgramView","SettingsSidebar", "SettingsView" ].includes(page)){
  //   let pPrivilege = Vue.prototype.$programPrivileges[route.params.programId]        
  //   let permissionHash = {"write": "W", "read": "R", "delete": "D"}
  //   let s = permissionHash[salut]
  //   return pPrivilege.contracts.includes(s);  
  // }

  // return false;
}

Vue.prototype.findFacilityProjectId = (programId, projectId) => {
  let arr = Vue.prototype.$projectFacilityHash[programId]
  let facilityProjectId = '';
  for(var i = 0; i < arr.length; i++){
    if(arr[i].facility_id == projectId){
      facilityProjectId = arr[i].facility_project_id
      break
    }
  }
  return facilityProjectId;
} 
Vue.prototype.checkPrivilegesByRoles = (page, salut, route, extraData) => {
  console.log("***************** By role ", page, salut, route, extraData, Vue.prototype.$contractPrivilegesRoles, Vue.prototype.$projectPrivilegesRoles, Vue.prototype.$programSettingPrivilegesRoles )

  let permissionHash = {"write": "W", "read": "R", "delete": "D"}
  let s = permissionHash[salut]
  let program_id = route.params.programId
  let contract_id = route.params.contractId
  let project_id = route.params.projectId

  if(["portfolio_issue_form", "KanbanIssues", "issue_sheets_index", "issue_index", "issue_calendar", "issue_form"].includes(page) ){


    if (contract_id) {

      let contract_privileges = Vue.prototype.$contractPrivilegesRoles[contract_id]             
      return contract_privileges && contract_privileges.contract_issues && contract_privileges.contract_issues.includes(s);

    } else {

      let facility_project_id = Vue.prototype.findFacilityProjectId(program_id, project_id)
      let facility_project_privileges = Vue.prototype.$projectPrivilegesRoles[facility_project_id]
      console.log("facility_project_id", facility_project_id)          
      return facility_project_privileges && facility_project_privileges.project_issues && facility_project_privileges.project_issues.includes(s);
    }
  }else if(["ProjectSidebar"].includes(page)){

    let pPrivileges = Vue.prototype.$programSettingPrivilegesRoles
    if(extraData["method"] == "isallowedProgramSettings"){
      return pPrivileges['program_setting_groups'] && pPrivileges['program_setting_groups'].includes(permissionHash[salut]) || pPrivileges['program_setting_contracts']  && pPrivileges['program_setting_contracts'].includes(permissionHash[salut]) || pPrivileges['program_setting_projects']  && pPrivileges['program_setting_projects'].includes(permissionHash[salut]) ||  pPrivileges['program_setting_users_roles']  && pPrivileges['program_setting_users_roles'].includes(permissionHash[salut])
    
    }else if(extraData["method"] == "isallowedContracts"){
      
      let pPrivileges = Vue.prototype.$contractPrivilegesRoles

      let contract_privileges = pPrivileges[extraData["contract_id"]]

      return contract_privileges && (contract_privileges.contract_analytics || contract_privileges.contract_issues || contract_privileges.contract_lessons || contract_privileges.contract_notes || contract_privileges.contract_risks || contract_privileges.contract_tasks);
    }else{
      return false
    }

  }else if(["ContractLessons", "SheetLessons", "portfolio_lesson_form", "MapLessons", "LessonContextMenu", "ContractLessonForm", "LessonForm"].includes(page) ){

    if (contract_id) {

      let contract_privileges = Vue.prototype.$contractPrivilegesRoles[contract_id]             
      return contract_privileges && contract_privileges.contract_lessons && contract_privileges.contract_lessons.includes(s);

    } else {

      let facility_project_id = Vue.prototype.findFacilityProjectId(program_id, project_id)
      let facility_project_privileges = Vue.prototype.$projectPrivilegesRoles[facility_project_id]             
      return facility_project_privileges && facility_project_privileges.project_lessons && facility_project_privileges.project_lessons.includes(s);
    }

  }else if( ["notes_show", "notes_sheets", "contract_notes_form", "notes_form", "notes_index","notes_sheets_index"].includes(page) ){

    if (contract_id) {

      let contract_privileges = Vue.prototype.$contractPrivilegesRoles[contract_id]             
      return contract_privileges && contract_privileges.contract_notes && contract_privileges.contract_notes.includes(s);

    } else {

      let facility_project_id = Vue.prototype.findFacilityProjectId(program_id, project_id)
      let facility_project_privileges = Vue.prototype.$projectPrivilegesRoles[facility_project_id]             
      return facility_project_privileges && facility_project_privileges.project_notes && facility_project_privileges.project_notes.includes(s);
    }

  }else if( ["KanbanRisks", "risk_sheets_index", "risk_calendar", "risk_index", "risk_show", "risk_form"].includes(page) ){

    if (contract_id) {

      let contract_privileges = Vue.prototype.$contractPrivilegesRoles[contract_id]             
      return contract_privileges && contract_privileges.contract_risks && contract_privileges.contract_risks.includes(s);

    } else {

      let facility_project_id = Vue.prototype.findFacilityProjectId(program_id, project_id)
      let facility_project_privileges = Vue.prototype.$projectPrivilegesRoles[facility_project_id]             
      return facility_project_privileges && facility_project_privileges.project_risks && facility_project_privileges.project_risks.includes(s);
    }

  }else if(["portfolio_task_form", "KanbanTasks", "task_sheet", "facility_show", "task_sheets_index", "task_index", "task_calendar", "task_form"].includes(page) ){

    if (contract_id) {

      let contract_privileges = Vue.prototype.$contractPrivilegesRoles[contract_id]             
      return contract_privileges && contract_privileges.contract_tasks && contract_privileges.contract_tasks.includes(s);

    } else {
      let facility_project_id = Vue.prototype.findFacilityProjectId(program_id, project_id)
      let facility_project_privileges = Vue.prototype.$projectPrivilegesRoles[facility_project_id]
      return facility_project_privileges && facility_project_privileges.project_tasks && facility_project_privileges.project_tasks.includes(s);
    }

  }else if( ["SheetContract", "MapAnalytics", "MapOverview", "MapProject", "SheetAnalytics", "SheetProject", "ContractAnalytics"].includes(page)){

    if (contract_id) {

      let contract_privileges = Vue.prototype.$contractPrivilegesRoles[contract_id]             
      return contract_privileges && contract_privileges.contract_analytics && contract_privileges.contract_analytics.includes(s);

    } else {

      let facility_project_id = Vue.prototype.findFacilityProjectId(program_id, project_id)
      let facility_project_privileges = Vue.prototype.$projectPrivilegesRoles[facility_project_id]
      return facility_project_privileges && facility_project_privileges.project_analytics && facility_project_privileges.project_analytics.includes(s);
    }

  }else if( ["ProgramContractsSheet", "ProgramView","SettingsSidebar" ].includes(page)){
    let pPrivilege = Vue.prototype.$programPrivileges[route.params.programId]        
    let permissionHash = {"write": "W", "read": "R", "delete": "D"}
    let s = permissionHash[salut]
    return pPrivilege.contracts.includes(s);

  }else if( ["SettingsView", "SettingsGroups", "SettingsProjects", "SettingsContracts" ].includes(page)){
    let permissionHash = {"write": "W", "read": "R", "delete": "D"}
    let pPrivileges = Vue.prototype.$programSettingPrivilegesRoles

    if(extraData['settingType'] == 'Groups' && pPrivileges['program_setting_groups'] && pPrivileges['program_setting_groups'].includes(permissionHash[salut])){
      return true
    }else if(extraData['settingType'] == 'Contracts' && pPrivileges['program_setting_contracts']  && pPrivileges['program_setting_contracts'].includes(permissionHash[salut])){
      return true
    }else if(extraData['settingType'] == 'Projects'  && pPrivileges['program_setting_projects']  && pPrivileges['program_setting_projects'].includes(permissionHash[salut])){
      return true
    }else if(extraData['settingType'] == 'Users'  && pPrivileges['program_setting_users_roles']  && pPrivileges['program_setting_users_roles'].includes(permissionHash[salut])){
      return true
    }

  }

  return false;
}

// eslint-disable-next-line no-unused-vars
const dashboardApp = new Vue({
  router,
  store,
  el: '#dashboard',
  vuetify: new Vuetify(),
  template: '<Dashboard />',
  components: { Dashboard }
})
