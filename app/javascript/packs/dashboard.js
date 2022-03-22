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

Vue.prototype.$preferences = preferences

Vue.prototype.checkPrivileges = (page, salut, route) => {
  console.log("*****************")
  console.log(page)
  
  if(page == "issue_form"){
    if (route.params.contractId) {
      let fPrivilege = Vue.prototype.$contractPrivileges[route.params.programId][route.params.contractId]    
      let permissionHash = {"write": "W", "read": "R", "delete": "D"}
      let s = permissionHash[salut]
      return fPrivilege.issues.includes(s);
    } else {
      let fPrivilege = Vue.prototype.$projectPrivileges[route.params.programId][route.params.projectId]    
      let permissionHash = {"write": "W", "read": "R", "delete": "D"}
      let s = permissionHash[salut]
      return false //fPrivilege.issues.includes(s); 
    }
  }else if(page == "task_sheet"){
    var programId = this.$route.params.programId;
    var projectId = this.$route.params.projectId
    let fPrivilege = this.$projectPrivileges[programId][projectId]
    let permissionHash = {"write": "W", "read": "R", "delete": "D"}
    let s = permissionHash[salut]
    return this.$currentUser.role == "superadmin" || fPrivilege.tasks.includes(s); 

  }else if(page == "facility_show"){
    var programId = this.$route.params.programId;
    var projectId = this.$route.params.projectId
    let fPrivilege = this.$projectPrivileges[programId][projectId]
    let permissionHash = {"write": "W", "read": "R", "delete": "D"}
    let s = permissionHash[salut]
    return  fPrivilege.tasks.includes(s);

  }else if(page == "issue_calendar"){

    var programId = this.$route.params.programId;
    var projectId = this.$route.params.projectId
    let fPrivilege = this.$projectPrivileges[programId][projectId]
    let permissionHash = {"write": "W", "read": "R", "delete": "D"}
    let s = permissionHash[salut]
    return  fPrivilege.issues.includes(s); 

  }else if(page == "issue_index"){
    if (this.$route.params.contractId) {
      let fPrivilege = this.$contractPrivileges[this.$route.params.programId][this.$route.params.contractId]    
      let permissionHash = {"write": "W", "read": "R", "delete": "D"}
      let s = permissionHash[salut]
      return fPrivilege.issues.includes(s);
    } else {
      let fPrivilege = this.$projectPrivileges[this.$route.params.programId][this.$route.params.projectId]    
      let permissionHash = {"write": "W", "read": "R", "delete": "D"}
      let s = permissionHash[salut]
      return fPrivilege.issues.includes(s); 
    }
  }else if(page == "issue_sheets_index"){
    if (this.$route.params.contractId) {
      let fPrivilege = this.$contractPrivileges[this.$route.params.programId][this.$route.params.contractId]    
      let permissionHash = {"write": "W", "read": "R", "delete": "D"}
      let s = permissionHash[salut]
      return fPrivilege.issues.includes(s);
    } else {
      let fPrivilege = this.$projectPrivileges[this.$route.params.programId][this.$route.params.projectId]    
      let permissionHash = {"write": "W", "read": "R", "delete": "D"}
      let s = permissionHash[salut]
      return fPrivilege.issues.includes(s); 
    }
  }else if(page == "ContractLessonForm"){
    if (this.$route.params.contractId) {
      let fPrivilege = this.$contractPrivileges[this.$route.params.programId][this.$route.params.contractId]    
      let permissionHash = {"write": "W", "read": "R", "delete": "D"}
      let s = permissionHash[salut]
      return fPrivilege.lessons.includes(s);
    } else {
      let fPrivilege = this.$projectPrivileges[this.$route.params.programId][this.$route.params.projectId]    
      let permissionHash = {"write": "W", "read": "R", "delete": "D"}
      let s = permissionHash[salut]
      return fPrivilege.lessons.includes(s); 
    }

  }else if(page == "LessonForm"){
    if (this.$route.params.contractId) {
      let fPrivilege = this.$contractPrivileges[this.$route.params.programId][this.$route.params.contractId]    
      let permissionHash = {"write": "W", "read": "R", "delete": "D"}
      let s = permissionHash[salut]
      return fPrivilege.lessons.includes(s);
    } else {
      let fPrivilege = this.$projectPrivileges[this.$route.params.programId][this.$route.params.projectId]    
      let permissionHash = {"write": "W", "read": "R", "delete": "D"}
      let s = permissionHash[salut]
      return fPrivilege.lessons.includes(s); 
    }

  }else if(page == "contract_notes_form"){
    let fPrivilege = this.$contractPrivileges[this.$route.params.programId][this.$route.params.contractId]
    let permissionHash = {"write": "W", "read": "R", "delete": "D"}
    let s = permissionHash[salut]
    return fPrivilege.notes.includes(s);
  }else if(page == "notes_form"){
    if (this.$route.params.contractId) {
      let fPrivilege = this.$contractPrivileges[this.$route.params.programId][this.$route.params.contractId]    
      let permissionHash = {"write": "W", "read": "R", "delete": "D"}
      let s = permissionHash[salut]
      return fPrivilege.notes.includes(s);
    } else {
      let fPrivilege = this.$projectPrivileges[this.$route.params.programId][this.$route.params.projectId]    
      let permissionHash = {"write": "W", "read": "R", "delete": "D"}
      let s = permissionHash[salut]
      return fPrivilege.notes.includes(s); 
    }
  }else if(page == "notes_index"){
    if (this.$route.params.contractId) {
      let fPrivilege = this.$contractPrivileges[this.$route.params.programId][this.$route.params.contractId]    
      let permissionHash = {"write": "W", "read": "R", "delete": "D"}
      let s = permissionHash[salut]
      return fPrivilege.notes.includes(s);
    } else {
      let fPrivilege = this.$projectPrivileges[this.$route.params.programId][this.$route.params.projectId]    
      let permissionHash = {"write": "W", "read": "R", "delete": "D"}
      let s = permissionHash[salut]
      return fPrivilege.notes.includes(s); 
    }
  }else if(page == "notes_sheets_index"){
    if (this.$route.params.contractId) {
      let fPrivilege = this.$contractPrivileges[this.$route.params.programId][this.$route.params.contractId]    
      let permissionHash = {"write": "W", "read": "R", "delete": "D"}
      let s = permissionHash[salut]
      return fPrivilege.notes.includes(s);
    } else {
      let fPrivilege = this.$projectPrivileges[this.$route.params.programId][this.$route.params.projectId]    
      let permissionHash = {"write": "W", "read": "R", "delete": "D"}
      let s = permissionHash[salut]
      return fPrivilege.notes.includes(s); 
    }

  }else if(page == "notes_sheets"){
    if (this.$route.params.contractId) {
      let fPrivilege = this.$contractPrivileges[this.$route.params.programId][this.$route.params.contractId]    
      let permissionHash = {"write": "W", "read": "R", "delete": "D"}
      let s = permissionHash[salut]
      return fPrivilege.notes.includes(s);
    } else {
      let fPrivilege = this.$projectPrivileges[this.$route.params.programId][this.$route.params.projectId]    
      let permissionHash = {"write": "W", "read": "R", "delete": "D"}
      let s = permissionHash[salut]
      return fPrivilege.notes.includes(s); 
    }

  }else if(page == "notes_show"){
    if (this.$route.params.contractId) {
      let fPrivilege = this.$contractPrivileges[this.$route.params.programId][this.$route.params.contractId]    
      let permissionHash = {"write": "W", "read": "R", "delete": "D"}
      let s = permissionHash[salut]
      return fPrivilege.notes.includes(s);
    } else {
      let fPrivilege = this.$projectPrivileges[this.$route.params.programId][this.$route.params.projectId]    
      let permissionHash = {"write": "W", "read": "R", "delete": "D"}
      let s = permissionHash[salut]
      return fPrivilege.notes.includes(s); 
    }
  }else if(page == "risk_form"){
    if (this.$route.params.contractId) {
      let fPrivilege = this.$contractPrivileges[this.$route.params.programId][this.$route.params.contractId]    
      let permissionHash = {"write": "W", "read": "R", "delete": "D"}
      let s = permissionHash[salut]
      return fPrivilege.risks.includes(s);
    } else {
      let fPrivilege = this.$projectPrivileges[this.$route.params.programId][this.$route.params.projectId]    
      let permissionHash = {"write": "W", "read": "R", "delete": "D"}
      let s = permissionHash[salut]
      return fPrivilege.risks.includes(s); 
    }
  }else if(page == "risk_index"){
    if (this.$route.params.contractId) {
      let fPrivilege = this.$contractPrivileges[this.$route.params.programId][this.$route.params.contractId]    
      let permissionHash = {"write": "W", "read": "R", "delete": "D"}
      let s = permissionHash[salut]
      return fPrivilege.risks.includes(s);
    } else {
      let fPrivilege = this.$projectPrivileges[this.$route.params.programId][this.$route.params.projectId]    
      let permissionHash = {"write": "W", "read": "R", "delete": "D"}
      let s = permissionHash[salut]
      return fPrivilege.risks.includes(s); 
    }
  }else if(page == "risk_show"){
    var programId = this.$route.params.programId;
    var projectId = this.$route.params.projectId
    let fPrivilege = this.$projectPrivileges[programId][projectId]
    let permissionHash = {"write": "W", "read": "R", "delete": "D"}
    let s = permissionHash[salut]
    return  fPrivilege.risks.includes(s); 
  }else if(page == "risk_calendar"){
    if (this.$route.params.contractId) {
      let fPrivilege = this.$contractPrivileges[this.$route.params.programId][this.$route.params.contractId]    
      let permissionHash = {"write": "W", "read": "R", "delete": "D"}
      let s = permissionHash[salut]
      return fPrivilege.risks.includes(s);
    } else {
      let fPrivilege = this.$projectPrivileges[this.$route.params.programId][this.$route.params.projectId]    
      let permissionHash = {"write": "W", "read": "R", "delete": "D"}
      let s = permissionHash[salut]
      return fPrivilege.risks.includes(s); 
    }
  }else if(page == "risk_sheets_index"){
    if (this.$route.params.contractId) {
      let fPrivilege = this.$contractPrivileges[this.$route.params.programId][this.$route.params.contractId]    
      let permissionHash = {"write": "W", "read": "R", "delete": "D"}
      let s = permissionHash[salut]
      return fPrivilege.risks.includes(s);
    } else {
      let fPrivilege = this.$projectPrivileges[this.$route.params.programId][this.$route.params.projectId]    
      let permissionHash = {"write": "W", "read": "R", "delete": "D"}
      let s = permissionHash[salut]
      return fPrivilege.risks.includes(s); 
    }
  }else if(page == "task_calendar"){
    if (this.$route.params.contractId) {
      let fPrivilege = this.$contractPrivileges[this.$route.params.programId][this.$route.params.contractId]    
      let permissionHash = {"write": "W", "read": "R", "delete": "D"}
      let s = permissionHash[salut]
      return fPrivilege.tasks.includes(s);
    } else {
      let fPrivilege = this.$projectPrivileges[this.$route.params.programId][this.$route.params.projectId]    
      let permissionHash = {"write": "W", "read": "R", "delete": "D"}
      let s = permissionHash[salut]
      return fPrivilege.tasks.includes(s); 
    }
  }else if(page == "task_form"){
    if (this.$route.params.contractId) {
        let fPrivilege = this.$contractPrivileges[this.$route.params.programId][this.$route.params.contractId]    
        let permissionHash = {"write": "W", "read": "R", "delete": "D"}
        let s = permissionHash[salut]
        return fPrivilege.tasks.includes(s);
      } else if (this.$route.params.projectId) {
        let fPrivilege = this.$projectPrivileges[this.$route.params.programId][this.$route.params.projectId]    
        let permissionHash = {"write": "W", "read": "R", "delete": "D"}
        let s = permissionHash[salut]
        return fPrivilege.tasks.includes(s); 
      }
  }else if(page == "task_index"){
    if (this.$route.params.contractId) {
      let fPrivilege = this.$contractPrivileges[this.$route.params.programId][this.$route.params.contractId]    
      let permissionHash = {"write": "W", "read": "R", "delete": "D"}
      let s = permissionHash[salut]
      return fPrivilege.tasks.includes(s);
    } else {
      let fPrivilege = this.$projectPrivileges[this.$route.params.programId][this.$route.params.projectId]    
      let permissionHash = {"write": "W", "read": "R", "delete": "D"}
      let s = permissionHash[salut]
      return fPrivilege.tasks.includes(s); 
    }
  }else if(page == "task_sheets_index"){
    if (this.$route.params.contractId) {
      let fPrivilege = this.$contractPrivileges[this.$route.params.programId][this.$route.params.contractId]    
      let permissionHash = {"write": "W", "read": "R", "delete": "D"}
      let s = permissionHash[salut]
      return fPrivilege.tasks.includes(s);
    } else {
      let fPrivilege = this.$projectPrivileges[this.$route.params.programId][this.$route.params.projectId]    
      let permissionHash = {"write": "W", "read": "R", "delete": "D"}
      let s = permissionHash[salut]
      return fPrivilege.tasks.includes(s); 
    }
  }else if(page == "LessonContextMenu"){
    if (this.$route.params.contractId) {
      return this.defaultPrivileges      
    } else {
    let fPrivilege = this.$projectPrivileges[this.$route.params.programId][this.$route.params.projectId]    
    let permissionHash = {"write": "W", "read": "R", "delete": "D"}
    let s = permissionHash[salut]
    return fPrivilege.lessons.includes(s); 
    } 
  }else if(page == "KanbanIssues"){
    var programId = this.$route.params.programId;
    var projectId = this.$route.params.projectId
    let fPrivilege = this.$projectPrivileges[programId][projectId]
    let permissionHash = {"write": "W", "read": "R", "delete": "D"}
    let s = permissionHash[salut]
    return  fPrivilege.issues.includes(s); 
  }else if(page == "KanbanRisks"){
    var programId = this.$route.params.programId;
    var projectId = this.$route.params.projectId
    let fPrivilege = this.$projectPrivileges[programId][projectId]
    let permissionHash = {"write": "W", "read": "R", "delete": "D"}
    let s = permissionHash[salut]
    return  fPrivilege.risks.includes(s); 
  }else if(page == "KanbanTasks"){
    var programId = this.$route.params.programId;
    var projectId = this.$route.params.projectId
    let fPrivilege = this.$projectPrivileges[programId][projectId]
    let permissionHash = {"write": "W", "read": "R", "delete": "D"}
    let s = permissionHash[salut]
    return  fPrivilege.tasks.includes(s); 
  }else if(page == "MapAnalytics"){
    var programId = this.$route.params.programId;
    var projectId = this.$route.params.projectId
    let fPrivilege = this.$projectPrivileges[programId][projectId]
    let permissionHash = {"write": "W", "read": "R", "delete": "D"}
    let s = permissionHash[salut]
    return  fPrivilege.overview.includes(s);  
  }else if(page == "MapLessons"){
    var programId = this.$route.params.programId;
    var projectId = this.$route.params.projectId
    let fPrivilege = this.$projectPrivileges[programId][projectId]
    let permissionHash = {"write": "W", "read": "R", "delete": "D"}
    let s = permissionHash[salut]
    return  fPrivilege.lessons.includes(s); 
  }else if(page == "MapOverview"){
    var programId = this.$route.params.programId;
    var projectId = this.$route.params.projectId
    let fPrivilege = this.$projectPrivileges[programId][projectId]
    let permissionHash = {"write": "W", "read": "R", "delete": "D"}
    let s = permissionHash[salut]
    return  fPrivilege.overview.includes(s);   
  }else if(page == "MapProject"){
    var programId = this.$route.params.programId;
    var projectId = this.$route.params.projectId
    let fPrivilege = this.$projectPrivileges[programId][projectId]
    let permissionHash = {"write": "W", "read": "R", "delete": "D"}
    let s = permissionHash[salut]
    return  fPrivilege.overview.includes(s); 
  }else if(page == "portfolio_issue_form"){
    var programId = this.$route.params.programId;
    var projectId = this.$route.params.projectId
    let fPrivilege = this.$projectPrivileges[programId][projectId]
    let permissionHash = {"write": "W", "read": "R", "delete": "D"}
    let s = permissionHash[salut]
    return  fPrivilege.issues.includes(s); 
  }else if(page == "portfolio_lesson_form"){
    var programId = this.$route.params.programId;
    var projectId = this.$route.params.projectId
    let fPrivilege = this.$projectPrivileges[programId][projectId]
    let permissionHash = {"write": "W", "read": "R", "delete": "D"}
    let s = permissionHash[salut]
    return  fPrivilege.lessons.includes(s);  
  }else if(page == "portfolio_risk_form"){
    var programId = this.$route.params.programId;
    var projectId = this.$route.params.projectId
    let fPrivilege = this.$projectPrivileges[programId][projectId]
    let permissionHash = {"write": "W", "read": "R", "delete": "D"}
    let s = permissionHash[salut]
    return  fPrivilege.risks.includes(s); 
  }else if(page == "portfolio_task_form"){
    var programId = this.$route.params.programId;
    var projectId = this.$route.params.projectId
    let fPrivilege = this.$projectPrivileges[programId][projectId]
    let permissionHash = {"write": "W", "read": "R", "delete": "D"}
    let s = permissionHash[salut]
    return  fPrivilege.tasks.includes(s); 
  }else if(page == "ProgramContractsSheet"){
    let pPrivilege = this.$programPrivileges[this.$route.params.programId]        
    let permissionHash = {"write": "W", "read": "R", "delete": "D"}
    let s = permissionHash[salut]
    return pPrivilege.contracts.includes(s);  
  }else if(page == "ProgramView"){
    let pPrivilege = this.$programPrivileges[this.$route.params.programId]        
    let permissionHash = {"write": "W", "read": "R", "delete": "D"}
    let s = permissionHash[salut]
    return pPrivilege.contracts.includes(s);
  }else if(page == "SettingsSidebar"){
    let pPrivilege = this.$programPrivileges[this.$route.params.programId]        
    let permissionHash = {"write": "W", "read": "R", "delete": "D"}
    let s = permissionHash[salut]
    return pPrivilege.contracts.includes(s);   
  }else if(page == "SettingsView"){
    let pPrivilege = this.$programPrivileges[this.$route.params.programId]        
    let permissionHash = {"write": "W", "read": "R", "delete": "D"}
    let s = permissionHash[salut]
    return pPrivilege.contracts.includes(s);
  }else if(page == "SheetAnalytics"){
    var programId = this.$route.params.programId;
    var projectId = this.$route.params.projectId
    let fPrivilege = this.$projectPrivileges[programId][projectId]
    let permissionHash = {"write": "W", "read": "R", "delete": "D"}
    let s = permissionHash[salut]
    return  fPrivilege.overview.includes(s); 
  }else if(page == "SheetLessons"){
    var programId = this.$route.params.programId;
    var projectId = this.$route.params.projectId
    let fPrivilege = this.$projectPrivileges[programId][projectId]
    let permissionHash = {"write": "W", "read": "R", "delete": "D"}
    let s = permissionHash[salut]
    return  fPrivilege.lessons.includes(s);   
  }else if(page == "SheetProject"){
    var programId = this.$route.params.programId;
    var projectId = this.$route.params.projectId
    let fPrivilege = this.$projectPrivileges[programId][projectId]
    let permissionHash = {"write": "W", "read": "R", "delete": "D"}
    let s = permissionHash[salut]
    return  fPrivilege.overview.includes(s);  
  }else if(page == "ContractAnalytics"){
    var programId = this.$route.params.programId;
    var contractId = this.$route.params.contractId
    let fPrivilege = this.$contractPrivileges[programId][contractId]
    let permissionHash = {"write": "W", "read": "R", "delete": "D"}
    let s = permissionHash[salut]
    return  fPrivilege.overview.includes(s);
  }else if(page == "ContractLessons"){
    if (this.$route.params.contractId) {
      let fPrivilege = this.$contractPrivileges[this.$route.params.programId][this.$route.params.contractId]    
      let permissionHash = {"write": "W", "read": "R", "delete": "D"}
      let s = permissionHash[salut]
      return fPrivilege.lessons.includes(s);
    } else {
      let fPrivilege = this.$projectPrivileges[this.$route.params.programId][this.$route.params.projectId]    
      let permissionHash = {"write": "W", "read": "R", "delete": "D"}
      let s = permissionHash[salut]
      return fPrivilege.lessons.includes(s); 
    }
  }else if(page == "SheetContract"){
    var programId = this.$route.params.programId
    var contractId = this.$route.params.contractId
    let fPrivilege = this.$contractPrivileges[programId][contractId]
    let permissionHash = {"write": "W", "read": "R", "delete": "D"}
    let s = permissionHash[salut]
    return fPrivilege.overview.includes(s);
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
