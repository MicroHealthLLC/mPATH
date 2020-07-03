<template>
  <div id="facility-show">
    <div v-if="!loading">
      <div class="d-flex align-items-center my-2">
        <span class="fbody-icon"><i class="fas fa-check"></i></span>
        <h4 class="text-secondary f-head">{{DV_facility.facilityName}}</h4>
      </div>
      <tabs>
        <tab title="Overview" key="overview">
          <div>
            <h3 v-if="extras" class="text-center">Facility Summary</h3>
            <div class="f-body mt-3 p-2">
              <p class="mt-2">
                <span class="fbody-icon"><i class="fas fa-globe"></i></span>
                <span>{{region.name}}</span>
              </p>
              <div>
                <p class="mt-2 d-flex align-items-center">
                  <span class="fbody-icon"><i class="fas fa-info-circle"></i></span>
                  <select class="form-control form-control-sm" v-model="DV_facility.statusId" @change="onChange" :disabled="!_isallowed">
                    <option :value="null">No Status</option>
                    <option v-for="status in statuses" :value="status.id">
                      {{status.name}}
                    </option>
                  </select>
                </p>
                <p class="mt-2 d-flex align-items-center">
                  <span class="fbody-icon"><i class="fas fa-calendar-alt"></i></span>
                  <date-picker
                    input-class="form-control form-control-sm"
                    :clear-button="true"
                    v-model="DV_facility.dueDate"
                    @input="onChange"
                    placeholder="Due date"
                    :disabled="!_isallowed || !DV_facility.statusId"
                  />
                </p>
                <p v-if="!DV_facility.statusId && _isallowed" class="ml-4 text-danger">Status must be updated before you can enter a Due Date</p>
              </div>
              <p class="mt-2 d-flex align-items-center">
                <span class="fbody-icon"><i class="fas fa-spinner"></i></span>
                <span class="w-100 progress pg-content" :class="{ 'progress-0': DV_facility.progress <= 0 }">
                  <div class="progress-bar bg-info" :style="`width: ${DV_facility.progress}%`">{{DV_facility.progress}}%</div>
                </span>
              </p>
              <div v-if="taskStats.length > 0">
                <hr>
                <p>
                  <div class="row my-2" v-for="task in taskStats">
                    <div class="col-md-9 font-md">
                      <span>{{task.name}}</span>
                      <span class="badge badge-secondary badge-pill">{{task.count}}</span>
                    </div>
                    <div class="col-md-3 d-flex align-items-center">
                      <span class="w-100 progress pg-content" :class="{ 'progress-0': task.progress <= 0 }">
                        <div class="progress-bar bg-info" :style="`width: ${task.progress}%`">{{task.progress}} %</div>
                      </span>
                    </div>
                  </div>
                </p>
                <hr>
              </div>
              <p class="mt-2">
                <span class="fbody-icon"><i class="fas fa-map-marker"></i></span>
                <span>{{DV_facility.address || 'N/A'}}</span>
              </p>
              <p class="mt-2">
                <span class="fbody-icon"><i class="far fa-id-badge"></i></span>
                <span>{{DV_facility.pointOfContact || 'N/A'}}</span>
              </p>
              <p class="mt-2">
                <span class="fbody-icon"><i class="fas fa-phone"></i></span>
                <span>{{DV_facility.phoneNumber || 'N/A'}}</span>
              </p>
              <p class="mt-2">
                <span class="fbody-icon"><i class="far fa-envelope"></i></span>
                <span>{{DV_facility.email || 'N/A'}}</span>
              </p>
              <button class="mt-2 btn btn-success btn-sm" @click="updateFacility" :disabled="!DV_updated">Save</button>
            </div>
          </div>
        </tab>
        <tab title="Notes" key="notes">
          <div>
            <notes-index
              :facility="DV_facility"
              @refresh-facility="refreshFacility"
            />
          </div>
        </tab>
        <tab title="Tasks" key="tasks">
          <div>
            <detail-show
              :facility="DV_facility"
              @refresh-facility="refreshFacility"
            />
          </div>
        </tab>
        <tab title="Issues" key="issues">
          <issue-index
            :facility="DV_facility"
            @refresh-facility="refreshFacility"
          />
        </tab>
      </tabs>
    </div>
  </div>
</template>

