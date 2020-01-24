<template>
  <form id="facilities-form" @submit.prevent="saveFacilitiy" class="mx-auto needs-validations" accept-charset="UTF-8">
    <div class="form-group">
      <label>Facility Name:</label>
      <input type="text" class="form-control" v-model="DV_facility.facilityName" required placeholder="Microhealthllc facility" />
    </div>
    <div class="form-group">
      <label>Region:</label>
      <select class="form-control" required v-model="DV_facility.regionId">
        <option disabled selected value="">-Select-</option>
        <option 
          v-for="region in regions"
          :value="region.id"
        >
          {{region.name}}
        </option>
      </select>
    </div>
    <div class="form-group street-address">
      <label>Street Address:</label>
        <multiselect
          v-model="address" 
          id="address-search"
          label="label" 
          track-by="label" 
          placeholder="Type to search" 
          open-direction="bottom" 
          :options="addresses" 
          :searchable="true" 
          :taggable="true"
          :preserve-search="true"
          :loading="addressLoading" 
          :options-limit="300" 
          :max-height="600"
          :show-no-results="true" 
          @search-change="asyncAddressFind"
        >
        <template slot="tag" slot-scope="{option, remove}">
          <span class="custom__tag">
            <span>{{ option.label }}</span>
            <span class="custom__remove" @click="remove(option)">❌</span>
          </span>
        </template>
        <span slot="noResult">
          Oops! No addresses found. Consider changing the search query!
        </span>
        <span slot="noOptions"></span>
      </multiselect>
    </div>
    <div class="form-group">
      <label>Point of Contact:</label>
      <input type="text" class="form-control" placeholder="John. Doe" v-model="DV_facility.pointOfContact" />
    </div>
    <div class="form-group">
      <label>Phone Number:</label>
      <input type="text" class="form-control" placeholder="0912345678" v-model="DV_facility.phoneNumber" />
    </div>
    <div class="form-group">
      <label>Email:</label>
      <input type="email" class="form-control" placeholder="johndoe@example.com" v-model="DV_facility.email" />
    </div>
    <div class="form-group">
      <label>Description:</label>
      <textarea class="form-control" placeholder="briefly describe here.." v-model="DV_facility.notes" rows="5"></textarea>
    </div>
    <div class="clearfix form-group mt-4">
      <button :disabled="!readyToSave" class="btn btn-success w-100">Save Facility</button>
    </div>
  </form>
</template>

<script>
  import http from './../../../common/http'
  import { OpenStreetMapProvider } from 'leaflet-geosearch';
  const provider = new OpenStreetMapProvider();

  export default {
    name: 'Facilitiesform',
    props: ['facility', 'regions'],
    data() {
      return {
        DV_facility: {
          facilityName: '',
          regionId: '',
          address: '',
          pointOfContact: '',
          phoneNumber: '',
          email: '',
          notes: '',
          lat: '',
          lng: ''
        },
        addressLoading: false,
        address: null,
        addresses: []
      }
    },
    mounted() {
      if (this.facility) {
        this.DV_facility = this.facility
        this.locateAddress()
      }
    },
    methods: {
      saveFacilitiy() {
        var data = {facility: this.DV_facility}
        if (this.facility && this.facility.id) {
          http.put(`/projects/${this.$route.params.projectId}/facilities/${this.facility.id}.json`, data)
            .then((res) => {
              this.$emit('facility-update', res.data.facility);
            })
            .catch((err) => {
              console.error(err)
            })
        }
        else {
          http.post(`/projects/${this.$route.params.projectId}/facilities.json`, data)
            .then((res) => {
              this.$emit('facility-created', res.data.facility);
            })
            .catch((err) => {
              console.error(err)
            })
        }
      },
      asyncAddressFind(query) {
        this.addressLoading = true
        provider
          .search({query: query})
          .then((result) => {
            this.addresses = result
            this.addressLoading = false
          })
      },
      locateAddress() {
        if (this.facility.address == null || this.facility.address == '') return
        provider.search({query: this.facility.address})
          .then((res) => {
            this.address = res[0] || null
          })
      }
    },
    computed: {
      readyToSave() {
        return (
          this.DV_facility && 
          this.DV_facility.facilityName.trim() !== '' &&
          this.DV_facility.lat !== '' && 
          this.DV_facility.lng !== ''
        );
      }
    },
    watch: {
      facility: {
        handler: function(value) {
          this.DV_facility = value
        },
        deep: true
      },
      address: { 
        handler: function(value) {
          this.DV_facility.address = value.raw.display_name
          this.DV_facility.lat = value.raw.lat
          this.DV_facility.lng = value.raw.lon
        }, deep: true
      }
    }
  }  
</script>

<style lang="scss" scoped>
  .street-address /deep/ .multiselect__select {
    display: none;
  }
</style>
