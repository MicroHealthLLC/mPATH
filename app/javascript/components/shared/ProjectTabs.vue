<template>
  <div v-if="tabsVisible" id="customtabs" class="d-flex align-items-center p-2">
    <span v-if="$route.params.projectId" class="d-flex">
      <div v-for="cTab in cTabs" :key="cTab.key" class="d-flex">
        <div
          v-if="
            !cTab.hidden && cTab.key !== 'contract' && cTab.key !== 'vehicle'
          "
          class="badge mx-0"
          :data-cy="cTab.key"
          :class="{ active: currentCtab == cTab.key, disabled: cTab.disabled }"
          @click="changeCtab(cTab)"
        >
          <div>{{ cTab.label }}</div>
        </div>
      </div>
    </span>

    <span v-else-if="$route.params.contractId" class="d-flex">
      <div v-for="cTab in cTabs" :key="cTab.key">
        <div
          v-if="
            !cTab.hidden && cTab.key !== 'project' && cTab.key !== 'vehicle'
          "
          class="badge mx-0"
          :data-cy="cTab.key"
          :class="{ active: currentCtab == cTab.key, disabled: cTab.disabled }"
          @click="changeCtab(cTab)"
        >
          <div>{{ cTab.label }}</div>
        </div>
      </div>
    </span>

    <span v-else-if="$route.params.vehicleId" class="d-flex">
      <div v-for="cTab in cTabs" :key="cTab.key">
        <div
          v-if="
            !cTab.hidden && cTab.key !== 'project' && cTab.key !== 'contract'
          "
          class="badge mx-0"
          :data-cy="cTab.key"
          :class="{ active: currentCtab == cTab.key, disabled: cTab.disabled }"
          @click="changeCtab(cTab)"
        >
          <div>{{ cTab.label }}</div>
        </div>
      </div>
    </span>
  </div>
</template>

<script>
import { mapGetters } from "vuex";
import AuthorizationService from "../../services/authorization_service";

