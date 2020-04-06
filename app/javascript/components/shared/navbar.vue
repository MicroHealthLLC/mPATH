<template>
  <nav id="sub-nav-wrap" class="navbar navbar-expand-lg blue-gradient navbar-light">
    <div class="left-sub-nav">
      <ul class="navbar-nav my-2 my-lg-0">
        <!-- <li class="nav-item" v-if="currentProject && $currentUser.role === 'admin'">
          <a class="btn fav-btn" :class="{disabled: !allowFacilityAdd}" href="javascript:;" @click.prevent.stop="addFacility">Add Facility</a>
        </li> -->
        <li class="nav-item mr-2">
          <div class="status-select">
            <multiselect
              v-model="currentStatus"
              track-by="name"
              label="name"
              placeholder="Filter by Status"
              :options="DV_statuses"
              :searchable="false"
              :multiple="true"
              :max="1"
              select-label="Select"
              deselect-Label="Remove"
              @select="updateStatusFilter"
              @remove="removeStatusFilter"
              >
              <template slot="singleLabel" slot-scope="{option}">
                <div class="d-flex">
                  <span class='select__tag-name'>{{option.name}}</span>
                </div>
              </template>
            </multiselect>
          </div>
        </li>
        <li class="nav-item mr-2">
          <div class="facilitygroup-select">
            <multiselect
              v-model="currentFacilityGroup"
              track-by="name"
              label="name"
              placeholder="Filter by facility group"
              :options="DV_facilityGroups"
              :multiple="true"
              :max="1"
              select-label="Select"
              deselect-Label="Remove"
              :searchable="false"
              @select="updateFacilityGroupFilter"
              @remove="removeFacilityGroupFilter"
              >
              <template slot="singleLabel" slot-scope="{option}">
                <div class="d-flex">
                  <span class='select__tag-name'>{{option.name}}</span>
                </div>
              </template>
            </multiselect>
          </div>
        </li>
        <li class="nav-item">
          <div class="facilityname-search">
            <multiselect
              placeholder="Search by facility name"
              v-model="selectedFacility"
              label="facilityName"
              track-by="id"
              :multiple="true"
              :max="1"
              :options="facilities"
              :searchable="true"
              :loading="isLoading"
              :preserve-search="true"
              select-label="Select"
              deselect-Label="Remove"
              @select="onSelectFacility"
              @remove="onRemoveFacility"
              @search-change="findFacility"
              >
              <template slot="singleLabel" slot-scope="{option}">
                <div class="d-flex">
                  <span class='select__tag-name'>{{option.facilityName}}</span>
                </div>
              </template>
              <span slot="noOptions">...</span>
            </multiselect>
          </div>
        </li>
      </ul>
    </div>
    <div class="right-sub-nav">
      <ul class="navbar-nav my-2 my-lg-0">
        <li class="nav-item">
          <div class="project-select">
            <multiselect
              v-model="currentProject"
              track-by="name"
              label="name"
              placeholder="Select Project"
              :options="DV_projects"
              :searchable="false"
              :allow-empty="false"
              select-label="Select"
              @select="updateProjectQuery"
              >
              <template slot="singleLabel" slot-scope="{option}">
                <div class="d-flex">
                  <span class='select__tag-name'>{{option.name}}</span>
                </div>
              </template>
            </multiselect>
          </div>
        </li>
      </ul>
    </div>
  </nav>
</template>

<script>
  export default {
    name: 'Navbar',
    props: ['projects', 'statuses', 'facilityGroups'],
    data() {
      return {
        isLoading: false,
        currentProject: null,
        currentStatus: null,
        currentFacilityGroup: null,
        selectedFacility: null,
        facilities: [],
        DV_statuses: this.statuses,
        DV_facilityGroups: this.facilityGroups,
        DV_projects: this.projects
      }
    },
    mounted() {
      this.currentProject = this.DV_projects.find(project => project.id == this.$route.params.projectId)
    },
    computed: {
      allowFacilityAdd() {
        return this.currentProject
      }
    },
    methods: {
      updateProjectQuery(selected, index) {
        window.location.pathname = "/projects/" + selected.id
        // this.$router.push({name: 'ProjectDashboard', params: {projectId: selected.id} })
      },
      updateStatusFilter(selected, index) {
        this.$emit('on-status-change', selected)
      },
      removeStatusFilter() {
        this.$emit('on-status-change', {id: 'sa'})
      },
      updateFacilityGroupFilter(selected, index) {
        this.$emit('on-facilitygroup-change', selected)
      },
      removeFacilityGroupFilter() {
        this.$emit('on-facilitygroup-change', {id: 'sa'})
      },
      addFacility() {
        if (this.allowFacilityAdd) this.$emit('add-facility-from-nav')
      },
      findFacility(query) {
        this.isLoading = true
        var callback = (response => {
          this.facilities = response
          this.isLoading = false
        })
        this.$emit('on-facility-name-search', query, callback)
      },
      onSelectFacility(selected) {
        this.$emit('on-filter-by-facility', selected)
      },
      onRemoveFacility() {
        this.$emit('on-filter-by-facility', null)
      }
    },
    watch: {
      projects: {
        handler: function(value) {
          this.DV_projects = value
        }, deep: true
      }
    }
  }
</script>
<style scoped lang="scss">
  #sub-nav-wrap {
    padding: 20px 60px;
    height: 44px;
    box-shadow: 0 2px 5px 0 rgba(0,0,0,0.16);
    z-index: 1030;
    font-weight: 300;
    background: #fff;
  }
  .right-sub-nav {
    position: absolute;
    right: 70px;
    top: 3px;
  }
  .left-sub-nav {
    position: absolute;
    left: 70px;
  }
  .project-select {
    width: 410px;
  }
  .facilityname-search /deep/ .multiselect,
  .facilitygroup-select /deep/ .multiselect,
  .status-select /deep/ .multiselect {
    font-size: 14px;
    width: 200px;
    .multiselect__placeholder {
      margin-bottom: 2px;
      padding-top: 2px;
    }
    .select__tag-name {
      white-space: nowrap;
      text-overflow: ellipsis;
      overflow: hidden;
      width: 170px;
    }
    .multiselect__option {
      white-space: normal;
    }
    .multiselect__option--selected:after {
      content: unset;
    }
    .multiselect__tags {
      padding-top: 6px;
    }
  }
  .facilityname-search /deep/ .multiselect {
    width: 250px;
  }
  .project-select /deep/ .multiselect {
    font-size: 14px;
    .multiselect__tags {
      min-height: 20px;
    }
    .multiselect__placeholder {
      margin-bottom: 2px;
      padding-top: 2px;
    }
    .select__tag-name {
      white-space: nowrap;
      text-overflow: ellipsis;
      overflow: hidden;
      width: 350px;
    }
    .multiselect__option {
      white-space: normal;
    }
    .multiselect__option--selected:after {
      content: unset;
    }
  }
  a.disabled {
    pointer-events: none;
    cursor: default;
    opacity: 0.8;
  }
</style>
