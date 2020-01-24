<template>
  <nav id="sub-nav-wrap" class="navbar navbar-expand-lg blue-gradient navbar-light">
    <div class="left-sub-nav">
      <ul class="navbar-nav my-2 my-lg-0">
        <li class="nav-item" v-if="currentProject">
          <a class="btn fav-btn" href="javascript:;" @click.prevent.stop="$emit('add-facility-from-nav')">Add Facility</a>
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
              @select="updateProjectQuery"
            >
              <template slot="singleLabel" slot-scope="{option}">
                <div class="d-flex">
                  <span>{{option.name}}</span> 
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
      this.currentProject = this.DV_projects.find(project => project.uuid=== this.$route.params.projectId)
    },
    methods: {
      updateProjectQuery(selected, index) {
        window.location.pathname = "/projects/" + selected.uuid
        // this.$router.push({name: 'ProjectDashboard', params: {projectId: selected.uuid} })
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
    width: 300px;
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
  }

</style>