// When routing from any tab back to Analytics, the url is still going to OVerview
export default {
  name: "ProjectTabs",
  data() {
    return {
      canSeeTab: true,
      cTabs: [
        {
          label: "Contract",
          key: "contract",
          closable: false,
          hidden: false,
        },
        {
          label: "Project",
          key: "project",
          closable: false,
          hidden: false,
        },
        {
          label: "Vehicle",
          key: "vehicle",
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
        {
          label: "Effort",
          key: "effort",
          closable: false,
          hidden: false,
        },
      ],
    };
  },
  mounted() { 
    
    for (let privelegeTab in this.privileges) {
      //console.log(this.privileges)
      if (
        this.privileges[privelegeTab].length <= 0 &&
        privelegeTab !== "contract_id" &&
        privelegeTab !== "contract_vehicle_id"
      ) {
       
        for (let i = 0; i < this.cTabs.length; i++) {
          if (privelegeTab == this.cTabs[i].key) {
            this.cTabs[i].hidden = true;
          }
          // this.cTabs[1] below is the Analytics tab as it is still named 'overview' in backend
          if (privelegeTab == "overview") {
            this.cTabs[3].hidden = true;
            if (this.$route.params.contractId) {
              this.cTabs[0].hidden = true;
            } else if (this.$route.params.vehicleId) {
              this.cTabs[2].hidden = true;
            } else this.cTabs[1].hidden = true;
          }
        }
      }
      if (
        this.privileges[privelegeTab].length > 0 &&
        privelegeTab !== "contract_id" &&
        privelegeTab !== "contract_vehicle_id"
      ) {
        // console.log(`${privelegeTab}`)
        for (let i = 0; i < this.cTabs.length; i++) {
          if (privelegeTab == this.cTabs[i].key) {
            this.cTabs[i].hidden = false;
          }
          // this.cTabs[1] below is the Analytics tab as it is still named 'overview' in backend
          if (privelegeTab == "overview") {
            this.cTabs[3].hidden = false;
            if (this.$route.params.contractId) {
              this.cTabs[0].hidden = true;
            } else if (this.$route.params.vehicleId) {
              this.cTabs[2].hidden = true;
            } else this.cTabs[1].hidden = true;
          }
        }
      }
    }
  },
  methods: {
    changeCtab(cTab) {
      if (this.$route.params.contractId) {
        if (cTab.key === "contract") {
          this.$router.push(this.c_path + `/`);
        } else {
          this.$router.push(this.c_path + `/${cTab.key}`);
        }
      } else if (this.$route.params.vehicleId) {
        if (cTab.key === "vehicle") {
          this.$router.push(this.v_path + `/`);
        } else {
          this.$router.push(this.v_path + `/${cTab.key}`);
        }
      } else if (cTab.key === "project" && this.$route.params.projectId) {
        this.$router.push(this.p_path + `/`);
      } else {
        this.$router.push(this.p_path + `/${cTab.key}`);
      }
    },
  },
  computed: {
    ...mapGetters(["contentLoaded", "currentProject"]),
    privileges() {
      return AuthorizationService.getProjectTabPrivilege(this.$route);
    },
    currentCtab() {
      let c = this.cTabs.map((t) => t.key);
      let cT = c.filter((k) =>
        this.$route.name.toUpperCase().includes(k.toUpperCase())
      );
      if (cT.length > 1) {
        return cT.slice(1);
      } else return cT;
    },
    routePriv() {
      return this.$projectPrivileges;
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
    v_path() {
      return `/programs/${this.$route.params.programId}/${this.tab}/vehicles/${this.$route.params.vehicleId}`;
    },
    p_path() {
      return `/programs/${this.$route.params.programId}/${this.tab}/projects/${this.$route.params.projectId}`;
    },
    tabsVisible() {
      if (this.$route.params.contractId) {
        return this.cTabs.some((tab) => tab.hidden === false);
      } else {
        return this.cTabs.some((tab) => tab.hidden === false);
      }
    },
  },
  watch: {
    "$route.path": {
      handler() {
        if (this.contentLoaded) {
          for (let privelegeTab in this.privileges) {
            if (
              this.privileges[privelegeTab].length <= 0 &&
              privelegeTab !== "contract_id" &&
              this.privelegeTab !== "contract_vehicle_id"
            ) {
              // console.log(`${privelegeTab}`)
              for (let i = 0; i < this.cTabs.length; i++) {
                if (privelegeTab == this.cTabs[i].key) {
                  //  console.log(`${privelegeTab}`)
                  this.cTabs[i].hidden = true;
                }
                // this.cTabs[1] below is the Analytics tab as it is still named 'overview' in backend
                if (privelegeTab == "overview") {
                  this.cTabs[3].hidden = false;
                  if (this.$route.params.contractId) {
                    this.cTabs[0].hidden = true;
                  } else if (this.$route.params.vehicleId) {
                    this.cTabs[2].hidden = true;
                  } else this.cTabs[1].hidden = true;
                }
              }
            }
            if (
              this.privileges[privelegeTab].length > 0 &&
              privelegeTab !== "contract_id" &&
              this.privelegeTab !== "contract_vehicle_id"
            ) {
              // console.log(`${privelegeTab}`)
              for (let i = 0; i < this.cTabs.length; i++) {
                if (privelegeTab == this.cTabs[i].key) {
                  this.cTabs[i].hidden = false;
                }
                // this.cTabs[1] below is the Analytics tab as it is still named 'overview' in backend
                if (privelegeTab == "overview") {
                  this.cTabs[3].hidden = false;
                  if (this.$route.params.contractId) {
                    this.cTabs[0].hidden = true;
                  } else if (this.$route.params.vehicleId) {
                    this.cTabs[2].hidden = true;
                  } else this.cTabs[1].hidden = true;
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