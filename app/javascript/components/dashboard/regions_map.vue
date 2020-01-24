<template>
  <div class="row m-0 mw-100">
    <div v-if="!loading" id="map-wrap" class="col p-0">
      <div class="regions-bar">
        <region-bar 
          :regions="regions"
          @goto-region="gotoRegion"
        >    
        </region-bar>
      </div>
      <l-map 
        ref="leafmap" 
        :min-zoom="minZoom" 
        :zoom="zoom" 
        :center="center"
      >
        <l-tile-layer 
          :noWrap="true" 
          :url="url" 
          :attribution="attribution"
        ></l-tile-layer>
        <l-marker 
          v-for="(region, index) in regions" 
          :lat-lng="centerForRegion(region)"
          :key="`${region.id}__${index}`"
          :visible="region.facilityCount > 0 && region.visible"
          @click="zoomInRegion(region)"
        >
          <l-icon 
            :icon-anchor="iconAnchor" 
            class-name="map-count-marker"
          >
            <div class="heading">
              <div>
                <div class="f-counter shadow">
                  <span>{{region.facilityCount}}</span>
                </div>
                <div class="row mr-0">
                  <div class="col-6 p-0">
                    <div class="bg-primary markericon top-left"></div>
                    <div class="bg-warning markericon bottom-left"></div>
                  </div>
                  <div class="col-6 p-0">
                    <div class="bg-danger markericon top-right"></div>
                    <div class="bg-info markericon bottom-right"></div>
                  </div>
                </div>
              </div>
            </div>
          </l-icon>
        </l-marker>
        <l-marker 
          v-for="(facility, index) in facilities" 
          :lat-lng="getLatLngForFacility(facility)"
          :key="`${facility.id}_facility_${index}`"
          :visible="isVisible(facility)"
          @click="showFacility(facility)"
        ></l-marker>
        <l-polygon
          v-for="(region, index) in regionPolygons"
          :key="`${region.id}_polygon`"
          :lat-lngs="getLatLngs(region)"
          :color="region.color"
          :fill-color="region.color"
        ></l-polygon>
      </l-map>
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
    >
      <facility-form
        v-if="DV_facilityForm"
        :facility="currentFacility"
        :regions="regions"
        @facility-created="createdFacility"
        @facility-update="updateFacility"
        class="facility-form-modal"
      ></facility-form>
    </sweet-modal>
  </div>
</template>

