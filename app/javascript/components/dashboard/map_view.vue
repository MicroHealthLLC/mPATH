<template>
  <div id="_wrapper" data-cy="map_view">
    <div class="col p-0">
      <div class="row m-0 mw-100">
        <div id="map-wrap" class="col-8 p-0">
          <div class="regions-bar">
            <facility-group-bar
              v-if="contentLoaded"
              :facility-groups="filteredFacilityGroups"
              :facilities="filteredFacilities('active')"
              :project="currentProject"
              @goto-facility-group="gotoFacilityGroup"
            ></facility-group-bar>
          </div>
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
              zoomControl: true,
              mapTypeControl: false,
              scaleControl: true,
              streetViewControl: false,
              fullscreenControl: true
            }"
            @click="resetView"
            >
            <GmapCluster
              :averageCenter="true"
              :enableRetinaIcons="true"
              :ignoreHidden="true"
              :zoomOnClick="true"
              >
              <GmapMarker
                :key="`${facility.id}__${index}`"
                :animation="4"
                v-for="(facility, index) in filterFacilitiesWithActiveFacilityGroups"
                :position="getLatLngForFacility(facility)"
                @click="showFacility(facility)"
                @mouseover="toggleTooltip(facility, `${facility.id}__${index}`)"
                @mouseout="tooltip.opened=false"
                :icon="{url: getStatusIconLink(facility)}"
              />
            </GmapCluster>
            <GmapInfoWindow
              :options="tooltip.options"
              :position="tooltip.position"
              :opened="tooltip.opened"
              @closeclick="tooltip.opened=false"
              >
              {{tooltip.content}}
            </GmapInfoWindow>
          </GmapMap>
        </div>
        <div id="rollup-sidebar" class="col-4 p-0" :style="rollupStyle">
          <div style="margin-left: 12px;">
            <div>
              <facility-rollup v-show="!openSidebar"></facility-rollup>
              <div class="knocker_side" :style="knockerStyle">
                <div v-if="currentFacility && currentFacility.id" class="knocker" @click="toggleOpenSideBar">
                  <div class="linner"></div>
                </div>
                <div id="map-sidebar" class="shadow-sm">
                  <facility-show
                    v-if="currentFacility && currentFacility.id"
                    :facility="currentFacility"
                    :facility-group="currentFacilityGroup"
                    from="map_view"
                    @close-side-bar="closeSidebar"
                    @facility-update="updateFacility"
                  />
                </div>
              </div>
            </div>
          </div>
        </div>

        <sweet-modal
          class="facility_accordion_modal"
          ref="facilitiesAccordion"
          :hide-close-button="true"
          :blocking="true"
          >
          <div v-if="currentFacilityGroup && currentFacilityGroup.id">
            <div class="facility_grp_close_btn" @click.prevent="onCloseAccordion">
              <i class="fa fa-times"></i>
            </div>
            <h3 class="mb-3 text-break">{{currentFacilityGroup.name}} <span class="badge badge-secondary badge-pill">{{facilityGroupFacilities(currentFacilityGroup).length}}</span></h3>
            <div v-if="facilityGroupFacilities(currentFacilityGroup) && facilityGroupFacilities(currentFacilityGroup).length == 0" class="mt-3 text-danger">
              There is no facility under this group
            </div>
            <div v-else>
              <div v-for="facility in facilityGroupFacilities(currentFacilityGroup)">
                <accordion
                  :expanded="expandedFacility.id"
                  :facility="facility.facility"
                  :statuses="statuses"
                  :facility-group="currentFacilityGroup"
                  @update-expanded="updateExpanded"
                ></accordion>
              </div>
            </div>
          </div>
        </sweet-modal>
      </div>
    </div>
  </div>
</template>

<script src="https://cdnjs.cloudflare.com/ajax/libs/markerclustererplus/2.1.4/markerclusterer.js"></script>
<script>
import FacilityShow from './facilities/facility_show'
import FacilityGroupBar from './../shared/facility_group_bar'
import Accordion from './../shared/accordion'
import FacilityRollup from './facilities/facility_rollup'
import {SweetModal} from 'sweet-modal-vue'
import {mapGetters, mapMutations} from 'vuex'
import * as Moment from 'moment'
import {extendMoment} from 'moment-range'
const moment = extendMoment(Moment)

