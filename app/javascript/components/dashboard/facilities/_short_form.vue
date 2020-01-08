<template>
  <form id="facilities-short-form" @submit.prevent="saveFacilitiy" class="pt-3 mx-auto" accept-charset="UTF-8">
    <div class="form-group">
      <input type="text" class="form-control form-control-sm" v-model="DV_facility.facilityName" placeholder="Facility name" />

      <input type="text" class="mt-2 form-control form-control-sm" placeholder="Phone number" v-model="DV_facility.phoneNumber" />
      
      <input type="email" class="mt-2 form-control form-control-sm" placeholder="Email" v-model="DV_facility.email" />
    </div>
    <div class="clearfix form-group mt-3">
      <button :disabled="!readyToSave" class="btn float-right btn-sm btn-primary">Save</button>
    </div>
  </form>
</template>

<script>
  import http from './../../../common/http'
  export default {
    name: 'FacilitiesShortform',
    props: ['marker', 'markerKey'],
    
    data() {
      return {
        DV_facility: {
          facilityName: '',
          address: '',
          pointOfContact: '',
          phoneNumber: '',
          email: '',
          regionId: null,
          latlng: '',
          notes: ''
        }
      }
    },
    mounted() {
      this.setLatLng();
    },
    methods: {
      saveFacilitiy() {
        http
          .post('/facilities.json', {facility: this.DV_facility})
          .then((res) => {
            this.$emit('facility-callback', {facility: res.data.facility, markerKey: this.markerKey});
            console.log("new facility added");
          })
          .catch((err) => {
            this.$emit('facility-callback', {facility: null, markerKey: this.markerKey});
            console.error(err)
          })
      },
      setLatLng() {
        this.DV_facility.latlng = this.marker.latlng['lat'] +" "+ this.marker.latlng['lng']
        this.DV_facility.regionId = this.marker.region ? this.marker.region.id : 1
      }
    },
    computed: {
      readyToSave() {
        return (
          this.DV_facility && 
          this.DV_facility.latlng.trim() !== '' &&
          this.DV_facility.facilityName.trim() !== ''
        );
      }
    }
  }  
</script>

<style lang="scss" scoped>
  #facilities-short-form {
    font-size: 12px;
    min-width: 200px;
  }
</style>
