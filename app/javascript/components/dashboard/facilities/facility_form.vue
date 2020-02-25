<template>
  <form id="facilities-form" @submit.prevent="saveFacilitiy" class="mx-auto needs-validations" accept-charset="UTF-8">
    <div v-if="showErrors" class="text-danger mb-3">Please fill the required feilds before submitting</div>
    <div class="form-group">
      <label>Facility Name:</label>
      <input name="Facility Name" v-validate="'required'" type="text" class="form-control" v-model="DV_facility.facilityName" placeholder="Microhealthllc facility" :class="{'form-control': true, 'error': errors.has('Facility Name') }" />
      <div v-show="errors.has('Facility Name')" class="text-danger">{{ errors.first('Facility Name') }}</div>
    </div>
    <div class="form-group">
      <label>Region:</label>
      <select name="Region" class="form-control" v-model="DV_facility.regionId" v-validate="'required'" :class="{'form-control': true, 'error': errors.has('Region')}">
        <option
          v-for="region in regions"
          :value="region.id"
        >
          {{region.name}}
        </option>
      </select>
      <span v-show="errors.has('Region')" class="text-danger">{{ errors.first('Region') }}</span>
    </div>
    <div class="form-group">
      <label>Street Address:</label>
      <GmapAutocomplete
        name="Street Address"
        @place_changed="updateAddress"
        v-validate="'required'"
        class="form-control"
        v-model="DV_facility.address"
        :class="{'form-control': true, 'error': errors.has('Street Address')}"
      />
      <div v-show="errors.has('Street Address')" class="text-danger">{{ errors.first('Street Address') }}</div>
    </div>
    <div class="form-group">
      <label>Point of Contact:</label>
      <input name="Point of Contact" v-validate="'required'" type="text" class="form-control" placeholder="John. Doe" v-model="DV_facility.pointOfContact" :class="{'form-control': true, 'error': errors.has('Point of Contact') }" />
      <div v-show="errors.has('Point of Contact')" class="text-danger">{{ errors.first('Point of Contact') }}</div>
    </div>
    <div class="form-group">
      <label>Phone Number:</label>
      <input name="phonenumber" type="text" v-validate="'required'" class="form-control" oninput="this.value = this.value.replace(/^[2-9]\d{2}-\d{3}-\d{4}$/g, '$1');" placeholder="0912345678" v-model="DV_facility.phoneNumber" :class="{'form-control': true, 'error': errors.has('phonenumber') }" />
      <div v-show="errors.has('phonenumber')" class="text-danger">{{ errors.first('phonenumber') }}</div>
    </div>
    <div class="form-group">
      <label>Email:</label>
      <input name="email" v-validate="'required|email'" type="text" class="form-control" placeholder="johndoe@example.com" v-model="DV_facility.email" :class="{'form-control': true, 'error': errors.has('email') }" />
      <div v-show="errors.has('email')" class="text-danger">{{ errors.first('email') }}</div>
    </div>
    <div class="form-group">
      <label>Description:</label>
      <textarea class="form-control" placeholder="briefly describe here.." v-model="DV_facility.notes" rows="5"></textarea>
    </div>
    <div class="d-flex flex-row-reverse form-group mt-4">
      <button :disabled="!readyToSave" class="btn btn-success w-0">Save</button>
      <button @click.prevent="$emit('close-facility')" class="btn btn-outline-secondary w-0 mr-1">Cancel</button>
    </div>
  </form>
</template>

<script>
  import http from './../../../common/http'

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
        showErrors: false,
        addressLoading: false,
        address: {},
        addresses: []
      }
    },
    mounted() {
      if (this.facility) {
        this.DV_facility = this.facility
        this.address.formatted_address = this.facility.address
      }
    },
    methods: {
      saveFacilitiy() {
        this.$validator.validate().then((success) => {
          if (!success) {
            this.showErrors = true
            return
          }
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
         });
      },
      updateAddress(address) {
        this.address = address
      }
    },
    computed: {
      readyToSave() {
        return (
          this.DV_facility &&
          this.DV_facility.facilityName.trim() !== '' &&
          this.DV_facility.regionId !== '' &&
          this.DV_facility.address !== '' &&
          this.DV_facility.pointOfContact !== '' &&
          this.DV_facility.phoneNumber !== '' &&
          this.DV_facility.email.trim() !== ''
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
          this.DV_facility.address = value.formatted_address
          if (value.geometry) {
            this.DV_facility.lat = value.geometry.location.lat()
            this.DV_facility.lng = value.geometry.location.lng()
          }
        }, deep: true
      }
    }
  }
</script>

<style lang="scss" scoped>
  .street-address /deep/ .multiselect__select {
    display: none;
  }
 .form-control.error {
    border-color: #E84444;
  }
</style>
