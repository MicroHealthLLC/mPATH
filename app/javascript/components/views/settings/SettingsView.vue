<template>
  <div
    v-loading="!contentLoaded"
    element-loading-text="Fetching your data. Please wait..."
    element-loading-spinner="el-icon-loading"
    element-loading-background="rgba(0, 0, 0, 0.8)"
    class="row"
  >
    <div class="col-md-2">
      <SettingsSidebar />
    </div>
    <div class="col-md-10">
      <div class="right-panel">
        <h4 class="mt-4">
          <i class="far fa-cog mh-orange-text"></i> PROGRAM SETTINGS
        </h4>
        <div class="grid-container px-5">
          <ul>
            <li
              class="m-2 cardWrapper"
              v-for="(item, index) of settingsCards"
              :key="index"
              style="width:33%"
              @click.prevent="adminRoute(index)"
            >
              <el-card :body-style="{ padding: '0px' }">
                <div class="p-2" style="font-size:3.5rem">
                  <span v-if="item == 'Groups'">
                    <i class="fal fa-network-wired mr-3 mh-blue-text"></i
                  ></span>
                  <span v-if="item == 'Projects'">
                    <i class="fal fa-clipboard-list mr-3 mh-green-text"></i
                  ></span>
                  <span v-if="item == 'Contracts'">
                    <i class="far fa-file-contract mr-3 mh-orange-text"></i>
                  </span>
                  <span v-if="item == 'MH Data'">
                    <i class="fal fa-cloud mr-2 text-info"></i>              
                  </span>
                  <!-- <span v-if="item == 'Users'">   <i class="far fa-users mr-3"></i> </span> -->
                </div>
                <div>
                  <h4>
                    <span v-if="item == 'Groups'">
                      {{ settingsCards.groups }}</span
                    >
                    <span v-if="item == 'Projects'">
                      {{ settingsCards.projects }}</span
                    >
                    <span v-if="item == 'Contracts'">{{
                      settingsCards.contracts
                    }}</span>
                      <span v-if="item == 'MH Data'">{{
                      settingsCards.mhData
                    }}</span>
                    <!-- <span v-if="item == 'Users'">{{ settingsCards.users }}</span> -->
                    <!-- <span v-if="item == 'Contracts'"> <i class="far fa-file-contract mr-3"></i>   {{item}}</span> -->
                  </h4>
                </div>
              </el-card>
            </li>
          </ul>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { mapGetters, mapMutations } from "vuex";
import SettingsSidebar from "./SettingsSidebar.vue";
export default {
  name: "SettingsView",
  components: {
    SettingsSidebar,
  },
  data() {
    return {
      settingsCards: {
        groups: "Groups",
        projects: "Projects",
        contracts: "Contracts",
        mhData: "MH Data",
        // users: "Users"
      },
      projectNameText: "",
      selectedProjectGroup: null,
      projectName: "",
      newProjectName: "",
      newProjectGroupName: "",
      contractNameText: "",
      value: "",
      expanded: {
        id: "",
      },
    };
  },
  methods: {
    ...mapMutations(["setProjectGroupFilter"]),
     adminRoute(index) {
      // console.log(event, index, "This")
      if (index == "groups") {
        this.$router.push(
          `/programs/${this.$route.params.programId}/settings/groups`
        );
      }
      if (index == "projects") {
        this.$router.push(
          `/programs/${this.$route.params.programId}/settings/projects`
        );
      }
      if (index == "contracts") {
        this.$router.push(
          `/programs/${this.$route.params.programId}/settings/contracts`
        );
      }
      if (index == "mhData") {
        this.$router.push(
          `/programs/${this.$route.params.programId}/settings/test_cloud_data`
        );
      }
    },
   },
  computed: {
    ...mapGetters([
      "contentLoaded",
      "facilities",
      "getProjectGroupFilter",
      "facilityGroupFacilities",
      "filteredFacilityGroups",
    ]),
  },
  C_projectGroupFilter: {
    get() {
      return this.getProjectGroupFilter;
    },
    set(value) {
      // console.log(value)
      this.setProjectGroupFilter(value);
    },
  },
};
</script>

<style scoped lang="scss">
.fa-calendar {
  font-size: x-large;
}
.tabs {
  background-color: #ededed;
  border-top: solid 0.3px #ededed;
  width: min-content;
  display: flex;
  box-shadow: 0 2.5px 2.5px rgba(0, 0, 0, 0.19), 0 3px 3px rgba(0, 0, 0, 0.23);
  .tab {
    cursor: pointer;
    padding: 7px 10px;
    border-radius: 0.1rem;
    font-weight: 500;
    letter-spacing: 1;
    transition: auto;
    font-size: 75%;
  }
  .active {
    color: #fff !important;
    background-color: #383838 !important;
  }
}
a {
  color: unset;
  text-decoration: unset;
}
.right-panel {
  height: calc(100vh - 100px);
  overflow-y: auto;
}

li {
  list-style-type: none; /* Remove bullets */
}
.cardWrapper {
  box-shadow: 0 2.5px 5px rgba(56, 56, 56, 0.19),
    0 3px 3px rgba(56, 56, 56, 0.23);
  transition: all 0.2s ease-in;
  cursor: pointer;
}
.cardWrapper:hover {
  transform: scale(1.015);
}
</style>
