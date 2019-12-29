<template>
  <form id="facilities-short-form" @submit.prevent="saveFacilitiy" class="mx-auto" accept-charset="UTF-8">
    <div class="form-group">
      <label>Facility Name</label>
      <input type="text" class="form-control form-control-sm" v-model="DV_facility.facilityName" placeholder="Facility name" />
      
      <label class="mt-2">Phone Number</label>
      <input type="text" class="form-control form-control-sm" placeholder="Phone number" v-model="DV_facility.phoneNumber" />

      <label class="mt-2">Email</label>
      <input type="email" class="form-control form-control-sm" placeholder="Email" v-model="DV_facility.email" />
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
        this.DV_facility.regionId = 1 //this.marker.region.id
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
