<template>
  <div id="facility_sidebar">
    <h4 class="mt-4 text-info text-center" v-if="title">{{title}}</h4>
      <div class="my-4 ml-2">
        <div v-for="group in filteredFacilityGroups" class="my-3">
          <div class="d-flex expandable" @click="expandFacilityGroup(group)" :class="{'active': group.id == currentFacilityGroup.id}">
            <span v-show="expanded.id != group.id">
              <i class="fa fa-angle-right font-sm mr-2 clickable"></i>
            </span>
            <span v-show="expanded.id == group.id">
             <i class="fa fa-angle-down font-md mr-2 clickable"></i>
            </span>
            <h5 class="clickable">{{group.name}}</h5>
          </div>
          <div v-show="expanded.id == group.id" class="ml-2">
            <div v-for="item in facilityGroupFacilities(group)">
              <div class="d-flex align-items-center expandable" @click="showFacility(item)" :class="{'active': item.id == currentFacility.id}">
              <h6 class="facility-header">{{item.facility.facilityName}}</h6>
              </div>
            </div>
          </div>
        </div>
      </div>
  </div>
</template>

<script>
  import {mapGetters} from 'vuex'
  export default {
    name: 'FacilitySidebar',
    props: ['title', 'currentFacilityGroup', 'expanded', 'currentFacility'],
    computed: {
      ...mapGetters([
        'filteredFacilityGroups',
        'facilityGroupFacilities'
      ]),
    },
    methods: {
      expandFacilityGroup(group) {
        this.$emit('on-expand-facility-group', group)
      },
      showFacility(facility) {
        this.$emit('on-expand-facility', facility)
      }
    }
  }
</script>

<style lang="scss" scoped>
   #facility_sidebar {
    .facility-header {
      padding: 0 8px;
      cursor: pointer;
      font-weight: 400 !important;
      &:hover {
        font-weight: 900 !important;
        background-color: rgba(91, 192, 222, 0.3);
      }
    }
    .expandable {
      &.active {
        h6 {
          background-color: rgba(211, 211, 211, 10%);
        }
      }
    }
    .expandable {
      &.active,
      &:hover {
        h5, h6 {
          font-weight: 900 !important;
        }
      }
    }
  }
</style>
