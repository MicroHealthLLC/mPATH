<template>
  <div id="_wrapper">
    <div class="col p-0">
      <div class="row m-0 mw-100">
        <div v-if="!mapLoading" id="map-wrap" class="col-8 p-0">
          <div class="regions-bar">
            <facility-group-bar
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
        <div v-else class="col-8 p-0"></div>
        <div id="rollup-sidebar" class="col-4 p-0" :style="rollupStyle">
          <div style="margin-left: 12px;">
            <div v-if="!sideLoading">
              <div v-show="!openSidebar" class="m-3">
                <div class="text-info font-weight-bold">Project Type: {{currentProject.projectType}}</div>
                <br>
                <div class="text-center">
                  <h2>{{facilityCount}} Facilities</h2>
                  <p class="mt-2 d-flex align-items-center">
                    <span class="w-100 progress pg-content" :class="{ 'progress-0': facilityProgress <= 0 }">
                      <div class="progress-bar bg-info" :style="`width: ${facilityProgress}%`">{{facilityProgress}} %</div>
                    </span>
                  </p>
                  <div v-if="facilityCount > 0" class="d-flex justify-content-around">
                    <div>
                      <span> active</span>
                      <span class="badge badge-secondary badge-pill">{{facilitiesByStatus.active}}</span>
                    </div>
                    <div>
                      <span> inactive</span>
                      <span class="badge badge-secondary badge-pill">{{facilitiesByStatus.inactive}}</span>
                    </div>
                  </div>
                </div>
                <hr>
                <div class="my-1">
                  <h5 class="text-center">Facility Project Status</h5>
                  <div v-if="facilityCount > 0">
                    <div v-for="(_f, s) in facilitiesByProjectStatus">
                      <div class="row">
                        <div class="col-md-9">
                          <span class="badge badge-pill" :style="`background: ${_f[0].color}`" style="height: 10px">&nbsp;</span>
                          <span> {{s.replace('null', 'No Status')}}</span>
                          <span class="badge badge-secondary badge-pill">{{_f.length}}</span>
                        </div>
                        <div class="col-md-3 d-flex align-items-center">
                          <span class="w-100 progress pg-content" :class="{ 'progress-0': getAverage(_f.length, filteredFacilities('active').length) <= 0 }">
                            <div class="progress-bar bg-info" :style="`width: ${getAverage(_f.length, filteredFacilities('active').length)}%`">{{getAverage(_f.length, filteredFacilities('active').length)}} %</div>
                          </span>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
                <hr>
                <div class="my-1">
                  <h5 class="text-center">{{currentTasks.length}} Tasks</h5>
                  <div>
                    <div class="row">
                      <div class="col-md-9">
                        <span>Complete</span>
                        <span class="badge badge-secondary badge-pill">{{completedTasks().count}}</span>
                      </div>
                      <div class="col-md-3 d-flex align-items-center">
                        <span class="w-100 progress pg-content" :class="{ 'progress-0': completedTasks().avg <= 0 }">
                          <div class="progress-bar bg-info" :style="`width: ${completedTasks().avg}%`">{{completedTasks().avg}} %</div>
                        </span>
                      </div>
                    </div>
                    <div class="row">
                      <div class="col-md-9">
                        <span>Incomplete</span>
                        <span class="badge badge-secondary badge-pill">{{incompletedTasks.count}}</span>
                      </div>
                      <div class="col-md-3 d-flex align-items-center">
                        <span class="w-100 progress pg-content" :class="{ 'progress-0': incompletedTasks.avg <= 0 }">
                          <div class="progress-bar bg-info" :style="`width: ${incompletedTasks.avg}%`">{{incompletedTasks.avg}} %</div>
                        </span>
                      </div>
                    </div>
                  </div>
                  <br>
                  <div class="text-info font-weight-bold text-center">Task Types</div>
                  <div v-for="task in currentTaskTypes">
                    <div class="row">
                      <div class="col-md-9">
                        <span> {{task.name}}</span>
                        <span class="badge badge-secondary badge-pill">{{task.length}}</span>
                      </div>
                      <div class="col-md-3 d-flex align-items-center">
                        <span class="w-100 progress pg-content" :class="{ 'progress-0': task.progress <= 0 }">
                          <div class="progress-bar bg-info" :style="`width: ${task.progress}%`">{{task.progress}} %</div>
                        </span>
                      </div>
                    </div>
                  </div>
                </div>
                <hr>
                <div class="my-1">
                  <h5 class="text-center">{{currentIssues.length}} Issues</h5>
                  <div v-for="issue in currentIssueTypes">
                    <div class="row">
                      <div class="col-md-9">
                        <span> {{issue.name}}</span>
                        <span class="badge badge-secondary badge-pill">{{issue.length}}</span>
                      </div>
                      <div class="col-md-3 d-flex align-items-center">
                        <span class="w-100 progress pg-content" :class="{ 'progress-0': issue.progress <= 0 }">
                          <div class="progress-bar bg-info" :style="`width: ${issue.progress}%`">{{issue.progress}} %</div>
                        </span>
                      </div>
                    </div>
                  </div>
                </div>
                <hr>
                <div>
                  <h5 class="text-center">Facility Groups</h5>
                  <div class="row my-2" v-for="facilityGroup in filteredFacilityGroups">
                    <div class="col-md-9 font-md">
                      <span class="badge badge-pill" :class="{'badge-success':
                        facilityGroup.status == 'active', 'badge-danger': facilityGroup.status == 'inactive'}">
                        {{facilityGroup.status}}
                      </span>
                      <span>{{facilityGroup.name}}</span>
                      <span class="badge badge-secondary badge-pill">{{facilityGroupFacilities(facilityGroup).length}}</span>
                    </div>
                    <div class="col-md-3 d-flex align-items-center">
                      <span class="w-100 progress pg-content" :class="{ 'progress-0': facilityGroupProgress(facilityGroup) <= 0 }">
                        <div class="progress-bar bg-info" :style="`width: ${facilityGroupProgress(facilityGroup)}%`">{{facilityGroupProgress(facilityGroup)}} %</div>
                      </span>
                    </div>
                  </div>
                </div>
              </div>
              <div class="knocker_side" :style="knockerStyle">
                <div v-if="currentFacilityStatus" class="knocker" @click="toggleOpenSideBar">
                  <div class="linner"></div>
                </div>
                <div id="map-sidebar" class="shadow-sm">
                  <facility-show
                    v-if="currentFacilityStatus"
                    :facility="currentFacility"
                    :facility-group="currentFacilityGroup"
                    :statuses="statuses"
                    @close-side-bar="closeSidebar"
                    @edit-facility="editFacility"
                    @facility-update="updateFacility"
                  />
                  <div v-else class="d-flex justify-content-center align-items-center h-75">
                    <loader :loading="true" color="black"></loader>
                    <p class="__loading">Loading</p>
                  </div>
                </div>
              </div>
            </div>
            <div v-else class="d-flex justify-content-center align-items-center h-75">
              <loader :loading="true" color="black"></loader>
              <p class="__loading">Loading</p>
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
            <div class="facility_grp_close_btn" @click="onCloseAccordion">
              <i class="fa fa-times"></i>
            </div>
            <h3 class="mb-3 text-break">{{currentFacilityGroup.name}} <span class="badge badge-secondary badge-pill">{{currentFacilityGroupFacilities.length}}</span></h3>
            <div v-if="currentFacilityGroupFacilities && currentFacilityGroupFacilities.length == 0" class="mt-3 text-danger">
              There is no facility under this group
            </div>
            <div v-else>
              <div v-for="facility in currentFacilityGroupFacilities">
                <accordion
                  :expanded="expandedFacility.id"
                  :facility="facility.facility"
                  :statuses="statuses"
                  :facility-group="currentFacilityGroup"
                  @update-expanded="updateExpanded"
                />
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
import FacilityForm from './facilities/facility_form'
import FacilityShow from './facilities/facility_show'
import FacilityGroupBar from './../shared/facility_group_bar'
import Accordion from './../shared/accordion'
import {SweetModal} from 'sweet-modal-vue'
import {mapGetters, mapActions, mapMutations} from 'vuex'
import * as Moment from 'moment'
import {extendMoment} from 'moment-range'
const moment = extendMoment(Moment)

