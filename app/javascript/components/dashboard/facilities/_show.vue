<template>
  <div id="facility-show">
    <div v-if="!loading">
      <div v-if="DV_facility.creator && $currentUser.id === DV_facility.creator.id" class="f-actions mx-3">
        <span class="mr-3 edit-action" @click.stop="editFacility">
          <i class="fas fa-edit"></i>
        </span>
        <span class="delete-action" @click.stop="deleteFacility">
          <i class="fas fa-trash-alt"></i>
        </span>
      </div>
      <div class="f-body mt-3 p-2">
        <h4 class="text-secondary">{{DV_facility.facilityName}}</h4>
        <p class="mt-2">
          <span class="fbody-icon"><i class="fas fa-globe"></i></span>
          <span>{{DV_facility.region.name}}</span>
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
          <div class="mt-1 f-notes text-muted">
            {{DV_facility.notes || 'N/A'}}
          </div>
        </div> 
      </div> 
    </div>
  </div>
</template>

<script>
  import http from './../../../common/http'
  
  export default {
    name: 'FacilitiesShow',
    props: ['facility'],
    data() {
      return {
        loading: true,
        DV_facility: this.facility
      }
    },
    mounted() {
      this.fetchFacility()
    },
    methods: {
      fetchFacility() {
        http
          .get(`/facilities/${this.DV_facility.id}.json`)
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
        http
          .delete(`/facilities/${this.DV_facility.id}.json`)
          .then((res) => {
            this.loading = false;
            this.$emit('back-after-delete', this.DV_facility);
          })
          .catch((err) => {
            this.loading = false;
            console.error(err);
          })
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
  #facility-show {
    .f-actions {
      display: flex;
      justify-content: flex-end;
      color: gray;
      span {
        cursor: pointer;
      }
    }
  }
  .fbody-icon {
    font-size: 16px;
    color: gray;
    margin-right: 10px;
  }
  .delete-action:hover {
    color: red;
  }
  .edit-action:hover {
    color: blue;
  }
  .f-notes {
    border: 1px solid #ccc;
    padding: 5px;
    overflow-y: auto;
    min-height: 20vh;
    max-height: 34vh;
  }
</style>