<script>
import http              from '../../common/http'
import ShortFacilityForm from './facilities/_short_form'
import FacilityForm      from './facilities/_form'
import FacilityPopupShow from './facilities/_short_show'
import FacilityShow      from './facilities/_show'
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
    ShortFacilityForm,
    FacilityForm,
    FacilityPopupShow,
    FacilityShow,
    RegionBar,
    SweetModal
  },
  data() {
    return {
      loading: true,
      center: [40.64730356252251, -74.66308593750001],
      newCenter: null,
      zoom: 7,
      minZoom: 5,
      iconAnchor: [16, 37],
      url:'http://{s}.tile.osm.org/{z}/{x}/{y}.png',
      attribution: `&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors`,
      markers: [],
      countMarkers: [],
      currentRegion: null,
      facilities: [],
      regions: [],
      regionPolygons: [],
      openSidebar: false,
      currentFacility: null,
      targetMarker: null,
      DV_facilityForm: false,
      updated: false
    }
  },
  mounted() {
    this.fetchRegions();
  },
  beforeUpdate() {
    if (this.updated && this.newCenter) {
      this.zoom = 8
      this.updated = false
    }
  },
  updated() {
    if (this.newCenter) {
      this.$refs.leafmap.mapObject.flyTo(this.newCenter, 9)
      this.newCenter = null
    }
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
        .get('/regions.json')
        .then((res) => {
          this.regions = res.data.regions;
          this.regionPolygons = res.data.regions;
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
          this.setRegionCountMarkers();
          this.loading = false;
        })
        .catch((err) => {
          this.loading = false;
          console.error(err);
        })
    },
    setRegionCountMarkers() {
      let countArr = _.map(_.countBy(this.facilities, "regionId"), (val, key) => ({ regionId: key, facilityCount: val }))
      this.regions.forEach((region) => {
        let foundRegion = countArr.find(count => count.regionId == region.id)
        region.facilityCount = foundRegion ? foundRegion.facilityCount : 0
        region.visible = true
      })
    },
    setCurrentRegion(region) {
      this.currentRegion = region;
    },
    getLatLngForFacility(facility) {
      return L.latLng(Number(facility.lat), Number(facility.lng))
    },
    addFacilityModal(event) {
      this.markers.push({
        region: this.currentRegion,
        facility: null,
        latlng: event.latlng
      });
    },
    isVisible(facility) {
      var region = this.regions.find(r => r.id == facility.regionId)
      return !region.visible
    },
    showFacility(facility) {
      this.openSidebar = true
      var new_center = this.getLatLngForFacility(facility)
      this.center = new_center
      this.newCenter = new_center
      this.zoom = 7
      this.updated = true
      this.currentFacility = facility
    },
    closeSidebar() {
      this.openSidebar = false
      var new_center = this.getLatLngForFacility(this.currentFacility)
      this.center = new_center
      this.newCenter = new_center
      this.zoom = 7
      this.updated = true
      this.currentFacility = null
    },
    gotoRegion(region) {
      this.currentRegion = region
      if (region.states.length > 0) {
        var new_center = this.centerForRegion(region)
        this.center = new_center
        this.newCenter = new_center
        this.zoom = 7
        this.updated = true
      }
    },
    backFromFacilityShow(facility) {
      this.openSidebar = false
      this.currentFacility = null
      this.markers = this.markers.filter((m) => m.facility !== null && m.facility.id !== facility.id)
    },
    editFacility(facility) {
      this.currentFacility = facility
      if (!this.isCreator) {return;}
      this.openSidebar = false
      this.DV_facilityForm = true
      this.$refs.facilityForm.open()
    },
    updateFacility(facility) {
      this.currentFacility = facility
      this.openSidebar = true
      this.DV_facilityForm = false
      this.$refs.facilityForm.close()
    },
    closeFacilityModal() {
      this.DV_facilityForm = false
      this.$emit('nullify-modals');
    },
    createdFacility(facility) {
      this.$refs.facilityForm.close()
      var region = this.regions.find(r => r.id == facility.regionId)
      this.facilities.push(facility)
      region.facilityCount += 1
    },
    zoomInRegion(region) {
      this.loading = true
      this.currentRegion = region
      var new_center = this.centerForRegion(region)
      this.regions.forEach((r) => r.visible = r.id !== region.id)
      this.newCenter = new_center
      this.zoom = 7
      this.loading = false
      this.updated = true
    },
    getLatLngs(region) {
      var data = []
      if (region.states == null || region.states == []) return []
      for (var index in region.states) {
        var state = region.states[index]
        var data_raw = StatesRaw.features.find(feature => feature.properties.NAME === state.code)
        if (data_raw == null || data_raw == undefined) continue
        data.push(data_raw.geometry.coordinates)
      }
      if (data.length <= 0) return []
      this.getSorted(data)
      return data
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
          this.DV_facilityForm = true
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
    top: 0;
    z-index: 800;
    background: white;
    right: 0;
    width: 35vw;
    height: calc(100vh - 130px);
    padding: 10px;
    box-shadow: 0 1px 3px rgba(0,0,0,.15);
    overflow-y: scroll;
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
    top: 90px;
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
  .vue2leaflet-map /deep/ .map-count-marker {
    border-radius: 50%;
    box-shadow: 5px 3px 10px rgba(0, 0, 0, 0.5);
    width: auto !important;
    height: auto !important;
    margin: 0 !important;
    .heading {
      width: 1.25em;
    }
  }
  .markericon {
    width: 15px;
    height: 15px;
  }
  .top-left {
    border-top-left-radius: 8px;
  }
  .bottom-left {
    border-bottom-left-radius: 8px;
  }
  .top-right {
    border-top-right-radius: 8px;
  }
  .bottom-right {
    border-bottom-right-radius: 8px;
  }
  .f-counter {
    text-align: center;
    font-weight: 600;
    background: white;
    position: absolute;
    z-index: 9999;
    right: 4px;
    height: 22px;
    width: 22px;
    top: 4px;
    padding: 3px;
    border-radius: 50%;
  }
</style>
