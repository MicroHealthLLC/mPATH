<template>
  <div class="row m-0 mw-100">
    <div v-if="!loading" id="map-wrap" class="col-8 p-0">
      <div class="regions-bar">
        <region-bar
          :regions="regions"
          @goto-region="gotoRegion"
        />
      </div>
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
            v-for="(facility, index) in filteredFacilities"
            :position="getLatLngForFacility(facility)"
            @click="showFacility(facility)"
          />
        </GmapCluster>
      </GmapMap>
    </div>
    <div v-if="!loading" id="rollup-sidebar" class="col-4 p-0">
      <transition name="roll-fade">
        <div v-show="!openSidebar" class="m-3">
          <div class="text-center">
            <h2>{{facilityCount}} Facilities</h2>
            <p class="mt-2 d-flex align-items-center">
              <span class="w-100 progress pg-content" :class="{ 'progress-0': facilityProgress <= 0 }">
                <div class="progress-bar bg-info" :style="`width: ${facilityProgress}%`">{{facilityProgress}} %</div>
              </span>
            </p>
          </div>
          <hr>
          <div class="my-1">
            <h5 class="text-center">Status</h5>
            <div v-if="facilityCount > 0">
              <div v-for="(_f, s) in facilitiesByStatus">
                <span class="font-weight-bold">{{_f.length}}</span>
                <span> {{s.replace('null', 'No Status')}}</span>
              </div>
            </div>
            <p v-else class="text-muted font-sm">
              no statuses...
            </p>
          </div>
          <hr>
          <div>
            <h5 class="text-center">Facility Groups</h5>
            <div class="row my-2" v-for="region in regions">
              <div class="col-md-9">{{region.name}}</div>
              <div class="col-md-3 d-flex align-items-center">
                <span class="w-100 progress pg-content" :class="{ 'progress-0': facilityGroupProgress(region) <= 0 }">
                  <div class="progress-bar bg-info" :style="`width: ${facilityGroupProgress(region)}%`">{{facilityGroupProgress(region)}} %</div>
                </span>
              </div>
            </div>
          </div>
        </div>
      </transition>
      <transition name="slide-fade">
        <div v-show="openSidebar" id="map-sidebar">
          <div @click="closeSidebar" class="close-sidebar-btn">
            <i class="fas fa-minus"></i>
          </div>
          <facility-show
            v-if="currentFacility"
            :facility="currentFacility"
            :region="currentRegion"
            :statuses="statuses"
            @back-after-delete="backFromFacilityShow"
            @edit-facility="editFacility"
            @facility-update="updateFacility"
          />
        </div>
      </transition>
    </div>

    <sweet-modal
      class="facility_form_modal"
      ref="facilityForm"
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
      />
    </sweet-modal>

    <sweet-modal
      class="facility_accordion_modal"
      ref="facilitiesAccordion"
      :hide-close-button="true"
      :blocking="true"
      >
      <div v-if="currentRegion && currentRegion.id">
        <div class="facility_grp_close_btn" @click="$refs.facilitiesAccordion.close">
          <i class="fas fa-minus"></i>
        </div>
        <h3 class="mb-3 text-break">{{currentRegion.name}}</h3>
        <div v-if="currentRegionFacilities && currentRegionFacilities.length == 0" class="mt-3 text-muted">
          There is no facility under this group
        </div>
        <div v-else>
          <div v-for="facility in currentRegionFacilities">
            <accordion
              :expanded="expandedFacility.id"
              :facility="facility"
              :statuses="statuses"
              :region="currentRegion"
              @update-expanded="updateExpanded"
            />
          </div>
        </div>
      </div>
    </sweet-modal>
  </div>
</template>

<script src="https://cdnjs.cloudflare.com/ajax/libs/markerclustererplus/2.1.4/markerclusterer.js"></script>
<script>
import http              from './../../common/http'
import FacilityForm      from './facilities/facility_form'
import FacilityShow      from './facilities/facility_show'
import RegionBar         from './../shared/region_bar'
import Accordion         from './../shared/accordion'
import utils             from './../../mixins/utils'
import { SweetModal }    from 'sweet-modal-vue'

