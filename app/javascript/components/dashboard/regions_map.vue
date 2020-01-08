<template>
  <div class="row m-0 mw-100">
    <div id="map-wrap" class="col p-0">
      <div class="regions-bar">
        <region-bar 
          :regions="regions"
          @goto-region="gotoRegion"
        >    
        </region-bar>
      </div>
      <l-map ref="leafmap" :zoom="zoom" :center="center" @click="addFacilityModal">
        <l-tile-layer :noWrap="true" :url="url" :attribution="attribution"></l-tile-layer>
        <l-polygon
          v-for="(region, index) in regions"
          @click="setCurrentRegion(region)"
          :region="region"
          :key="region.id"
          :lat-lngs="getLatLng(region)"
          :color="region.color"
          :fill-color="region.color"
        >
        </l-polygon>
        <l-marker 
          v-for="(marker, index) in markers" 
          :lat-lng="marker.latlng"
          :key="`${marker.region.id}__${index}`"
          @add="addNewMarker"
        >
          <l-popup v-if="marker.facility && marker.facility.id">
            <facility-popup-show
              :facility="marker.facility"
              @show-facility="showFacility"
              @edit-facility="editFacility"
            />
          </l-popup>
          <l-popup v-else @remove="removeEmptyMarkers">
            <short-facility-form 
              :marker="marker"
              :marker-key="index"
              @facility-callback="facilityCallback" 
            />
          </l-popup>
        </l-marker>
      </l-map>
    </div>
    <transition name="slide-fade">
      <div v-if="openSidebar" id="map-sidebar">
        <div @click="openSidebar = !openSidebar" class="close-sidebar-btn">
          <i class="fas fa-minus"></i>
        </div>
        <facility-show  
          v-if="currentFacility"
          :facility="currentFacility"
          @back-after-delete="backFromFacilityShow"
          @edit-facility="editFacility"
        />
      </div>
    </transition>

    <sweet-modal 
      ref="editFacilityForm" 
      overlay-theme="dark"
      title="Edit Facility"
    >
      <facility-form
        v-if="currentFacility"
        :facility="currentFacility"
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
      zoom: 6,
      url:'http://{s}.tile.osm.org/{z}/{x}/{y}.png',
      attribution: `&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors`,
      markers: [],
      currentRegion: null,
      facilities: [],
      regions: [],
      openSidebar: false,
      currentFacility: null,
      targetMarker: null
    }
  },
  mounted() {
    this.fetchRegions();
    this.fetchFacilities();
  },
  computed: {
    isCreator() {
      return this.currentFacility.creator && this.$currentUser && (this.$currentUser.id === this.currentFacility.creator.id)
    },
    getLatLng() {
      return function(region) {
        var data = null
        if (region.code == null || region.code == undefined || region.code === 'EMPTY') {return [];}
        if (region.regionType === "state") {
          data = StatesRaw.features.find(feature => feature.properties.NAME === region.code)
        }
        else if (region.regionType === "country") {
          data = RegionsRaw.features.find(feature => feature.properties.ISO_A3 == region.code)
        }
        if (data == null || data == undefined) {return [];}
        var coordinates = data.geometry.coordinates
        this.getSorted(coordinates)
        return coordinates;
      } 
    }
  },
  methods: {
    fetchRegions() {
      http
        .get('/regions.json')
        .then((res) => {
          this.regions = res.data.regions;
        })
        .catch((err) => {
          console.error(err);
        })
    },
    fetchFacilities() {
      http
        .get('/facilities.json')
        .then((res) => {
          this.facilities = res.data.facilities;
          this.loading = false;
          this.setFacilityMarkers();
        })
        .catch((err) => {
          this.loading = false;
          console.error(err);
        })
    },
    setCurrentRegion(region) {
      this.currentRegion = region;
    },
    addFacilityModal(event) {
      this.markers.push({
        region: this.currentRegion,
        facility: null,
        latlng: event.latlng
      });
      this.$nextTick(() => this.targetMarker.openPopup())
    },
    facilityCallback(hash) {
      this.loading = true;
      this.markers = [];
      this.currentRegion = null;
      this.fetchFacilities();
    },
    setFacilityMarkers() {
      for (var index in this.facilities) {
        var facility = this.facilities[index]
        if (facility.latlng == null || facility.latlng == undefined) continue 
        let latlng = facility.latlng.split(/ /g);
        this.markers.push({
          region: facility.region,
          facility: facility,          
          latlng: L.latLng(Number(latlng[0]), Number(latlng[1]))
        });
      }
    },
    addNewMarker(event) {
      this.targetMarker = event.target
    },
    showFacility(facility) {
      this.openSidebar = true
      this.currentFacility = facility
    },
    gotoRegion(region) {
      this.currentRegion = region
      var new_center = JSON.parse(region.center)
      if (new_center) {
        this.center = L.latLng(new_center[0], new_center[1])
        this.zoom = 6
      }
    },
    removeEmptyMarkers() {
      this.currentRegion = null
      this.markers = this.markers.filter((m) => m.facility !== null)
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
      this.$refs.editFacilityForm.open()
    },
    updateFacility(facility) {
      this.currentFacility = facility
      this.openSidebar = true
      this.$refs.editFacilityForm.close()
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
    width: 24vw;
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
    left: -24px;
    background: #fff;
    padding: 5px;
    border-top-left-radius: 5px;
    border-bottom-left-radius: 5px;
  }
  .regions-bar {
    position: absolute;
    top: 90px;
    left: 10px;
    z-index: 800;
  }
  .sweet-modal-overlay /deep/ .sweet-modal {
    max-height: 65vh;
    .sweet-title {
      display: flex;
      align-items: center;
    }
  }
</style>
