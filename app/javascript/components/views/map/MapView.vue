<template>
  <div
    v-loading="!contentLoaded"
    element-loading-text="Fetching your data. Please wait..."
    element-loading-spinner="el-icon-loading"
    element-loading-background="rgba(0, 0, 0, 0.8)"
    class="row m-0 mw-100"
  >
    <!-- World Map -->
    <div id="map-wrap" class="col-7 p-0">
      <GmapMap
        ref="googlemap"
        :center="center"
        :zoom="zoom"
        map-type-id="terrain"
        style="width: 100%; height: 100%"
        :control-size="5"
        :options="{
          rotateControl: true,
          minZoom: 2,
          maxZoom: 15,
          zoomControl: true,
          mapTypeControl: false,
          scaleControl: true,
          streetViewControl: false,
          fullscreenControl: true,
          restriction: {
            latLngBounds: {
              north: 85,
              south: -85,
              west: -179.5,
              east: 179.5,
            },
            strictBounds: false,
          },
        }"
        @click="resetView"
        @bounds_changed="captureMapBounds($event)"
      >
        <GmapCluster
          :averageCenter="true"
          :enableRetinaIcons="true"
          :ignoreHidden="true"
          :zoomOnClick="true"
        >
          <GmapMarker
            ref="marker"
            :key="`${facility.id}__${index}`"
            :animation="4"
            v-for="(facility,
            index) in filterFacilitiesWithActiveFacilityGroups"
            :position="getLatLngForFacility(facility)"
            @click="
              showFacility(facility);
              toggleTooltip(facility, `${facility.id}__${index}`);
            "
            @mouseover="tooltipMouseOver(facility, `${facility.id}__${index}`)"
            @mouseout="tooltipMouseOut"
            :icon="{ url: getStatusIconLink(facility) }"
          />
        </GmapCluster>
        <GmapInfoWindow
          :options="tooltip.options"
          :position="tooltip.position"
          :opened="tooltip.opened"
          @closeclick="tooltip.opened = false"
        >
          {{ tooltip.content }}
        </GmapInfoWindow>
      </GmapMap>
    </div>
    <!-- Right panel -->
    <div class="col-5 right-panel px-2">
      <div
        v-if="
          currentFacility !== null &&
            $route.name !== 'MapRollup' &&
            $route.name !== 'MapTaskForm' &&
            $route.name !== 'MapIssueForm' &&
            $route.name !== 'MapRiskForm' &&
            $route.name !== 'MapLessonForm' &&
            $route.name !== 'MapNoteForm'
        "
        class="d-flex align-items-center my-2"
      >
        <i class="fal fa-clipboard-list mh-green-text pr-2"></i>
        <h5 class="f-head mb-0">{{ currentFacility.facilityName }}</h5>
      </div>
      <ProjectTabs
        v-if="
          $route.name !== 'MapRollup' &&
            $route.name !== 'MapTaskForm' &&
            $route.name !== 'MapIssueForm' &&
            $route.name !== 'MapRiskForm' &&
            $route.name !== 'MapLessonForm' &&
            $route.name !== 'MapNoteForm'
        "
      />
      <router-view :key="$route.path" :facility="currentFacility"></router-view>
    </div>
  </div>
</template>

<!-- <script src="https://cdnjs.cloudflare.com/ajax/libs/markerclustererplus/2.1.4/markerclusterer.js"></script>-->
<script> 
  
