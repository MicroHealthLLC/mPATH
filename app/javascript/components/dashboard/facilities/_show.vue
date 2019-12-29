<template>
  <div id="facility-show">
    <div class="mt-3" v-if="!loading">
      <div class="f-edit-facility">
        <h2>{{DV_facility.facilityName}}</h2>
        <div class="d-flex">
          <i @click.stop="editFacility" class="material-icons mr-2 icon-btn">edit</i>
          <i @click.stop="deleteFacility" class="material-icons ml-2 icon-btn">delete</i>
        </div>
      </div>

      <div>Region: {{DV_facility.region.name}}</div>
      <div>Address: {{DV_facility.address}}</div>
      <div>Point of Contact: {{DV_facility.pointOfContact}}</div> 
      <div>Phone Number: {{DV_facility.phoneNumber}}</div> 
      <div>Email: {{DV_facility.email}}</div> 
      <div>Notes: {{DV_facility.notes}}</div> 
    </div>
  </div>
</template>

<script>
  import http         from './../../../common/http'
  import CustomModal  from './../../shared/custom_modal.vue'
  import FacilityForm from './_form.vue'
  
  export default {
    name: 'FacilitiesShow',
    props: ['facility'],
    components: {
      FacilityForm,
      CustomModal
    },
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
        this.$modal.show('edit-facility-form')
      },
      facilityFormCb(facility) {
        this.$modal.hide('edit-facility-form')
        this.loading = true
        this.DV_facility = facility
      },
      deleteFacility() {
        http
          .delete(`/facilities/${this.DV_facility.id}.json`)
          .then((res) => {
            this.loading = false;
            this.$emit('back');
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
  #facility-show {
    .f-edit-facility {
      justify-content: space-between;
    }
    .f-edit-facility,
    .back-btn {
      display: flex;
      i {
        display: flex;
        border-radius: 50%;
        padding: 5px;
        align-items: center;
      }
    }
  }
</style>
