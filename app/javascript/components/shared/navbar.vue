<template>
  <nav id="sub-nav-wrap" class="navbar navbar-expand-lg blue-gradient navbar-light">
    <div class="left-sub-nav">
      <ul class="navbar-nav my-2 my-lg-0">
        <!-- <li class="nav-item" v-if="currentProject && $currentUser.role === 'admin'">
          <a class="btn fav-btn" :class="{disabled: !allowFacilityAdd}" href="javascript:;" @click.prevent.stop="addFacility">Add Facility</a>
        </li> -->
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
              @select="updateProjectQuery"
            >
              <template slot="singleLabel" slot-scope="{option}">
                <div class="d-flex">
                  <span class='select__tag-name'>{{option.name}}</span>
                  <span class="ml-2 badge badge-pill" :class="{ 'badge-success': option.status == 'completed', 'badge-warning': option.status == 'pending' }">{{option.status}}</span>
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
    props: ['projects'],
    data() {
      return {
        currentProject: null,
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
      addFacility() {
        if (this.allowFacilityAdd) this.$emit('add-facility-from-nav')
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
    width: 450px;
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
      width: 300px;
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
