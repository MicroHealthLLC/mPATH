<template>
  <div id="facility-show">
    <div v-if="!loading">
      <tabs>
        <tab title="Overview" key="overview">
          <div>
            <h3 v-if="extras" class="text-center">Facility Summary</h3>
            <div class="f-body mt-3 p-2">
              <div class="d-flex">
                <span class="fbody-icon"><i class="fas fa-check"></i></span>
                <h4 class="text-secondary f-head">{{DV_facility.facilityName}}</h4>
              </div>
              <p class="mt-2">
                <span class="fbody-icon"><i class="fas fa-globe"></i></span>
                <span>{{region.name}}</span>
              </p>
              <p class="mt-2 d-flex align-items-center">
                <span class="fbody-icon"><i class="fas fa-info-circle"></i></span>
                <select class="form-control form-control-sm" v-model="DV_facility.statusId" @change.stop="updateFacilityStatus">
                  <option :value="null">No Status</option>
                  <option v-for="status in statuses" :value="status.id">
                    {{status.name}}
                  </option>
                </select>
              </p>
              <p class="mt-2 d-flex align-items-center">
                <span class="fbody-icon"><i class="fas fa-spinner"></i></span>
                <span class="w-100 progress pg-content" :class="{ 'progress-0': DV_facility.progress <= 0 }">
                  <div class="progress-bar bg-info" :style="`width: ${DV_facility.progress}%`">{{DV_facility.progress}}%</div>
                </span>
              </p>
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
            </div>
          </div>
        </tab>
        <tab title="Notes" key="notes">
          <div>
            <p class="text-muted" v-if="DV_facility.notes.length <= 0">No notes present, try adding new</p>
            <div v-if="newNote" class="mb-3">
              <notes-form
                :facility="DV_facility"
                @close-note-input="newNote = false"
                @note-created="noteCreated"
              />
            </div>
            <div v-else class="mb-3">
              <button @click.stop="newNote = true" class="btn badge badge-pill badge-secondary">Add Note</button>
            </div>
            <div v-for="note in DV_facility.notes">
              <notes-show
                :facility="DV_facility"
                :note="note"
                @note-updated="noteUpdated"
                @note-deleted="noteDeleted"
              />
            </div>
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
      </tabs>
    </div>
  </div>
</template>

<script>
  import http from './../../../common/http'
  import NotesForm from './../notes/notes_form'
  import NotesShow from './../notes/notes_show'
  import DetailShow from './facility_detail_show'

  export default {
    name: 'FacilitiesShow',
    components: { DetailShow, NotesForm, NotesShow },
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
        newNote: false,
        DV_facility: this.facility
      }
    },
    mounted() {
      if (this.extras) {
        this.fetchFacility()
      }
      else {
        this.loading = false
      }
    },
    methods: {
      fetchFacility() {
        http
          .get(`/projects/${this.$route.params.projectId}/facilities/${this.DV_facility.id}.json`)
          .then((res) => {
            this.DV_facility = res.data.facility;
            this.loading = false;
          })
          .catch((err) => {
            this.loading = false;
            console.error(err);
          })
      },
      updateFacilityStatus() {
        http
          .put(`/projects/${this.$route.params.projectId}/facilities/${this.DV_facility.id}.json`, {facility: {statusId: this.DV_facility.statusId}})
          .then((res) => {
            this.DV_facility = res.data.facility;
          })
          .catch((err) => {
            console.error(err);
          })
      },
      editFacility() {
        this.$emit('edit-facility', this.DV_facility);
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
        this.fetchFacility()
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
      }
    },
    watch: {
      facility: {
        handler: function(value) {
          this.DV_facility = value
        },
        deep: true
      }
    }
  }
</script>

<style lang="scss" scoped>
  .f-head {
    word-break: break-all;
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
</style>
