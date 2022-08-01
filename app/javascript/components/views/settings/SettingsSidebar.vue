<template>
<div class="filterbar">
    <div class="stick">
      <div
        @click="deselectProject"
        id="program_name"
        class="programNameDiv smallCaps pl-2 pr-3"
      >
        {{ programName }}
      </div>
    </div>

<div id="filter_bar">
    <h5 class="pt-3">
    <ul class="program-name">
       <router-link :to="adminGroupsView" v-if="_isallowedGroups('read')">
        <li class="p-3 mt-3 entity">
          <i class="fal fa-network-wired mr-2 mh-blue-text"></i>Groups
        </li>
    </router-link>
    <router-link :to="adminProjectsView" v-if="_isallowedProjects('read')" >
        <li class="p-3 entity">
          <i class="fal fa-clipboard-list mr-3 mh-green-text"></i> Projects
        </li>
    </router-link>
    <router-link :to="adminContractsView" v-if="_isallowedContracts('read')"> 
       <li class="p-3 entity">
          <i class="far fa-file-contract mr-3 mh-orange-text"></i>  Contracts
        </li>
    </router-link>
    <router-link :to="adminVehiclesView" v-if="_isallowedContracts('read')"> 
       <li class="p-3 entity">
          <i class="far fa-car mr-3 text-info"></i>Vehicles
        </li>
    </router-link>
       <router-link :to="adminRolesView" v-if="_isallowedUserRoles('read')"> 
       <li class="p-3 entity">
        <i class="fal fa-user-lock mr-2 pr-1 bootstrap-purple-text"></i>Roles
        </li>
    </router-link>
    <router-link :to="adminUsersView" v-if="_isallowedUserRoles('read')"> 
       <li class="p-3 entity">
         <i class="fal fa-users mr-2 pr-1 text-secondary"></i>Users
        </li>
    </router-link>
   
    <!-- <router-link :to="adminCloudView" > 
       <li class="p-3 entity">
            <i class="fal fa-cloud mr-2 text-info"></i>     MH Data
        </li>
    </router-link> -->
     </ul>
    </h5>

</div>
  <div class="bottomBtn">
        <button class="btn btn-sm btn-light settingsBackBtn mb-4" @click.prevent="backToSheetView" style="cursor: pointer">
        <h6> <i class="far fa-arrow-square-left mr-1"></i> Back To Program</h6>
        </button> 
  </div> 
</div>
</template>

<script>
import { mapGetters, mapActions, mapMutations } from "vuex";
export default {
  name: 'SettingsSidebar',
  data() {
    return {
      
    }
  },
  computed: {
    ...mapGetters([
        'getShowAdminBtn',
        'currentProject',
        'contentLoaded'
     ]),
    programName() {
      if (
        this.contentLoaded &&
        (this.currentProject !== null || this.currentProject !== undefined)
      ) {
        return this.currentProject.name;
      }
    },

    settingsLanding() {
     return `/programs/${this.$route.params.programId}/settings`;
    },
    backToSheetView() {
     window.location.pathname = `/programs/${this.$route.params.programId}/sheet`
      },
    adminProjectsView() {
     return `/programs/${this.$route.params.programId}/settings/projects`
    },
    adminContractsView() {
     return `/programs/${this.$route.params.programId}/settings/contracts`
    },
    adminVehiclesView() {
     return `/programs/${this.$route.params.programId}/settings/vehicles`
    },
    adminGroupsView() {
     return `/programs/${this.$route.params.programId}/settings/groups`
    },
    adminUsersView() {
     return `/programs/${this.$route.params.programId}/settings/users`
    },
    adminRolesView() {
     return `/programs/${this.$route.params.programId}/settings/roles`
    },
    adminCloudView() {
     return `/programs/${this.$route.params.programId}/settings/test_cloud_data`
    },
  },
  methods: {
    ...mapMutations([
        'setShowAdminBtn',
        ]),
     _isallowed(salut) {
        // return this.checkPrivileges("SettingsSidebar", salut, this.$route)

      let pPrivilege = this.$programPrivileges[this.$route.params.programId]        
      let permissionHash = {"write": "W", "read": "R", "delete": "D"}
      let s = permissionHash[salut]
      return pPrivilege.contracts.includes(s);     
    },
    _isallowedUserRoles(salut) {
      return this.checkPrivileges("SettingsUsers", salut, this.$route,  {settingType: "Users"})
    },
    _isallowedProjects(salut) {
      return this.checkPrivileges("SettingsProjects", salut, this.$route, {settingType: "Projects"})
    }, 
    _isallowedGroups(salut) {
     return this.checkPrivileges("SettingsGroups", salut, this.$route, {settingType: "Groups"})    
    },
    _isallowedContracts(salut) {
        return this.checkPrivileges("SettingsContracts", salut, this.$route, {settingType: 'Contracts'})
    }, 
    // _isallowedProgramSettings(settingType, salut) {
    //   let pPrivilege = this.$programSettingPrivileges[this.$route.params.programId]
    //   let permissionHash = {"write": "W", "read": "R", "delete": "D"}
    //   let settingTypeHash = {"Groups": "admin_groups", "Contracts": "admin_contracts", "Projects": "admin_facilities"}
    //   let s = permissionHash[salut]
    //   let type = settingTypeHash[settingType]
    //   return pPrivilege[type].includes(s);
    // },
    toggleAdminFilter() {
      this.setShowAdminBtn(!this.getShowAdminBtn)
    },
    log(e){
        // console.log(e);  
    },
    deselectProject(e) {
      if (e.target.id === "program_name") {
        this.$router.push(
          `/programs/${this.$route.params.programId}/settings`
        );
      }
    },
  }
}

</script>

<style lang="scss" scoped>
.filterbar {
  position: absolute;
  z-index: 1100;
  background-color: #ededed;
  width: 90%;
  transition: .4s ease;
}
.stick {
  position: fixed;
  z-index: 1;
  color:#fff;
  max-width: 16%;
  background-color: #DD9036;
}
.programNameDiv {
  box-shadow: 0 2.5px 2.5px rgba(0, 0, 0, 0.19), 0 3px 3px rgba(0, 0, 0, 0.23);
  line-height: 1.2;

  display: -webkit-box;
  -webkit-line-clamp: 1;
  -webkit-box-orient: vertical;
  overflow: hidden;
  cursor: pointer;
  &:hover {
    display: -webkit-box;
    -webkit-line-clamp: unset;
  }
  &.active {
    background-color: red !important;
    color: #007bff;
  }
}
.programNameDiv:hover {
  background-color: #8f510b;

}
#filter_bar {
  overflow-y: auto;
  border-radius: 4px;
  background-color: #ededed;
  height: calc(100vh - 94px);
  max-height: calc(100vh - 94px);
}
ul {
  list-style-type: none; /* Remove bullets */
  li {
  color: #212529 !important; /* default color of text to replace blue default link color */
  } 
}
.entity:hover {
  background-color: rgba(91, 192, 222, 0.3);
  cursor: pointer;
  }
.settingsBackBtn {
  position: fixed;
  bottom: -15px;
  left: 2.5%;
  z-index: 1140;
}

</style>
