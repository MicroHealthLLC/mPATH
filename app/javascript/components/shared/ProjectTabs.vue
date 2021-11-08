<template>
  <div v-if="tabsVisible" id="customtabs" class="d-flex align-items-center p-2">
   <span v-if="$route.params.contractId" class="d-flex">
    <div v-for="tab in cTabs" :key="tab.key">
      <div
        v-if="!tab.hidden"
        class="badge mx-0"
        :class="{ active: currentTab == tab.key, disabled: tab.disabled }"
        @click="changeTab(tab)"
      >
        <div>{{ tab.label }}</div>
      </div>
    </div>
    </span>
    
    <span v-else class="d-flex">
      <div v-for="tab in pTabs" :key="tab.key">
      <div
        v-if="!tab.hidden"
        class="badge mx-0"
        :class="{ active: currentTab == tab.key, disabled: tab.disabled }"
        @click="changeTab(tab)"
      >
        <div>{{ tab.label }}</div>
      </div>
    </div>
    </span>
  </div>
  
</template>

<script>
import { mapGetters } from "vuex";
// When routing from any tab back to Analytics, the url is still going to OVerview
export default {
  name: "ProjectTabs",
  data() {
    return {
      canSeeTab: true,
      // Project Tabs
      pTabs: [
         {
          label: "Project",
          key: "project",
          closable: false,
          hidden: false,
        },
        {
          label: "Analytics",
          key: "analytics",
          closable: false,
          hidden: false,
        },
        {
          label: "Tasks",
          key: "tasks",
          closable: false,
          hidden: false,
        },
        {
          label: "Issues",
          key: "issues",
          closable: false,
          hidden: false,
        },
        {
          label: "Risks",
          key: "risks",
          closable: false,
          hidden: false,
        },
        {
          label: "Lessons",
          key: "lessons",
          closable: false,
          hidden: false,
        },
        {
          label: "Notes",
          key: "notes",
          closable: false,
          hidden: false,
        },
      ],
      // Contract Tabs
      cTabs: [
       {
          label: "Contract",
          key: "contract",
          closable: false,
          hidden: false,
        },
        {
          label: "Analytics",
          key: "analytics",
          closable: false,
          hidden: false,
        },
        {
          label: "Tasks",
          key: "tasks",
          closable: false,
          hidden: false,
        },
        {
          label: "Issues",
          key: "issues",
          closable: false,
          hidden: false,
        },
        {
          label: "Risks",
          key: "risks",
          closable: false,
          hidden: false,
        },
        {
          label: "Lessons",
          key: "lessons",
          closable: false,
          hidden: false,
        },
        {
          label: "Notes",
          key: "notes",
          closable: false,
          hidden: false,
        },
      ],
    };
  },
  mounted() {
    var programId = this.$route.params.programId;
    var projectId = this.$route.params.projectId;
    var contractId = this.$route.params.contractId;


    let fPrivilege = this.$projectPrivileges[programId][projectId];
    let cPrivilege = this.$projectPrivileges[programId][contractId];

    // var fPrivilege = _.filter(this.$projectPrivileges, (f) => f.program_id == programId && f.project_id == projectId)[0]

    if (fPrivilege) {
      for (var i = 0; i < this.pTabs.length; i++) {
        // this.tabs[i].hidden = fPrivilege[this.tabs[i].key].hide
        if(this.pTabs[i].key == 'project'){
          continue
        }

        if (fPrivilege[this.pTabs[i].key] && fPrivilege[this.pTabs[i].key].length) {
           this.pTabs[i].hidden = fPrivilege[this.pTabs[i].key].length < 1;
        }
      
      
      }
    }
    if (cPrivilege) {
      for (var i = 0; i < this.cTabs.length; i++) {
        // this.tabs[i].hidden = fPrivilege[this.tabs[i].key].hide
        if(this.cTabs[i].key == 'contract'){
          continue
        }
        this.cTabs[i].hidden = cPrivilege[this.cTabs[i].key].length < 1;
      
      }
    }
  },
  methods: {
    changeTab(tab) {
      this.$router.push(this.path + `/${tab.key}`);
    },
  },
  computed: {
    ...mapGetters(["contentLoaded", "currentProject"]),
    tabReader() {
      if (this.$route.params.contractId){
        return this.cTabs
      } else {
        return this.pTabs
      }
     
    },
    routePriv(){
      return this.$projectPrivileges 
    },
    currentTab() {    
      if (this.$route.params.contractId){
         return this.cTabs
        .map((tab) => tab.key)
        .filter((key) =>{
          console.log(key)
         this.$route.name.includes(key)
        });
      } else {
        return this.pTabs
        .map((tab) => tab.key)
        .filter((key) =>{
       this.$route.name.includes(key)    
        });
      }  
    },
    tab() {
      let url = this.$route.path;
      if (url.includes("sheet")) {
        return "sheet";
      }
      if (url.includes("calendar")) {
        return "calendar";
      } else {
        return "map";
      }
    },
    path() {
      if (this.$route.params.contractId){
         return `/programs/${this.$route.params.programId}/${this.tab}/contracts/${this.$route.params.contractId}`;
      }
      else  {
        return `/programs/${this.$route.params.programId}/${this.tab}/projects/${this.$route.params.projectId}`;    
        } 
    },
    tabsVisible() {
     if (this.$route.params.contractId){
        return this.cTabs.some((tab) => tab.hidden === false);
      } else {
        return this.pTabs.some((tab) => tab.hidden === false);
      }
     },
  },
  watch: {
    "$route.path": {
      handler() {
        if (this.contentLoaded) {

// For Contract Privileges
          let cPrivileges = this.$projectPrivileges[
            this.$route.params.programId
          ][this.$route.params.contractId];

// For Project Privileges
          let pPrivileges = this.$projectPrivileges[
            this.$route.params.programId
          ][this.$route.params.projectId];


          if (cPrivileges) {
            for (var i = 0; i < this.cTabs.length; i++) {
              if(this.cTabs[i].key == 'contract'){
                continue
              }
              this.cTabs[i].hidden = cPrivileges[this.cTabs[i].key].length < 1;
            //  debugger
                  
            }
          }
       
          if (pPrivileges) {
            for (var i = 0; i < this.pTabs.length; i++) {
              if(this.pTabs[i].key == 'project'){
                continue
              }
                if (pPrivileges[this.pTabs[i].key] && pPrivileges[this.pTabs[i].key].length) {
              this.pTabs[i].hidden = pPrivileges[this.pTabs[i].key].length < 1;
                }
            //  debugger
                  
            }
          }


        }
      },
    },
  },
};
</script>

<style scoped lang="scss">
#customtabs {
  background-color: #ededed;
  border-top: solid 0.3px #ededed;
  width: min-content;
  box-shadow: 0 2.5px 2.5px rgba(0, 0, 0, 0.19), 0 3px 3px rgba(0, 0, 0, 0.23);
  .badge {
    cursor: pointer;
    padding: 7px 10px;
    border-radius: 0.1rem;
    font-weight: 500;
    letter-spacing: 0.12em;
    margin: 4px 7px;
    transition: auto;
    &.active {
      color: #fff !important;
      background-color: #383838 !important;
    }
    &.disabled {
      pointer-events: none;
      opacity: 0.5;
      cursor: not-allowed;
      border: 0 !important;
      padding: 7px 10px !important;
    }
    &:hover {
      background-color: rgba(91, 192, 222, 0.3);
      border: none !important;
      color: #383838;
    }
  }
}
</style>
