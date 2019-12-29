<template>
  <form id="facilities-form" @submit.prevent="saveFacilitiy" class="mx-auto" accept-charset="UTF-8">
    
    <div class="form-group">
      <label>Facility Name</label>
      <input type="text" class="form-control" v-model="DV_facility.facilityName" placeholder="Facility name" />
    </div>

    <div class="form-group">
      <label>Address</label>
      <input class="form-control" type="text" placeholder="Address" v-model="DV_facility.address"/>
    </div>

    <div class="form-group">
      <label>Point of Contact</label>
      <input type="text" class="form-control" placeholder="Point of contact" v-model="DV_facility.pointOfContact" />
    </div>

    <div class="form-group">
      <label>Phone Number</label>
      <input type="text" class="form-control" placeholder="Phone number" v-model="DV_facility.phoneNumber" />
    </div>

    <div class="form-group">
      <label>Email</label>
      <input type="email" class="form-control" placeholder="Email" v-model="DV_facility.email" />
    </div>
    
    <div class="form-group">
      <label>Notes</label>
      <textarea class="form-control" placeholder="briefly describe here.." v-model="DV_facility.notes" rows="3"></textarea>
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
        const VM = this
        var data = {facility: VM.DV_facility}
        
        if (VM.facility && VM.facility.id) {
          http
            .put(`/facilities/${VM.facility.id}.json`, data)
            .then((res) => {
              VM.$emit('callback', res.data.facility);
            })
            .catch((err) => {
              console.error(err)
            })
        }
        else {
          http
            .post('/facilities.json', data)
            .then((res) => {
              VM.$emit('callback', res.data.facility);
            })
            .catch((err) => {
              console.error(err)
            })
        }
      }
    },
    computed: {
      readyToSave() {
        // for check required name for now
        return (
          this.DV_facility && 
          this.DV_facility.facilityName.trim() !== ''
        );
      }
    }
  }  
</script>

<style lang="scss" scoped>
  #facilities-form {
    padding: 10px 20px;
  }
</style>