<script>
  import http from './../../../common/http'
  import NotesIndex from './../notes/notes_index'
  import IssueIndex from './../issues/issue_index'
  import DetailShow from './../projects/project_show'

  export default {
    name: 'FacilitiesShow',
    components: {DetailShow, NotesIndex, IssueIndex},
    props: {
      facility: {
        default: null,
        type: Object
      },
      region: {
        default: null,
        type: Object
      },
      statuses: {
        default: () => [],
        type: Array
      },
      extras: {
        default: true,
        type: Boolean
      }
    },
    data() {
      return {
        loading: true,
        DV_updated: false,
        newNote: false,
        notesQuery: '',
        DV_facility: Object.assign({}, this.facility)
      }
    },
    mounted() {
      this.fetchFacility()
    },
    methods: {
      fetchFacility(opt={}) {
        http
          .get(`/projects/${this.$route.params.projectId}/facilities/${this.DV_facility.id}.json`)
          .then((res) => {
            this.DV_facility = {...res.data.facility, ...res.data.facility.facility}
            if (opt.cb) this.$emit('facility-update', this.DV_facility)
            this.loading = false;
          })
          .catch((err) => {
            this.loading = false;
            console.error(err);
          })
      },
      updateFacility(e) {
        if (e.target) e.target.blur()
        if (!this._isallowed || !this.DV_updated) return
        this.DV_updated = false
        var data = {facility: {statusId: this.DV_facility.statusId, dueDate: this.DV_facility.dueDate}}
        http
          .put(`/projects/${this.$route.params.projectId}/facilities/${this.DV_facility.id}.json`, data)
          .then((res) => {
            this.DV_facility = {...res.data.facility, ...res.data.facility.facility}
            this.$emit('facility-update', this.DV_facility)
          })
          .catch((err) => {
            console.error(err);
          })
      },
      deleteFacility() {
        var confirm = window.confirm(`Are you sure, you want to delete ${this.DV_facility.facilityName}?`)
        if (!confirm) return;

        http
          .delete(`/projects/${this.$route.params.projectId}/facilities/${this.DV_facility.id}.json`)
          .then((res) => {
            this.loading = false;
            this.$emit('back-after-delete', this.DV_facility);
          })
          .catch((err) => {
            this.loading = false;
            console.error(err);
          })
      },
      refreshFacility() {
        this.loading = true
        this.fetchFacility({cb: true})
      },
      noteCreated(note) {
        this.newNote = false
        this.DV_facility.notes.unshift(note)
      },
      noteUpdated(note) {
        var index = this.DV_facility.notes.findIndex(n=> n.id == note.id)
        if (index > -1) {
          this.DV_facility.notes[index] = note
        }
        this.$forceUpdate()
      },
      noteDeleted(note) {
        _.remove(this.DV_facility.notes, (n) => n.id == note.id)
        this.$forceUpdate()
      },
      isBlockedStatus(status) {
        return status && status.name.toLowerCase().includes('complete') && this.DV_facility.progress < 100
      },
      onChange() {
        this.$nextTick(() => {
          this.DV_updated = true
        })
      }
    },
    computed: {
      filteredNotes() {
        if (this.notesQuery.trim() !== '') {
          const resp = new RegExp(_.escapeRegExp(this.notesQuery.trim().toLowerCase()), 'i')
          const isMatch = (result) => resp.test(result.body)
          return _.filter(this.DV_facility.notes, isMatch)
        }
        return this.DV_facility.notes;
      },
      taskStats() {
        var tasks = new Array
        var group = _.groupBy(this.DV_facility.tasks, 'taskType')
        for (var type in group) {
          tasks.push({
            name: type,
            count: group[type].length,
            progress: (_.meanBy(group[type], 'progress') || 0).toFixed(2)
          })
        }
        return tasks
      },
      _isallowed() {
        return ["admin", "subscriber"].includes(this.$currentUser.role)
      }
    },
    watch: {
      facility: {
        handler: function(value) {
          this.DV_facility = Object.assign({}, value)
          this.DV_updated = false
          this.loading = true
          this.fetchFacility()
        },
        deep: true
      },
      "DV_facility.statusId"(value) {
        if (value === null) {
          this.DV_facility.dueDate = null
        }
      }
    }
  }
</script>

<style lang="scss" scoped>
  .f-head {
    word-break: break-word;
    text-overflow: ellipsis;
  }
  .f-notes {
    border: 1px solid #ccc;
    padding: 5px 10px;
    border-radius: 5px;
    overflow: auto;
    min-height: 20vh;
    max-height: 34vh;
  }
  .f-show-btn {
    font-size: 12px;
    font-style: italic;
    display: flex;
    flex-direction: row-reverse;
  }
  .progress-0 {
    .progress-bar {
      margin-left: 1vw;
      color: #6c757d !important;
    }
  }
  .pg-content {
    width: 100%;
    height: 20px;
    font-size: 14px;
    font-weight: bold;
  }
  .vue-tabs {
    margin-top: 15px;
  }
  .vdp-datepicker {
    width: 100%;
  }
  .search-tab {
    width: 80%;
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
</style>
