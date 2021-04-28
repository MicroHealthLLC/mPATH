<template>
  <div
    id="facility_sidebar"
    class="pl-0"
    @click="deselectProject"
    data-cy="facility_list"
  >
    <h4 class="mt-4 text-info text-center" v-if="title">{{ title }}</h4>
    <div class="mb-3 ml-2" style="margin-top:1.8rem">
      <div v-if="contentLoaded">
        <div
          v-for="(group, index) in sortedGroups"
          :key="index"
          class="my-2 px-2"
        >
          <div
            class="d-flex expandable"
            @click="expandFacilityGroup(group)"
            :class="{ active: group.id == currentFacilityGroup.id }"
            data-cy="facility_groups"
          >
            <span v-show="expanded.id != group.id">
              <i class="fa fa-angle-right font-sm mr-2 clickable"></i>
            </span>
            <span v-show="expanded.id == group.id">
              <i class="fa fa-angle-down font-md mr-2 clickable"></i>
            </span>
            <h5 class="clickable">{{ group.name }}</h5>
          </div>
          <div v-show="expanded.id == group.id" class="ml-2">
            <div
              v-for="(facility, index) in facilityGroupFacilities(group)"
              :key="index"
            >
              <router-link
                :to="
                  `/programs/${$route.params.programId}/${tab}/projects/${facility.id}${pathTab}`
                "
              >
                <div
                  class="d-flex align-items-center expandable fac-name"
                  @click="showFacility(facility)"
                  :class="{ active: facility.id == $route.params.projectId }"
                >
                  <p class="facility-header" data-cy="facilities">
                    {{ facility.facility.facilityName }}
                  </p>
                </div>
              </router-link>
            </div>
          </div>
        </div>
      </div>
      <div v-else>
        <loader type="code"></loader>
        <loader type="code"></loader>
        <loader type="code"></loader>
      </div>
    </div>
  </div>
</template>

<script>
import { mapGetters } from "vuex";
import Loader from "./loader";

export default {
  name: "ProjectSidebar",
  components: {
    Loader,
  },
  props: ["title", "currentFacilityGroup", "expanded", "currentFacility"],
  computed: {
    ...mapGetters([
      "contentLoaded",
      "currentProject",
      "filteredFacilityGroups",
      "facilityGroupFacilities",
    ]),
    sortedGroups() {
      // Sort groups by name
      return this.filteredFacilityGroups.sort((a, b) =>
        a.name.localeCompare(b.name)
      );
    },
    tab() {
      let url = this.$route.path;

      if (url.includes("sheet")) {
        return "sheet";
      }
      if (url.includes("calendar")) {
        return "calendar";
      } else {
        return "kanban";
      }
    },
    pathTab() {
      let url = this.$route.path;

      if (url.includes("tasks")) {
        return "/tasks";
      } else if (url.includes("issues")) {
        return "/issues";
      } else if (url.includes("risks")) {
        return "/risks";
      } else if (url.includes("notes")) {
        return "/notes";
      } else if (url.includes("kanban")) {
        return "/tasks";
      } else {
        return "";
      }
    },
  },
  methods: {
    expandFacilityGroup(group) {
      this.$emit("on-expand-facility-group", group);
    },
    showFacility(facility) {
      this.$emit("on-expand-facility", facility);
    },
    deselectProject(e) {
      if (e.target.id === "facility_sidebar") {
        this.$router.push(
          `/programs/${this.$route.params.programId}/${this.tab}`
        );
      }
    },
  },
};
</script>

<style lang="scss" scoped>
#facility_sidebar {
  background: #ededed;
  max-height: calc(100vh - 94px);
  height: calc(100vh - 94px);
  overflow-y: auto;
  .facility-header {
    padding: 0 8px;
    cursor: pointer;
    &:hover {
      font-weight: bold;
    }
  }
  .fac-name {
    border-bottom: solid lightgray 0.5px;
    border-radius: 2px;
    margin: 1px;
    cursor: pointer;
  }
  .programName {
    position: absolute;
    top: 0;
    width: 100%;
  }
  .fac-name:hover {
    background-color: rgba(91, 192, 222, 0.3);
    cursor: pointer;
  }
  .fac-name {
    &.active {
      background-color: rgba(211, 211, 211, 10%);
      color: #007bff;
    }
    &.active,
    &:hover {
      h5,
      h6 {
        font-weight: 900 !important;
      }
    }
  }
  a {
    color: unset;
    &:hover {
      color: unset;
      text-decoration: unset;
    }
  }
}
</style>
