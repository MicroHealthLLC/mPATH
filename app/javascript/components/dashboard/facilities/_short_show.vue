<template>
  <div id="facility-short-show">
    <div v-if="!loading">
      <h6 class="text-muted">{{DV_facility.facilityName}}</h6>
      <p class="text-muted">{{DV_facility.region.name}}</p>
      <p class="text-muted">{{DV_facility.email}}</p>
      <div class="row mt-3">
        <button class="col btn float-right btn-sm btn-primary">Edit</button>
        <button @click.prevent.stop="$emit('show-facility', facility)" class="col btn float-right btn-sm btn-link">Show</button>
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
    min-width: 100px;
  }
</style>