export default {
  name: 'ProjectMapView',
  components: {
    FacilityShow,
    FacilityGroupBar,
    Accordion,
    FacilityRollup,
    SweetModal
  },
  data() {
    return {
      center: {lat: 40.64, lng: -74.66},
      zoom: 3,
      openSidebar: false,
      expandedFacility: {},
      tooltip: {
        position: null,
        content: null,
        opened: false,
        key: null,
        options: {
          pixelOffset: {
            width: 0,
            height: -30
          }
        }
      }
    }
  },
  computed: {
    ...mapGetters([
      'contentLoaded',
      'facilities',
      'facilityGroups',
      'statuses',
      'currentFacility',
      'currentFacilityGroup',
      'currentProject',
      'filteredFacilityGroups',
      'filterFacilitiesWithActiveFacilityGroups',
      'filteredFacilities',
      'facilityGroupFacilities'
    ]),
    knockerStyle() {
      return this.openSidebar ? {} : {transform: "translateX(calc(105% - 12px))"}
    },
    rollupStyle() {
      return this.openSidebar ? {right: '12px'} : {right: '0'}
    },
  },
  methods: {
    ...mapMutations([
      'updateFacilities',
      'setCurrentFacilityGroup',
      'setCurrentFacility'
    ]),
    getLatLngForFacility(facility) {
      return {lat: Number(facility.lat), lng: Number(facility.lng)}
    },
    showFacility(facility) {
      this.openSidebar = true
      if (this.currentFacility && facility.id == this.currentFacility.id) return;
      this.setCurrentFacilityGroup(this.facilityGroups.find(fg => fg.id == facility.facilityGroupId))
      this.center = this.getLatLngForFacility(facility)
      this.$refs.googlemap.panTo(this.center)
      this.setCurrentFacility(facility)
    },
    closeSidebar() {
      this.openSidebar = false
      this.center = this.getLatLngForFacility(this.currentFacility)
      this.setCurrentFacility(null)
    },
    gotoFacilityGroup(facilityGroup) {
      this.setCurrentFacilityGroup(facilityGroup)
      this.$refs.facilitiesAccordion.open()
    },
    updateFacility(facility) {
      this.setCurrentFacility(facility)
      let index = this.facilities.findIndex(f => f.id == facility.id)
      if (index > -1) this.updateFacilities({index, facility})
    },
    updateExpanded(facility) {
      if (facility.id === this.expandedFacility.id) this.expandedFacility = {}
      else this.expandedFacility = facility
    },
    toggleOpenSideBar() {
      this.openSidebar = this.currentFacility ? !this.openSidebar : false
    },
    getStatusIconLink(facility) {
      return 'https://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=|'+ facility.color.split('#')[1]
    },
    resetView() {
      if (this.openSidebar) {
        this.setCurrentFacility(null)
        this.openSidebar = false
      }
    },
    toggleTooltip(marker, key) {
      this.tooltip.position = this.getLatLngForFacility(marker)
      this.tooltip.content = marker.facilityName
      this.tooltip.opened = true
      this.tooltip.key = key
    },
    onCloseAccordion() {
      this.$refs.facilitiesAccordion && this.$refs.facilitiesAccordion.close()
    }
  }
}
</script>

<style scoped lang="scss">
  #_wrapper {
    padding-top: 1px;
    height: calc(100vh - 94px);
    width: 100%;
    display: flex;
    flex-wrap: wrap;
  }
  #map-wrap {
    height: calc(100vh - 94px);
    width: 69vw;
  }
  #rollup-sidebar {
    > div {
      height: calc(100vh - 94px);
    }
    position: absolute;
    top: 0;
    overflow-x: hidden;
    overflow-y: auto;
  }
  #map-sidebar {
    z-index: 800;
    height: calc(100vh - 94px);
    overflow: auto;
    background: white;
    padding: 10px;
  }
  .knocker_side {
    position: absolute;
    width: 95%;
    top: 0;
    transition: .3s ease;
    height: 100%;
    z-index: 1002;
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
  .regions-bar {
    position: absolute;
    top: 10px;
    left: 10px;
    z-index: 800;
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
  .knocker {
    z-index: 9999999;
    cursor: pointer;
    position: absolute;
    top: 40%;
    left: -12px;
    width: 12px;
    border-top-left-radius: 12px;
    border-bottom-left-radius: 12px;
    height: 100px;
    background: #ffa500;
    display: flex;
    align-items: center;
    justify-content: center;
    .linner {
      width: 5px;
      height: 60px;
      border-left: 1px solid #fff;
      border-right: 1px solid #fff;
    }
  }
  .vue-map-container /deep/ button.gm-ui-hover-effect {
    display: none;
    visibility: hidden;
  }
</style>
