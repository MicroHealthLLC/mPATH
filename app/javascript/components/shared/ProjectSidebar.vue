<template>
  <div id="facility_sidebar" class="pl-0" data-cy="facility_list">
    <h4 class="mt-4 text-info text-center" v-if="title">{{ title }}</h4>
    <div class="mb-3 ml-2" style="margin-top:1.8rem">
      <div v-if="contentLoaded">
        <div
          v-for="(group, index) in sortedGroups"
          :key="index"
          class="my-2 pl-2"
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
              v-for="(item, index) in facilityGroupFacilities(group)"
              :key="index"
            >
              <router-link :to="`/programs/${$route.params.programId}/sheet/projects/${item.id}`">
                <div
                  class="d-flex align-items-center expandable fac-name"
                  @click="showFacility(item)"
                  :class="{ active: item.id == currentFacility.id }"
                >
                  <p class="facility-header" data-cy="facilities">
                    {{ item.facility.facilityName }}
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
  },
  mounted() {
    // make the first facility_group expanded
  },
  methods: {
    expandFacilityGroup(group) {
      this.$emit("on-expand-facility-group", group);
    },
    log(t) {
      console.log("this is the group object: " + t);
    },
    showFacility(facility) {
      this.$emit("on-expand-facility", facility);
    },
  },
};
</script>

<style lang="scss" scoped>
#facility_sidebar {
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
    }
    &.active,
    &:hover {
      h5,
      h6 {
        font-weight: 900 !important;
      }
    }
  }
}
</style>
