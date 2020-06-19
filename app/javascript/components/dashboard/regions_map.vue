<template>
  <div class="row m-0 mw-100">
    <div v-if="!loading" id="map-wrap" class="col-8 p-0">
      <div class="regions-bar">
        <region-bar
          :regions="filteredRegions"
          :facilities="facilities"
          :current-project="currentProject"
          @goto-region="gotoRegion"
        />
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
            v-for="(facility, index) in filterFacilitiesWithActiveRegion"
            :position="getLatLngForFacility(facility)"
            @click="showFacility(facility)"
            :icon="{url: getStatusIconLink(facility)}"
          />
        </GmapCluster>
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
                <div v-for="(_f, s) in facilitiesByStatus">
                  <span> {{s.replace('null', 'No Status')}}</span>
                  <span class="badge badge-secondary badge-pill">{{_f.length}}</span>
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
                      <span class="w-100 progress pg-content" :class="{ 'progress-0': getAverage(_f.length, filteredFacilities.length) <= 0 }">
                        <div class="progress-bar bg-info" :style="`width: ${getAverage(_f.length, filteredFacilities.length)}%`">{{getAverage(_f.length, filteredFacilities.length)}} %</div>
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
              <div v-for="(_task, s) in currentTaskTypes">
                <div class="row">
                  <div class="col-md-9">
                    <span> {{s.replace('null', 'N/A')}}</span>
                    <span class="badge badge-secondary badge-pill">{{_task.length}}</span>
                  </div>
                  <div class="col-md-3 d-flex align-items-center">
                    <span class="w-100 progress pg-content" :class="{ 'progress-0': completedTasks(s, _task).avg <= 0 }">
                      <div class="progress-bar bg-info" :style="`width: ${completedTasks(s, _task).avg}%`">{{completedTasks(s, _task).avg}} %</div>
                    </span>
                  </div>
                </div>
              </div>
            </div>
            <hr>
            <div class="my-1">
              <h5 class="text-center">{{currentIssues.length}} Issues</h5>
              <div v-for="(_issue, s) in currentIssueTypes">
                <div class="row">
                  <div class="col-md-9">
                    <span> {{s.replace('null', 'N/A')}}</span>
                    <span class="badge badge-secondary badge-pill">{{_issue.length}}</span>
                  </div>
                  <div class="col-md-3 d-flex align-items-center">
                    <span class="w-100 progress pg-content" :class="{ 'progress-0': getAverage(_issue.length, currentIssues.length) <= 0 }">
                      <div class="progress-bar bg-info" :style="`width: ${getAverage(_issue.length, currentIssues.length)}%`">{{getAverage(_issue.length, currentIssues.length)}} %</div>
                    </span>
                  </div>
                </div>
              </div>
            </div>
            <hr>
            <div>
              <h5 class="text-center">Facility Groups</h5>
              <div class="row my-2" v-for="region in filteredRegions">
                <div class="col-md-9 font-md">
                  <span class="badge badge-pill" :class="{ 'badge-success':
                    region.status == 'active', 'badge-danger': region.status == 'inactive' }">
                    {{region.status}}
                  </span>
                  <span>{{region.name}}</span>
                  <span class="badge badge-secondary badge-pill">{{facilityGroupFacilities(region).length}}</span>
                </div>
                <div class="col-md-3 d-flex align-items-center">
                  <span class="w-100 progress pg-content" :class="{ 'progress-0': facilityGroupProgress(region) <= 0 }">
                    <div class="progress-bar bg-info" :style="`width: ${facilityGroupProgress(region)}%`">{{facilityGroupProgress(region)}} %</div>
                  </span>
                </div>
              </div>
            </div>
          </div>
          <div class="knocker_side" :style="knockerStyle">
            <div v-if="currentFacility" class="knocker" @click="toggleOpenSideBar">
              <div class="linner"></div>
            </div>
            <div id="map-sidebar" class="shadow-sm">
              <facility-show
                v-if="currentFacility"
                :facility="currentFacility"
                :region="currentRegion"
                :statuses="statuses"
                @close-side-bar="closeSidebar"
                @back-after-delete="backFromFacilityShow"
                @edit-facility="editFacility"
                @facility-update="updateFacility"
              />
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
        <h3 class="mb-3 text-break">{{currentRegion.name}} <span class="badge badge-secondary badge-pill">{{currentRegionFacilities.length}}</span></h3>
        <div v-if="currentRegionFacilities && currentRegionFacilities.length == 0" class="mt-3 text-danger">
          There is no facility under this group
        </div>
        <div v-else>
          <div v-for="facility in currentRegionFacilities">
            <accordion
              :expanded="expandedFacility.id"
              :facility="facility.facility"
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
import {SweetModal}      from 'sweet-modal-vue'
import * as Moment       from 'moment'
import {extendMoment}    from 'moment-range'
const moment = extendMoment(Moment)

