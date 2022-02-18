<template>
  <div v-if="tabsVisible" id="customtabs" class="d-flex align-items-center p-2">
   <span v-if="$route.params.contractId" class="d-flex">
    <div v-for="cTab in cTabs" :key="cTab.key">
      <div
        v-if="!cTab.hidden"
        class="badge mx-0"
        :class="{ active: currentCtab == cTab.key, disabled: cTab.disabled }"
        @click="changeCtab(cTab)"
      >
        <div>{{ cTab.label }}</div>
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
      // currentTab: '',
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
   var contractId = this.$route.params.contractId;
    if(contractId){
       for (let privelegeTab in this.privileges) {
        // if (this.privileges[privelegeTab].length > 0 && privelegeTab !== 'contract_id') {
        //   // console.log(`${privelegeTab}`)
        //     for (let i = 0; i < this.cTabs.length; i++) {
        //       if (privelegeTab == this.cTabs[i].key){
        //         this.cTabs[i].hidden = false
        //       }
        //       // this.cTabs[1] below is the Analytics tab as it is still named 'overview' in backend
        //       if (privelegeTab == "overview"){
        //           this.cTabs[1].hidden = false
        //       }
        //     }
        // }   
         if (this.privileges[privelegeTab].length <= 0 && privelegeTab !== 'contract_id') {
          // console.log(`${privelegeTab}`)
            for (let i = 0; i < this.cTabs.length; i++) {
              if (privelegeTab == this.cTabs[i].key){
                this.cTabs[i].hidden = true
              }
              // this.cTabs[1] below is the Analytics tab as it is still named 'overview' in backend
              if (privelegeTab == "overview"){
                  this.cTabs[1].hidden = true
              }
            }
        }  
      }    
    } else {
      for (let privelegeTab in this.privileges) {
        for (let b = 0; b < this.pTabs.length; b++){
          if (this.privileges[privelegeTab].length <= 0 && privelegeTab == this.pTabs[b].key) {
          // console.log(`${privelegeTab}`)
            for (let i = 0; i < this.pTabs.length; i++) {
              if (privelegeTab == this.pTabs[i].key){
                this.pTabs[i].hidden = true
              }
              // this.pTabs[1] below is the Analytics tab as it is still named 'overview' in backend
              if (privelegeTab == "overview"){
                  this.pTabs[1].hidden = true
              }
            }
         }   
        }      
      } 
       
    }
  },
  methods: {
    // if no privilege to tab, modify this logic to re-route to default project or contract tab
    // instead of routing user to no tab permissions message
    changeTab(tab) {
       if (tab.key === "project"){
        this.$router.push(this.p_path + `/`);
       } else {
      this.$router.push(this.p_path + `/${tab.key}`);
     }
    },
     changeCtab(cTab) {
       if (cTab.key === "contract"){
        this.$router.push(this.c_path + `/`);
       } else {
            this.$router.push(this.c_path + `/${cTab.key}`);
       } 
     
      // this.currentTab = tab.key
    },
  },
  computed: {
    ...mapGetters(["contentLoaded", "currentProject"]),
    currentTab() {
      return this.pTabs
        .map((tab) => tab.key)
        .filter((key) =>
          this.$route.name.toUpperCase().includes(key.toUpperCase())
        );
    },
    privileges(){
      let programId = this.$route.params.programId
      let projectId = this.$route.params.projectId;
      let contractId = this.$route.params.contractId;
       if(contractId){
         return this.$contractPrivileges[programId][this.$route.params.contractId] 
      } else return this.$projectPrivileges[programId][projectId];
    },
    currentCtab() {
      let c = this.cTabs.map(t => t.key)
      let cT = c.filter(k => this.$route.name.toUpperCase().includes(k.toUpperCase()))
      if (cT.length > 1){
        return cT.slice(1)
      } else return cT
    },
    routePriv(){
      return this.$projectPrivileges 
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
    c_path() {
        return `/programs/${this.$route.params.programId}/${this.tab}/contracts/${this.$route.params.contractId}`;
    },
    p_path(){
      return `/programs/${this.$route.params.programId}/${this.tab}/projects/${this.$route.params.projectId}`;  
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
        var contractId = this.$route.params.contractId;
        if(contractId){
          for (let privelegeTab in this.privileges) {
            if (this.privileges[privelegeTab].length <= 0 && privelegeTab !== 'contract_id') {
              // console.log(`${privelegeTab}`)
                for (let i = 0; i < this.cTabs.length; i++) {
                  if (privelegeTab == this.cTabs[i].key){
                    this.cTabs[i].hidden = true
                  }
                  // this.cTabs[1] below is the Analytics tab as it is still named 'overview' in backend
                  if (privelegeTab == "overview"){
                      this.cTabs[1].hidden = true
                      }
                    }
                }  
              }    
                } else {
              for (let privelegeTab in this.privileges) {
                for (let b = 0; b < this.pTabs.length; b++){
                  if (this.privileges[privelegeTab].length <= 0 && privelegeTab == this.pTabs[b].key) {
                  // console.log(`${privelegeTab}`)
                    for (let i = 0; i < this.pTabs.length; i++) {
                      if (privelegeTab == this.pTabs[i].key){
                        this.pTabs[i].hidden = true
                      }
                      // this.pTabs[1] below is the Analytics tab as it is still named 'overview' in backend
                      if (privelegeTab == "overview"){
                          this.pTabs[1].hidden = true
                      }
                    }
                }   
                }      
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
