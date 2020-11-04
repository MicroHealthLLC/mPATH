<template>
  <div id="tabbar">
    <router-link v-if="permitted('facility_manager_view')" :to="facilityManagerView" tag="div">
      <div class="badge" :class="{'active': isFacilityManagerView}">Facility View</div>
    </router-link>
    <router-link v-if="permitted('map_view')" :to="mapView" tag="div">
      <div class="badge" :class="{'active': isMapView}">Map View</div>
    </router-link>
    <router-link v-if="permitted('gantt_view')" :to="ganttView" tag="div">
      <div class="badge" :class="{'active': isGanttView}">Gantt View</div>
    </router-link>
    <router-link v-if="permitted('watch_view')" :to="watchView" tag="div">
      <div class="badge" :class="{'active': isWatchView}">On Watch View</div>
    </router-link>
    
    <div v-if="permitted('issues')" class="badge disabled">Kanban View (Coming Soon)</div>
      <div v-if="permitted('issues')" class="badge disabled">Mindmap View (Coming Soon)</div>
    <div v-if="permitted('documents')" class="badge disabled">Documents (Coming Soon)</div>
    <router-link v-if="permitted('members')" :to="membersView" tag="div">
      <div class="badge" :class="{'active': isMembersView}">Team Members</div>
    </router-link>
  </div>
</template>

<script>
  export default {
    name: 'Tabsbar',
    computed: {
      isMapView() {
        return this.$route.name === 'ProjectMapView'
      },
      isGanttView() {
        return this.$route.name === 'ProjectGanttChart'
      },
      isWatchView() {
        return this.$route.name === 'ProjectWatchView'
      },
      isMembersView() {
        return this.$route.name === 'TeamMembersView'
      },
      isFacilityManagerView() {
        return this.$route.name === 'FacilityManagerView'
      },
      mapView() {
        return `/projects/${this.$route.params.projectId}`
      },
      ganttView() {
        return `/projects/${this.$route.params.projectId}/gantt_chart`
      },
      watchView() {
        return `/projects/${this.$route.params.projectId}/watch_view`
      },
      membersView() {
        return `/projects/${this.$route.params.projectId}/member_list`
      },
      facilityManagerView() {
        return `/projects/${this.$route.params.projectId}/facility_manager`
      },
      permitted() {
        return salut => this.$currentUser.role == "superadmin" || this.$permissions[salut]['read']
      }
    }
  }
</script>

<style scoped lang="scss">
  #tabbar {
    padding: 4px 70px;
    display: flex;
    align-items: center;
    justify-content: center;
    box-shadow: 0 2px 5px 0 rgba(0,0,0,0.02), 0 2px 5px 0 rgba(0,0,0,0.03);
    .badge {
      cursor: pointer;
      padding: 5px;
      margin: 2px 10px;
      transition: auto;
      &.active {
        color: #fff;
        padding: 5px;
        background-color: #17a2b8;
      }
      &.disabled {
        opacity: 0.5;
        cursor: not-allowed;
        border: 0 !important;
        padding: 5px !important;
      }
      &:hover {
        padding: 4px;
        border: 1px solid #17a2b8;
      }
    }
  }
</style>
