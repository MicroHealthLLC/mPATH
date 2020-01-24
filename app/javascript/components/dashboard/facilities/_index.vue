<template>
  <div>
    <div v-if="cuurentFacility">
      <facility-show 
        :facility="cuurentFacility"
        @back="backFromShow"
      >
      </facility-show>
    </div>

    <div v-else id="facilities-wrap">
      <div class="f-heading">
        <h2>Facilities</h2>
        <div @click.stop="addNewFacility" class="f-add-facility icon-btn">
          <i class="material-icons">add</i>
        </div>
      </div>
      <div id="f-table">
        <table class="table table-hover mt-3">
          <thead>
            <tr>
              <th scope="col">Sr.</th>
              <th scope="col">Name</th>
              <th scope="col">Region</th>
              <th scope="col">Email</th>
              <th scope="col">Phone No.</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(facility, index) in facilities" 
              :key="facility.id"
              @click.stop="showFacility(facility)"
            >
              <th scope="row">{{ index+1 }}</th>
              <td>{{facility.facilityName}}</td>
              <td>{{facility.email}}</td>
              <td>{{facility.phoneNumber}}</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>

<script>
  import http         from './../../../common/http'
  import FacilityForm from './_form.vue'
  import FacilityShow from './_show.vue'
  
  export default {
    name: 'FacilitiesIndex',
    components: {
      FacilityForm,
      FacilityShow
    },
    data() {
      return {
        loading: true,
        facilities: [],
        cuurentFacility: null
      }
    },
    mounted() {
      this.fetchFacilities()
    },
    methods: {
      fetchFacilities() {
        http
          .get('/facilities.json')
          .then((res) => {
            this.facilities = res.data.facilities;
            this.loading = false;
          })
          .catch((err) => {
            this.loading = false;
            console.error(err);
          })
      },
      addNewFacility() {
        this.$modal.show('new-facility-form')
      },
      facilityFormCb() {
        this.$modal.hide('new-facility-form')
        this.loading = true;
        this.fetchFacilities();
      },
      showFacility(facility) {
        this.cuurentFacility = facility;
      },
      backFromShow() {
        this.cuurentFacility = null;
        this.loading = true;
        this.fetchFacilities();
      }
    }
  }  
</script>

<style lang="scss" scoped>
  #facilities-wrap {
    .f-heading {
      display: flex;
      justify-content: space-between;
      align-items: center;
    }
    .f-add-facility {
      font-weight: bold;
      border-radius: 50%;
      display: flex;
      padding: 5px;
      border-radius: 50%;
      justify-content: center;
      align-items: center;
    }
  }
</style>
