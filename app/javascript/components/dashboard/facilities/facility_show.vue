<template>
  <div id="facility-show">
    <div v-if="!loading">
      <div v-if="!showMore">
        <div v-if="$currentUser.role == 'admin'" class="crud-actions mx-3">
          <span class="mr-3 edit-action" @click.stop="editFacility">
            <i class="fas fa-edit"></i>
          </span>
          <span class="delete-action" @click.stop="deleteFacility">
            <i class="fas fa-trash-alt"></i>
          </span>
        </div>
        <h3 class="text-center">Facility Summary</h3>
        <div class="f-body mt-3 p-2">
          <div class="d-flex">
            <span class="fbody-icon"><i class="fas fa-check"></i></span>
            <h4 class="text-secondary f-head">{{DV_facility.facilityName}}</h4>
          </div>

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
          <div class="mt-2">
            <span class="font-italic text-secondary">Notes:</span>
            <p class="mt-1 f-notes text-muted">
              {{DV_facility.notes || 'N/A'}}
            </p>
          </div>
          <a href="javascript:;" @click.prevent.stop="showMoreTab" class="btn btn-link float-right f-show-btn">show more..</a>
        </div>
      </div>
      <div v-if="showMore">
        <detail-show
          :facility="DV_facility"
          @show-less="showLessTab"
          @refresh-facility="refreshFacility"
        />
      </div>
    </div>
  </div>
</template>

<script>
  import http from './../../../common/http'
  import DetailShow from './facility_detail_show'

  export default {
    name: 'FacilitiesShow',
    components: { DetailShow },
    props: ['facility'],
    data() {
      return {
        loading: true,
        showMore: false,
        DV_facility: this.facility
      }
    },
    mounted() {
      this.fetchFacility()
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
      showMoreTab() {
        this.showMore = true
      },
      showLessTab() {
        this.showMore = false
      },
      refreshFacility() {
        this.loading = true
        this.showMore = true
        this.fetchFacility()
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
</style>