export default {
  name: 'RegionsMap',
  mixins: [ utils ],
  props: ['withFacility', 'projects', 'statuses', 'status', 'facilityGroups', 'facilityGroup', 'facilityQuery', 'filterFacility'],
  components: {
    FacilityForm,
    FacilityShow,
    RegionBar,
    Accordion,
    SweetModal
  },
  data() {
    return {
      loading: true,
      center: {lat: 40.64, lng: -74.66},
      zoom: 3,
      currentRegion: null,
      facilities: [],
      filters: [],
      regions: this.facilityGroups || [],
      openSidebar: false,
      currentFacility: null,
      facilityFormModal: false,
      showFacilities: true,
      expandedFacility: {}
    }
  },
  mounted() {
    this.fetchFacilities()
  },
  computed: {
    isCreator() {
      return this.currentFacility.creator && this.$currentUser && (this.$currentUser.id === this.currentFacility.creator.id)
    },
    facilityModalTitle() {
      return this.currentFacility ? "Edit facility" : "Add Facility"
    },
    facilityCount() {
      return this.facilities.length
    },
    facilityProgress() {
      var mean = _.meanBy(this.facilities, 'progress') || 0
      return mean.toFixed(2)
    },
    filteredFacilities() {
      var valid = this.filters.length <= 0
      return _.filter(this.facilities, (facility) => {
        _.each(this.filters, (f) => {
          var k = Object.keys(f)[0]
          valid = valid && Array.isArray(facility[k]) ? facility[k].includes(f[k]) : facility[k] == f[k]
        })
        return valid
      })
    },
    facilitiesByStatus() {
      return _.groupBy(this.facilities, 'status')
    },
    currentRegionFacilities() {
      if (this.currentRegion && this.currentRegion.facilities) {
        var facilityIds = _.map(this.facilities, 'id')
        return _.filter(this.currentRegion.facilities, (f => facilityIds.includes(f.id)))
      }
      else {
        return []
      }
    }
  },
  methods: {
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
    getLatLngForFacility(facility) {
      return L.latLng(Number(facility.lat), Number(facility.lng))
    },
    showFacility(facility) {
      this.openSidebar = true
      this.currentRegion = this.regions.find(region => region.id == facility.facilityGroupId)
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
      this.$refs.facilitiesAccordion.open()
    },
    backFromFacilityShow(facility) {
      this.openSidebar = false
      this.currentFacility = null
    },
    editFacility(facility) {
      this.currentFacility = facility
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
    },
    updateExpanded(facility) {
      if (facility.id === this.expandedFacility.id) {
        this.expandedFacility = {}
      }
      else {
        this.expandedFacility = facility
      }
    },
    facilityGroupProgress(f_group) {
      var facilityIds = _.map(this.facilities, 'id')
      var mean = _.meanBy(_.filter(f_group.facilities, (f => facilityIds.includes(f.id))), 'progress') || 0
      return mean.toFixed(2)
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
    },
    status: {
      handler: function(value) {
        if (value) {
          if (value.id === 'sa') {
            this.filters = _.filter(this.filters, (f) => !f.hasOwnProperty('statusId'))
          }
          else {
            this.filters.push({statusId: value.id})
          }
        }
      }, deep: true
    },
    facilityGroup: {
      handler: function(value) {
        if (value) {
          if (value.id === 'sa') {
            this.filters = _.filter(this.filters, (f) => !f.hasOwnProperty('facilityGroupId'))
          }
          else {
            this.filters.push({facilityGroupId: value.id})
          }
        }
      }, deep: true
    },
    facilityQuery: {
      handler: function({q, cb}) {
        if (q) {
          var filtered = _.filter(this.filteredFacilities, (f) => f.facilityName.includes(q))
          cb(filtered)
        }
        else {
          cb(this.filteredFacilities)
        }
      }, deep: true
    },
    filterFacility: {
      handler: function(facility) {
        if (facility && facility.id) {
          this.filters.push({id: facility.id})
          this.showFacility(facility)
        }
        else {
          this.filters = _.filter(this.filters, (f) => !f.hasOwnProperty('id'))
        }
      }
    }
  }
}
</script>

<style scoped lang="scss">
  #map-wrap {
    height: calc(100vh - 130px);
    width: 69vw;
  }
  #rollup-sidebar {
    width: 31vw;
    height: calc(100vh - 130px);
    overflow: auto;
  }
  #map-sidebar {
    z-index: 800;
    background: white;
    padding: 10px;
  }

  /* sidebar transitions */
  .slide-fade-enter-active {
    transition: all .2s ease;
  }
  .slide-fade-leave-active {
    transition: all .3s ease;
  }
  .slide-fade-enter, .slide-fade-leave-to {
    transform: translateX(100px);
    opacity: 0;
  }
  .roll-fade-enter-active {
    transition: all .2s ease;
  }
  .roll-fade-leave-active {
    transition: all .3s ease;
  }
  .roll-fade-enter, .roll-fade-leave-to {
    opacity: 0;
    transform: translate(100px, 50px);
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
  .facility_form_modal.sweet-modal-overlay /deep/ .sweet-modal {
    max-height: 80vh;
    min-width: 50vw;
    .sweet-title {
      display: flex;
      align-items: center;
    }
  }
  .facility_accordion_modal.sweet-modal-overlay /deep/ .sweet-modal {
    min-width: 50vw;
    .sweet-content {
      padding-top: 30px;
    }
    .facility_grp_close_btn {
      display: flex;
      position: absolute;
      top: 15px;
      left: 15px;
      cursor: pointer;
    }
  }
</style>