export default {
  name: 'ProjectMapView',
  components: {
    FacilityForm,
    FacilityShow,
    FacilityGroupBar,
    Accordion,
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
  mounted() {
    this.setMapLoading(false)
    this.setSideLoading(false)
  },
  computed: {
    ...mapGetters([
      'mapLoading',
      'sideLoading',
      'facilities',
      'facilityGroups',
      'statuses',
      'currentFacility',
      'currentFacilityGroup',
      'currentProject',
      'filteredFacilityGroups',
      'facilityCount',
      'facilityProgress',
      'filterFacilitiesWithActiveFacilityGroups',
      'unFilterFacilities',
      'filteredFacilities',
      'facilityGroupFacilities'
    ]),
    facilitiesByStatus() {
      return {
        active: this.filteredFacilities('active').length,
        inactive: this.filteredFacilities('inactive').length
      }
    },
    currentFacilityGroupFacilities() {
      if (this.currentFacilityGroup && this.currentFacilityGroup.facilities) {
        var facilityIds = _.map(this.filteredFacilities('active'), 'id')
        return _.filter(this.currentFacilityGroup.facilities, (f => facilityIds.includes(f.facilityId) && f.projectId == this.currentProject.id))
      }
      else {
        return []
      }
    },
    facilitiesByProjectStatus() {
      return _.groupBy(this.filteredFacilities('active'), 'projectStatus')
    },
    currentTasks() {
      return _.flatten(_.map(this.filteredFacilities('active'), 'tasks'))
    },
    currentIssues() {
      return _.flatten(_.map(this.filteredFacilities('active'), 'issues'))
    },
    currentTaskTypes() {
      var types = _.groupBy(this.currentTasks, 'taskType')
      var taskTypes = new Array
      for (var type in types) {
        taskTypes.push(
          {
            name: type,
            length: types[type].length,
            progress: this.completedTasks(type, types[type]).avg
          }
        )
      }
      return taskTypes
    },
    currentIssueTypes() {
      var types = _.groupBy(this.currentIssues, 'issueType')
      var issueTypes = new Array
      for (var type in types) {
        issueTypes.push(
          {
            name: type,
            length: types[type].length,
            progress: Number(_.meanBy(types[type], 'progress').toFixed(2))
          }
        )
      }
      return issueTypes
    },
    completedTasks() {
      return (taskType=null, child=null) => {
        var tasks = child ? child : this.currentTasks
        var completed = _.filter(tasks, (t) => {
          var valid = t && t.progress && t.progress == 100
          if (taskType) valid = valid && t.taskType == taskType
          return valid
        })
        return {
          count: completed.length,
          avg: this.getAverage(completed.length, tasks.length)
        }
      }
    },
    incompletedTasks() {
      var tasks = this.currentTasks
      var incompleted = _.filter(tasks, (t) => t == undefined || t.progress == null || t.progress != 100)
      return {
        count: incompleted.length,
        avg: this.getAverage(incompleted.length, tasks.length)
      }
    },
    knockerStyle() {
      if (this.openSidebar) {
        return {}
      } else {
        return {transform: "translateX(calc(100% - 12px))"}
      }
    },
    rollupStyle() {
      if (this.openSidebar) {
        return {right: '12px'}
      } else {
        return {right: '0'}
      }
    },
    currentFacilityStatus() {
      var status = this.currentFacility && _.map(this.filteredFacilities('active'), 'id').includes(this.currentFacility.id)
      if (!status && this.openSidebar) this.openSidebar = false
      return status
    }
  },
  methods: {
    ...mapActions(['fetchFacilities']),
    ...mapMutations([
      'updateFacilities',
      'setMapLoading',
      'setSideLoading',
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
    editFacility(facility) {
      this.setCurrentFacility(facility)
      this.openSidebar = false
      this.$refs.facilityForm.open()
    },
    updateFacility(facility) {
      this.setCurrentFacility(facility)
      var index = this.facilities.findIndex(f => f.id == facility.id)
      if (index > -1) this.updateFacilities({index, facility})
    },
    updateExpanded(facility) {
      if (facility.id === this.expandedFacility.id) this.expandedFacility = {}
      else this.expandedFacility = facility
    },
    facilityGroupProgress(f_group) {
      var ids = _.map(this.filteredFacilities('active'), 'id')
      var mean = _.meanBy(_.filter(f_group.facilities, (f => ids.includes(f.facilityId) && f.projectId == this.currentProject.id)), 'progress') || 0
      return Number(mean.toFixed(2))
    },
    toggleOpenSideBar() {
      this.openSidebar = this.currentFacility ? !this.openSidebar : false
    },
    getStatusIconLink(facility) {
      return 'http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=|'+ facility.color.split('#')[1]
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
      overflow: auto;
    }
    position: absolute;
    top: 0;
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
    width: 100%;
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
