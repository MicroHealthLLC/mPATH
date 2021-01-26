<template>
  <div class="d-flex">
    <transition name="slide-fade">
      <div v-if="facilityGroupBar" id="facility_group-bar">
        <div class="r-header px-3">
          <h5 class="text-muted">Project Groups</h5>
          <div class="region-minus-btn" @click="facilityGroupBar= false">
            <i class="fa fa-times"></i>
          </div>
        </div>
        <ul v-if="facilityGroups.length > 0" class="regions-list list-unstyled">
          <li v-for="facilityGroup in facilityGroups" class="px-3">
            <a class="text-secondary d-flex align-items-center mt-2"
              @click.prevent.stop="gotoFacilityGroup(facilityGroup)"
              href="javascript:;"
              :class="{'link-disabled': facilityGroup.status == 'inactive'}"
              >
              <div class="badge badge-pill" :class="{'badge-success':
                facilityGroup.status == 'active', 'badge-danger': facilityGroup.status == 'inactive'}">
                {{facilityGroup.status}}
              </div>
              <div class="ml-2 region-name font-md">
                <span>{{facilityGroup.name}}</span>
                <span class="badge badge-secondary badge-pill">{{groupFacilities(facilityGroup).length}}</span>
              </div>
            </a>
          </li>
        </ul>
        <div v-else class="text-danger px-3 py-1">
          The Project doesn't have any groups
        </div>
      </div>
    </transition>
  </div>
</template>

<script>
  export default {
    name: 'FacilityGroupBar',
    props: ['facilityGroups', 'facilities', 'project'],
    data() {
      return {
        facilityGroupBar: false
      }
    },
    methods: {
      gotoFacilityGroup(group) {
        if (group && group.status === 'inactive') return;
        this.facilityGroupBar = false
        this.$emit('goto-facility-group', group)
      },
      groupFacilities(group) {
        var ids = _.map(this.facilities, 'id')
        return _.filter(group.facilities, (f => ids.includes(f.facilityId) && f.projectId == this.project.id))
      }
    }
  }
</script>

<style scoped lang="scss">
  #facility_group-bar {
    padding: 10px;
    background: #fff;
    width: 20vw;
    min-width: 200px;
    max-height: 60vh;
    min-height: 30vh;
    border-radius: 4px;
    box-shadow: rgba(0, 0, 0, 0.3) 0px 1px 4px -1px;
    .r-header {
      display: flex;
      justify-content: space-between;
    }
    .regions-list {
      max-height: 85%;
      overflow: auto;
      li:hover > a {
        color: #000;
        text-decoration: none;
      }
      li a {
        font-size: 14px;
      }
      li a > .region-color {
        height: 10px;
        width: 15px;
      }
      .region-name {
        word-break: break-word;
        width: 15vw;
      }
    }
  }
  .region-minus-btn {
    cursor: pointer;
  }
  .slide-fade-enter-active {
    transition: all .5s ease-in;
  }
  .slide-fade-leave-active {
    transition: all .4s ease-in-out;
  }
  .slide-fade-enter, .slide-fade-leave-to {
    transform: translateX(-100px);
    opacity: 0;
  }
  .link-disabled {
    cursor: not-allowed;
    text-decoration: none !important;
    opacity: 0.5;
    &:hover {
      color: #6c757d !important;
    }
  }
</style>
