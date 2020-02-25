<template>
  <div id="project-index" class="mt-3">
    <div v-if="!showCurrent">
      <div class="d-flex justify-content-between mb-3">
        <h5>{{ DV_facility.facilityName }}</h5>
      </div>
      <ul class="list-group">
        <li class="list-group-item" v-for="(project, index) in DV_facility.projects">
          <div class="row">
            <div class="col-10 d-flex">
              <p class="m-0">{{project.name}}</p>
              <div>
                <span class="ml-2 badge badge-pill" :class="{ 'badge-success': project.status == 'completed', 'badge-warning': project.status == 'pending' }">{{project.status}}</span>
              </div>
            </div>
            <div class="col-2">
              <a href="javascript:;" @click.prevent.stop="showProject(project)" class="btn btn-sm btn-link">...</a>
            </div>
          </div>
        </li>
      </ul>
    </div>
    <div v-if="showCurrent">
      <project-show
        v-if="currentProject"
        :facility="DV_facility"
        :project="currentProject"
        @deleted-project="projectDeleted"
        @edit-project="editProject"
      />
    </div>
  </div>
</template>

<script>
  import ProjectShow  from './project_show'

  export default {
    name: 'ProjectIndex',
    props: ['facility'],
    components: { ProjectShow },
    data() {
      return {
        showCurrent: false,
        currentProject: null,
        DV_facility: this.facility
      }
    },
    methods: {
      showProject(project) {
        this.currentProject = project
        this.showCurrent = true
      },
      projectCreated(project) {
        this.currentProject = project
        this.showCurrent = true
        this.$emit('refresh-facility')
      },
      projectDeleted() {
        this.showCurrent = false
        this.$emit('refresh-facility')
      },
      editProject(res) {
        this.currentProject = res.project
      }
    },
    watch: {
      facility: {
        handler: function(value) {
          this.DV_facility = value
        },
        deep: true
      }
    }
  }
</script>

<style lang="scss" scoped>
  .list-group-item {
    padding: 0.45rem 1.25rem !important;
  }
</style>
