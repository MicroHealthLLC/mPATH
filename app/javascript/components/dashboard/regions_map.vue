<template>
  <div class="row">
    <div id="map-wrap" class="col">
      <l-map ref="map" :zoom="zoom" @click="addFacilityModal">
        <l-tile-layer :url="url" :attribution="attribution"></l-tile-layer>
        <l-marker 
          v-for="(marker, index) in markers" 
          :key="index" 
          :lat-lng="marker.latlng"
          @add="addNewMarker"
        >
          <l-popup v-if="marker.facility && marker.facility.id">
            <facility-popup-show
              :facility="marker.facility"
              @show-facility="showFacility"
            />
          </l-popup>
          <l-popup v-else >
            <facility-form 
              :marker="marker"
              :marker-key="index"
              @facility-callback="facilityCallback" 
            />
          </l-popup>
        </l-marker>
      </l-map>
    </div>
    <transition name="slide-fade">
      <div v-if="openSidebar" id="map-sidebar" class="col-3">
        <div @click="openSidebar = !openSidebar" class="close-sidebar-btn">
          <i class="material-icons">double_arrow</i>
        </div>
        <facility-show  
          if="currentFacility"
          :facility="currentFacility"
        />
      </div>
    </transition>
  </div>
</template>

<script>
import http         from '../../common/http'
import FacilityForm from './facilities/_short_form'
import FacilityPopupShow from './facilities/_short_show'
import FacilityShow from './facilities/_show'

export default {
  name: 'RegionsMap',
  components: {
    FacilityForm,
    FacilityPopupShow,
    FacilityShow
  },
  data() {
    return {
      loading: true,
      center:[],
      zoom: 5,
      url:'http://{s}.tile.osm.org/{z}/{x}/{y}.png',
      attribution: `&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors`,
      markers: [],
      polyline: {
        latlngs: [],
        color: 'black'
      },
      facilities: [],
      regions: [],
      openSidebar: false,
      currentFacility: null
    }
  },
  mounted() {
    this.fetchRegions();
    this.fetchFacilities();
  },
  methods: {
    fetchRegions() {
      console.log("fetch regions")
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
    addFacilityModal(event) {
      this.markers.push({
        facility: null,
        latlng: event.latlng
      });
    },
    facilityCallback(hash) {
      this.loading = true;
      this.markers = [];
      this.fetchFacilities();
    },
    setFacilityMarkers() {
      for (var index in this.facilities) {
        var facility = this.facilities[index]
        if (facility.latlng == null || facility.latlng == undefined) continue 
        let latlng = facility.latlng.split(/ /g);
        this.markers.push({
          facility: facility,          
          latlng: L.latLng(Number(latlng[0]), Number(latlng[1]))}
        );
      }
    },
    addNewMarker(event) {
      this.$nextTick(() => event.target.openPopup())
    },
    showFacility(facility) {
      this.openSidebar = true
      this.currentFacility = facility
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
    z-index: 999999999;
  }

  /* sidebar transitions */
  .slide-fade-enter-active {
    transition: all .2s ease;
  }
  .slide-fade-leave-active {
    transition: all .2s ease;
  }
  .slide-fade-enter, .slide-fade-leave-to {
    transform: translateX(100px);
    opacity: 0;
  }
  .close-sidebar-btn {
    z-index: 99999;
    cursor: pointer;
    display: flex;
    position: absolute;
    left: 0;
    top: 50px;
    left: -49px;
    background: #fff;
    padding: 5px;
    border-top-left-radius: 15px;
    border-bottom-left-radius: 15px;
    box-shadow: 0 1px 3px rgba(0,0,0,.25);
    i {
      color: #6c757d;
    }
  }
</style>
