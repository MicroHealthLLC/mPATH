<template>
  <div id="facility-short-show" class="mt-3">
    <div v-if="!loading">
      <h6 class="text-muted">{{DV_facility.facilityName}}</h6>
      <p class="text-muted">{{DV_facility.region.name}}</p>
      <p class="text-muted">{{DV_facility.email}}</p>
      <div class="row mt-3">
        <div class="col-6">
          <button @click.prevent.stop="$emit('edit-facility', DV_facility)" class="btn btn-sm btn-primary w-100" :disabled="!isCreator">Edit</button>
        </div>
        <div class="col-6">
          <button @click.prevent.stop="$emit('show-facility', DV_facility)" class="btn btn-sm btn-link w-100">Show</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
  import http from './../../../common/http'
  
  export default {
    name: 'FacilityShortShow',
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
    computed: {
      isCreator() {
        return this.DV_facility.creator && this.$currentUser && (this.$currentUser.id === this.DV_facility.creator.id)
      }
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
      }
    }
  }  
</script>

<style lang="scss" scoped>
  #facility-short-show {
    font-size: 12px;
    min-width: 130px;
  }
</style>
