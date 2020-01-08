<template>
  <form id="facilities-form" @submit.prevent="saveFacilitiy" class="mx-auto" accept-charset="UTF-8">
    
    <div class="form-group">
      <input type="text" class="form-control" v-model="DV_facility.facilityName" placeholder="Facility name" />
    </div>

    <div class="form-group">
      <input class="form-control" type="text" placeholder="Address" v-model="DV_facility.address"/>
    </div>

    <div class="form-group">
      <input type="text" class="form-control" placeholder="Point of contact" v-model="DV_facility.pointOfContact" />
    </div>

    <div class="form-group">
      <input type="text" class="form-control" placeholder="Phone number" v-model="DV_facility.phoneNumber" />
    </div>

    <div class="form-group">
      <input type="email" class="form-control" placeholder="Email" v-model="DV_facility.email" />
    </div>
    
    <div class="form-group">
      <textarea class="form-control" placeholder="Description comes here" v-model="DV_facility.notes" rows="5"></textarea>
    </div>

    <div class="clearfix form-group mt-4">
      <button :disabled="!readyToSave" class="btn btn-primary">Save Facility</button>
    </div>

  </form>
</template>

<script>
  import http from './../../../common/http'
  export default {
    name: 'Facilitiesform',
    props: ['facility'],
    data() {
      return {
        DV_facility: {
          facilityName: '',
          address: '',
          pointOfContact: '',
          phoneNumber: '',
          email: '',
          notes: ''
        }
      }
    },
    mounted() {
      if (this.facility) this.DV_facility = this.facility
    },
    methods: {
      saveFacilitiy() {
        var data = {facility: this.DV_facility}
        if (this.facility && this.facility.id) {
          http.put(`/facilities/${this.facility.id}.json`, data)
            .then((res) => {
              this.$emit('facility-update', res.data.facility);
            })
            .catch((err) => {
              console.error(err)
            })
        }
        else {
          http.post('/facilities.json', data)
            .then((res) => {
              this.$emit('callback', res.data.facility);
            })
            .catch((err) => {
              console.error(err)
            })
        }
      }
    },
    computed: {
      readyToSave() {
        return (
          this.DV_facility && 
          this.DV_facility.facilityName.trim() !== ''
        );
      }
    }
  }  
</script>

<style lang="scss" scoped>
</style>
