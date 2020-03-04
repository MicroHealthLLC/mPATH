<template>
  <div class="row m-0 mw-100">
    <div v-if="!loading" id="map-wrap" class="col p-0">
      <!-- <div class="regions-bar">
        <region-bar
          :regions="regions"
          @goto-region="gotoRegion"
        />
      </div> -->
      <GmapMap
        ref="googlemap"
        :center="center"
        :zoom="zoom"
        map-type-id="terrain"
        style="width: 100%; height: 99%"
        :control-size="5"
        :options="{
          rotateControl: true,
          minZoom: 2,
          zoomControl: true,
          mapTypeControl: false,
          scaleControl: true,
          streetViewControl: false,
          fullscreenControl: true
        }"
      >
        <GmapCluster
          :averageCenter="true"
          :enableRetinaIcons="true"
          :ignoreHidden="true"
          :zoomOnClick="true"
        >
          <GmapMarker
            :key="index"
            :animation="4"
            v-for="(facility, index) in facilities"
            :position="getLatLngForFacility(facility)"
            @click="showFacility(facility)"
          />
        </GmapCluster>
      </GmapMap>
    </div>
    <transition name="slide-fade">
      <div v-if="openSidebar" id="map-sidebar">
        <div @click="closeSidebar" class="close-sidebar-btn">
          <i class="fas fa-minus"></i>
        </div>
        <facility-show
          v-if="currentFacility"
          :facility="currentFacility"
          :region="currentRegion"
          @back-after-delete="backFromFacilityShow"
          @edit-facility="editFacility"
        />
      </div>
    </transition>

    <sweet-modal
      ref="facilityForm"
      overlay-theme="dark"
      :title="facilityModalTitle"
      @close="closeFacilityModal"
      :blocking="true"
    >
      <facility-form
        v-if="facilityFormModal"
        :facility="currentFacility"
        :regions="regions"
        @facility-created="createdFacility"
        @facility-update="updateFacility"
        @close-facility="$refs.facilityForm.close"
        class="facility-form-modal"
      ></facility-form>
    </sweet-modal>
  </div>
</template>

<script src="https://cdnjs.cloudflare.com/ajax/libs/markerclustererplus/2.1.4/markerclusterer.js"></script>
<script>
import http              from '../../common/http'
import FacilityForm      from './facilities/facility_form'
import FacilityShow      from './facilities/facility_show'
import RegionBar         from './../shared/region_bar'
import RegionsRaw        from '../../fixtures/countries_raw.json'
import StatesRaw         from '../../fixtures/usa_states.json'
import utils             from '../../mixins/utils'
import { SweetModal }    from 'sweet-modal-vue'

export default {
  name: 'RegionsMap',
  mixins: [ utils ],
  props: ['withFacility'],
  components: {
    FacilityForm,
    FacilityShow,
    RegionBar,
    SweetModal
  },
  data() {
    return {
      loading: true,
      center: {lat: 40.64, lng: -74.66},
      zoom: 3,
      currentRegion: null,
      facilities: [],
      regions: [],
      openSidebar: false,
      currentFacility: null,
      facilityFormModal: false,
      showFacilities: true
    }
  },
  mounted() {
    this.fetchRegions()
  },
  computed: {
    isCreator() {
      return this.currentFacility.creator && this.$currentUser && (this.$currentUser.id === this.currentFacility.creator.id)
    },
    facilityModalTitle() {
      return this.currentFacility ? "Edit facility" : "Add Facility"
    }
  },
  methods: {
    fetchRegions() {
      http
        .get(`/facility_groups.json`)
        .then((res) => {
          this.regions = res.data.facilityGroups;
          this.fetchFacilities();
        })
        .catch((err) => {
          console.error(err);
        })
    },
    fetchFacilities() {
      http
        .get(`/projects/${this.$route.params.projectId}/facilities.json`)
        .then((res) => {
          this.facilities = res.data.facilities;
          this.loading = false;
        })
        .catch((err) => {
          this.loading = false;
          console.error(err);
        })
    },
    setCurrentRegion(region) {
      this.currentRegion = region;
    },
    getLatLngForFacility(facility) {
      return L.latLng(Number(facility.lat), Number(facility.lng))
    },
    showFacility(facility) {
      this.openSidebar = true
      this.currentRegion = this.regions.find(region => region.id == facility.regionId)
      this.center = this.getLatLngForFacility(facility)
      this.zoom = 17
      this.$refs.googlemap.panTo(this.center)
      this.currentFacility = facility
    },
    closeSidebar() {
      this.openSidebar = false
      this.center = this.getLatLngForFacility(this.currentFacility)
      this.currentFacility = null
    },
    gotoRegion(region) {
      this.currentRegion = region
      if (region.states.length > 0) {
        this.center = this.centerForRegion(region)
      }
    },
    backFromFacilityShow(facility) {
      this.openSidebar = false
      this.currentFacility = null
    },
    editFacility(facility) {
      this.currentFacility = facility
      if (!this.isCreator) return
      this.openSidebar = false
      this.facilityFormModal = true
      this.$refs.facilityForm.open()
    },
    updateFacility(facility) {
      this.currentFacility = facility
      this.openSidebar = true
      this.facilityFormModal = false
      this.$refs.facilityForm.close()
    },
    closeFacilityModal() {
      this.facilityFormModal = false
      this.$emit('nullify-modals');
    },
    createdFacility(facility) {
      this.$refs.facilityForm.close()
      this.facilities.push(facility)
    },
    zoomInRegion(region) {
      this.currentRegion = region
      var new_center = this.centerForRegion(region)
      this.regions.forEach((r) => r.visible = r.id !== region.id)
      this.center = new_center
      this.zoom = 8
    },
    centerForRegion(region) {
      const average = arr => arr.reduce((p, c) => p+c, 0) / arr.length
      var lat = []
      var lng = []
      if (region.states == null || region.states.length <= 0) return []
      for (var index in region.states) {
        var new_center = JSON.parse(region.states[index].center)
        lat.push(new_center[0])
        lng.push(new_center[1])
      }
      return L.latLng(average(lat), average(lng))
    }
  },
  watch: {
    withFacility: {
      handler: function(value) {
        if (value) {
          this.currentFacility = null
          this.openSidebar = false
          this.facilityFormModal = true
          this.$refs.facilityForm.open()
        }
      }, deep: true
    }
  }
}
</script>

<style scoped lang="scss">
  #map-wrap {
    height: calc(100vh - 130px);
    width: 100%;
  }
  #map-sidebar {
    position: absolute;
    overflow: auto;
    top: 0;
    z-index: 800;
    background: white;
    right: 0;
    width: 35vw;
    height: calc(100vh - 130px);
    padding: 10px;
    box-shadow: 0 1px 3px rgba(0,0,0,.15);
  }

  /* sidebar transitions */
  .slide-fade-enter-active {
    transition: all .4s ease;
  }
  .slide-fade-leave-active {
    transition: all .4s ease-in;
  }
  .slide-fade-enter, .slide-fade-leave-to {
    transform: translateX(100px);
    opacity: 0;
  }
  .close-sidebar-btn {
    z-index: 800;
    cursor: pointer;
    display: flex;
    position: absolute;
    left: 0;
    top: 0;
    background: #fff;
    padding: 5px;
  }
  .regions-bar {
    position: absolute;
    top: 10px;
    left: 10px;
    z-index: 800;
  }
  .sweet-modal-overlay /deep/ .sweet-modal {
    max-height: 75vh;
    min-width: 50vw;
    .sweet-title {
      display: flex;
      align-items: center;
    }
  }
</style>