import Accordion from "../../shared/accordion.vue";
import { mapGetters, mapMutations } from "vuex";
import * as Moment from "moment";
import { extendMoment } from "moment-range";
import ProjectTabs from "../../shared/ProjectTabs.vue";
const moment = extendMoment(Moment);
export default {
  name: "MapView",
  components: {
    Accordion,
    ProjectTabs,
  },
  data() {
    return {
      center: { lat: 20, lng: 0 },
      zoom: 0,
      expandedFacility: {},
      tooltip: {
        position: null,
        content: null,
        opened: false,
        key: null,
        options: {
          pixelOffset: {
            width: 0,
            height: -30,
          },
        },
      },
      mapBounds: {
        south: 0,
        west: 0,
        north: 0,
        east: 0,
      },
      initialFacilities: [],
      facilitiesSet: false,
      mapFacilityCount: null,
      boundsCapturedCount: 0,
    };
  },
  computed: {
    ...mapGetters([
      "contentLoaded",
      "facilities",
      "facilityGroups",
      "currentFacility",
      "currentFacilityGroup",
      "currentProject",
      "filterFacilitiesWithActiveFacilityGroups",
      "filteredFacilities",
      "getShowProjectStats",
      "getMapZoomFilter",
      "getUnfilteredFacilities",
      "getNewSession",
    ]),
    pathTab() {
      let url = this.$route.path;

      if (url.includes("tasks")) {
        return "/tasks";
      } else if (url.includes("issues")) {
        return "/issues";
      } else if (url.includes("risks")) {
        return "/risks";
      } else if (url.includes("lessons")) {
        return "/lessons";
      } else if (url.includes("notes")) {
        return "/notes";
      } else if (url.includes("kanban")) {
        return "/tasks";
      } else {
        return "/";
      }
    },
  },
  methods: {
    ...mapMutations([
      "setCurrentFacilityGroup",
      "setCurrentFacility",
      "setMapZoomFilter",
      "setFacilities",
      'setShowProjectStats',
      "setPreviousRoute",
      "setNewSession",
    ]),
    getLatLngForFacility(facility) {
      return { lat: Number(facility.lat), lng: Number(facility.lng) };
    },
    showFacility(facility) {
      if (this.currentFacility && !this.currentFacilityGroup) {
        this.setCurrentFacilityGroup(
          this.facilityGroups.find((fg) => fg.id == facility.facilityGroupId)
        );
      }
      if (this.currentFacility && facility.id == this.currentFacility.id)
        return;
      this.setCurrentFacilityGroup(
        this.facilityGroups.find((fg) => fg.id == facility.facilityGroupId)
      );
      this.setCurrentFacility(facility);

      this.$router.push(
        `/programs/${this.$route.params.programId}/map/projects/${facility.id}${this.pathTab}`
      );
    },
    updateExpanded(facility) {
      if (facility.id === this.expandedFacility.id) this.expandedFacility = {};
      else this.expandedFacility = facility;
    },
    getStatusIconLink(facility) {
      return (
        "https://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=|" +
        facility.color.split("#")[1]
      );
    },
    resetView() {
      this.setCurrentFacility(null);
      this.tooltip.opened = false;
      this.$router.push(`/programs/${this.$route.params.programId}/map`);
    },
    toggleTooltip(marker, key) {
      this.tooltip.position = this.getLatLngForFacility(marker.facility);
      this.tooltip.content = marker.facilityName;
      this.tooltip.opened = true;
      this.tooltip.key = key;
    },
    tooltipMouseOut() {
      // Tooltip closes only if there is no current facility selected
      if (this.currentFacility === null) {
        this.tooltip.opened = false;
      }
    },
    tooltipMouseOver(marker, key) {
      // Tooltip only appears if appears if there is no current facility selected
      if (this.currentFacility === null) {
        this.tooltip.position = this.getLatLngForFacility(marker);
        this.tooltip.content = marker.facilityName;
        this.tooltip.opened = true;
        this.tooltip.key = key;
      }
    },
    captureMapBounds(payload) {
      // Record initial facilities state and set flag
      if (!this.facilitiesSet && this.contentLoaded) {
        this.initialFacilities = this.facilities;
        this.facilitiesSet = true;
        this.mapFacilityCount = this.initialFacilities.length;
      }
      // Verify bounds_changed event payload is not undefined
      if (payload && this.facilitiesSet) {
        var bounds = JSON.parse(JSON.stringify(payload));
        this.mapBounds.south = bounds.south;
        this.mapBounds.west = bounds.west;
        this.mapBounds.north = bounds.north;
        this.mapBounds.east = bounds.east;
        // Update array of Ids of facilities that are visible on map
        this.setMapZoomFilter(this.visibleMarkers());
        // Set facilities at state level by filtering out non-visible facilities
        if (
          this.getMapZoomFilter.length !== this.mapFacilityCount &&
          this.boundsCapturedCount > 2
        ) {
          this.setFacilities(
            this.initialFacilities.filter((item) =>
              this.getMapZoomFilter.includes(item.id)
            )
          );
          this.mapFacilityCount = this.facilities.length;
        }
      }
      this.boundsCapturedCount++;
    },
    visibleMarkers() {
      return this.initialFacilities
        .filter(
          (item) =>
            Number(item.lng) > this.mapBounds.west &&
            Number(item.lng) < this.mapBounds.east &&
            Number(item.lat) < this.mapBounds.north &&
            Number(item.lat) > this.mapBounds.south
        )
        .map((item) => Number(item.id));
    },
    centerMapToFacilities() {
      var bounds = new google.maps.LatLngBounds();
      var markerPositions = this.facilities.map((facility) =>
        this.getLatLngForFacility(facility)
      );

      for (var i = 0; i < this.facilities.length; i++) {
        var location = new google.maps.LatLng(
          markerPositions[i].lat,
          markerPositions[i].lng
        );
        bounds.extend(location);
      }

      this.$refs.googlemap.fitBounds(bounds);
      this.$refs.googlemap.panToBounds(bounds);
      this.$refs.googlemap.fitBounds(bounds);
    },
  },
  mounted() {
    // Display notification if the Map Boundary Filter is still on
    if(this.getShowProjectStats){
     this.setShowProjectStats(!this.getShowProjectStats)
    }

    if (this.facilities.length !== this.getUnfilteredFacilities.length) {
      this.$notify.info({
        title: "Filter Set",
        message:
          "A filter was set based on the previous map boundary. Reset the Map Boundary Filter in the Advanced Filters tab.",
        offset: 150,
        position: "bottom-left",
      });
    }
    // Store the map route name for check when redirecting to other pages
    this.setPreviousRoute(this.$route.name);
  },
  beforeMount() {
    if (this.contentLoaded && this.$route.params.projectId) {
      this.setCurrentFacility(
        this.facilities.find(
          (facility) => facility.facilityId == this.$route.params.projectId
        )
      );
      // Display tooltip for current project
      this.toggleTooltip(this.currentFacility);
    }
  },
  watch: {
    facilities: function() {
      if (!this.facilitiesSet) {
        this.centerMapToFacilities();
      }
      // This will fire off when Map Boundary Filter is reset due to facilities changing
      if (
        this.facilitiesSet &&
        this.facilities.length === this.getUnfilteredFacilities.length
      ) {
        this.initialFacilities = this.getUnfilteredFacilities;
        this.centerMapToFacilities();
      }
    },
    initialFacilities: function() {
      this.centerMapToFacilities();
    },
    facilitiesSet: function() {
      // Only runs once during session due to newSession from state
      if (
        Vue.prototype.$preferences.navigation_menu === "map" &&
        this.facilitiesSet &&
        Vue.prototype.$preferences.project_id &&
        this.getNewSession
      ) {
        var ff = this.facilities.find(
          (f) => f.id == Vue.prototype.$preferences.project_id
        );
        if (ff) {
          // Set the facilities based on preference facility (project). Only one project so
          // map will automatically zoom on that facility due to watcher for facilities
          // above.
          this.setFacilities(
            this.getUnfilteredFacilities.filter(
              (facility) =>
                facility.id === Vue.prototype.$preferences.project_id
            )
          );
          // Highlight preferred facility in right panel
          this.setCurrentFacility(ff);
          this.showFacility(ff);
          this.updateExpanded(ff);
          this.centerMapToFacilities();
          this.toggleTooltip(ff, "asdfafsdfawerasdf");
          // Sets newSession in state to false so this conditional doesn't pass again
          this.setNewSession();
        }
      }
    },
    contentLoaded: {
      handler() {
        if (this.$route.params.projectId) {
          this.setCurrentFacility(
            this.currentProject.facilities.find(
              (facility) => facility.facilityId == this.$route.params.projectId
            )
          );
          // Display tooltip for current project
          this.toggleTooltip(this.currentFacility);
        }
      },
    },
    "$route.path": {
      handler() {
        this.setCurrentFacility(
          this.facilities.find(
            (facility) => facility.facilityId == this.$route.params.projectId
          )
        );
      },
    },
  },
};
</script>

<style scoped lang="scss">
#map-wrap {
  height: calc(100vh - 100px);
}
.right-panel {
  height: calc(100vh - 100px);
  overflow-y: auto;
}
.vue-map-container ::v-deep button.gm-ui-hover-effect {
  display: none;
  visibility: hidden;
}
</style>