export default {
  name: 'RegionsMap',
  mixins: [ utils ],
  props: ['withFacility', 'projects', 'statuses', 'status', 'facilityGroups', 'facilityGroup', 'facilityQuery', 'filterFacility', 'dueDate', 'taskType', 'taskProgress', 'progress', 'issueType', 'issueProgress', 'issueSeverity'],
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
      sideLoading: true,
      center: {lat: 40.64, lng: -74.66},
      zoom: 3,
      currentRegion: null,
      currentProject: null,
      facilities: [],
      filters: [],
      regions: [],
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
      return this.filteredFacilities.length
    },
    facilityProgress() {
      var mean = _.meanBy(this.filteredFacilities, 'progress') || 0
      return mean.toFixed(2)
    },
    filterFacilitiesWithActiveRegion() {
      var activeRegions = _.map(_.filter(this.regions, (r) => r.status === 'active'), 'id')
      return _.filter(this.filteredFacilities, (facility) => {
        return activeRegions.includes(facility.facilityGroupId) && facility.status === 'active'
      })
    },
    filteredFacilities() {
      return _.filter(this.facilities, (facility) => {
        var valid = true
        _.each(this.filters, (f) => {
          var k = Object.keys(f)[0]
          switch(k) {
            case "dueDate": {
              var range = moment.range(f[k][0], f[k][1])
              valid = valid && range.contains(new Date(facility[k]))
              break
            }
            case "progress": {
              var range = f[k].value.split("-").map(Number)
              valid = valid && (range[1] !== undefined ? range[0] <= facility[k] && range[1] >= facility[k] : facility[k] == range[0])
              break
            }
            case "taskTypeId": {
              var ids = _.map(facility.tasks, 'taskTypeId')
              valid = valid && ids.includes(f[k])
              break
            }
            case "issueTypeId": {
              var ids = _.map(facility.issues, 'issueTypeId')
              valid = valid && ids.includes(f[k])
              break
            }
            case "issueProgress":
            case "taskProgress": {
              var progressFor = k === 'taskProgress' ? facility.tasks : facility.issues
              var progress = _.uniq(_.map(progressFor, 'progress'))
              var range = f[k].value.split("-").map(Number)
              var size = range[1] ? (range[1] - range[0]) + 1 : 1
              var ranges = Array.from(Array(size), (_, i) => i + range[0])
              valid = valid && _.intersection(progress, ranges).length > 0
              break
            }
            case "issueSeverityId": {
              var ids = _.map(facility.issues, 'issueSeverityId')
              valid = valid && ids.includes(f[k])
              break
            }
            default: {
              valid = valid && facility[k] == f[k]
              break
            }
          }
        })
        return valid
      })
    },
    facilitiesByStatus() {
      return _.groupBy(this.filteredFacilities, 'status')
    },
    currentRegionFacilities() {
      if (this.currentRegion && this.currentRegion.facilities) {
        var facilityIds = _.map(this.filteredFacilities, 'id')
        return _.filter(this.currentRegion.facilities, (f => facilityIds.includes(f.facilityId) && f.projectId == this.currentProject.id))
      }
      else {
        return []
      }
    },
    filteredRegions() {
      var facilityGroupIds = _.map(this.filteredFacilities, 'facilityGroupId')
      return _.filter(this.regions, (r => facilityGroupIds.includes(r.id)))
    },
    facilitiesByProjectStatus() {
      return _.groupBy(this.filteredFacilities, 'projectStatus')
    },
    currentTasks() {
      return _.flatten(_.map(this.filteredFacilities, 'tasks'))
    },
    currentIssues() {
      return _.flatten(_.map(this.filteredFacilities, 'issues'))
    },
    currentTaskTypes() {
      return _.groupBy(this.currentTasks, 'taskType')
    },
    currentIssueTypes() {
      return _.groupBy(this.currentIssues, 'issueType')
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
    }
  },
  methods: {
    fetchFacilities() {
      http
        .get(`/projects/${this.$route.params.projectId}/facilities.json`)
        .then((res) => {
          for (var facility of res.data.facilities) {
            this.facilities.push({...facility, ...facility.facility})
          }
          this.currentProject = res.data.project
          this.fetchFacilityGroups()
        })
        .catch((err) => {
          this.loading = false;
          this.sideLoading = false;
          console.error(err);
        })
    },
    fetchFacilityGroups() {
      http
        .get(`/api/facility_groups.json?=project_id=${this.currentProject.id}`)
        .then((res) => {
          this.regions = res.data.facilityGroups
        })
        .catch((err) => {
          console.error(err);
        })
        .finally(() => {
          this.loading = false;
          this.sideLoading = false;
        })
    },
    getLatLngForFacility(facility) {
      return L.latLng(Number(facility.lat), Number(facility.lng))
    },
    showFacility(facility) {
      this.openSidebar = true
      this.currentRegion = this.regions.find(region => region.id == facility.facilityGroupId)
      this.center = this.getLatLngForFacility(facility)
      // this.zoom = 17
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
      var facilityIds = _.map(this.filteredFacilities, 'id')
      var mean = _.meanBy(_.filter(f_group.facilities, (f => facilityIds.includes(f.facilityId) && f.projectId == this.currentProject.id)), 'progress') || 0
      return mean.toFixed(2)
    },
    facilityGroupFacilities(f_group) {
      var facilityIds = _.map(this.filteredFacilities, 'id')
      return _.filter(f_group.facilities, (f => facilityIds.includes(f.facilityId) && f.projectId === this.currentProject.id))
    },
    toggleOpenSideBar() {
      if (this.currentFacility) {
        this.openSidebar= !this.openSidebar
      } else {
        this.openSidebar = false
      }
    },
    getStatusIconLink(facility) {
      return 'http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=|'+ facility.color.split('#')[1]
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
    taskType: {
      handler: function(value) {
        if (value) {
          if (value.id === 'sa') {
            this.filters = _.filter(this.filters, (f) => !f.hasOwnProperty('taskTypeId'))
          }
          else {
            this.filters.push({taskTypeId: value.id})
          }
        }
      }, deep: true
    },
    dueDate: {
      handler: function(value) {
        if (value) {
          if (value.includes(null)) {
            this.filters = _.filter(this.filters, (f) => !f.hasOwnProperty('dueDate'))
          }
          else {
            this.filters.push({dueDate: value})
          }
        }
      }, deep: true
    },
    progress: {
      handler: function(value) {
        if (value) {
          if (value.id === 'sa') {
            this.filters = _.filter(this.filters, (f) => !f.hasOwnProperty('progress'))
          }
          else {
            this.filters.push({progress: value})
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
          const resp    = new RegExp(_.escapeRegExp(q.toLowerCase()), 'i')
          const isMatch = (result) => resp.test(result.facilityName)
          var filtered = _.filter(this.filteredFacilities, isMatch)
          return cb(filtered)
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
    },
    issueType: {
      handler: function(value) {
        if (value) {
          if (value.id === 'sa') {
            this.filters = _.filter(this.filters, (f) => !f.hasOwnProperty('issueTypeId'))
          }
          else {
            this.filters.push({issueTypeId: value.id})
          }
        }
      }, deep: true
    },
    issueProgress: {
      handler: function(value) {
        if (value) {
          if (value.id === 'sa') {
            this.filters = _.filter(this.filters, (f) => !f.hasOwnProperty('issueProgress'))
          }
          else {
            this.filters.push({issueProgress: value})
          }
        }
      }, deep: true
    },
    taskProgress: {
      handler: function(value) {
        if (value) {
          if (value.id === 'sa') {
            this.filters = _.filter(this.filters, (f) => !f.hasOwnProperty('taskProgress'))
          }
          else {
            this.filters.push({taskProgress: value})
          }
        }
      }, deep: true
    },
    issueSeverity: {
      handler: function(value) {
        if (value) {
          if (value.id === 'sa') {
            this.filters = _.filter(this.filters, (f) => !f.hasOwnProperty('issueSeverityId'))
          }
          else {
            this.filters.push({issueSeverityId: value.id})
          }
        }
      }, deep: true
    },
    openSidebar(value) {
      if (!value && !this.loading) {
        // this.sideLoading = true
        this.facilities = []
        this.fetchFacilities()
      }
    }
  }
}
</script>

<style scoped lang="scss">
  #map-wrap {
    height: calc(100vh - 60px);
    width: 69vw;
  }
  #rollup-sidebar {
    > div {
      height: calc(100vh - 60px);
      overflow: auto;
    }
    position: absolute;
    top: 0;
  }
  #map-sidebar {
    z-index: 800;
    height: calc(100vh - 60px);
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
  .__loading {
    margin-top: 125px;
    margin-left: -20px;
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
    background: #37AFEA;
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
</style>
