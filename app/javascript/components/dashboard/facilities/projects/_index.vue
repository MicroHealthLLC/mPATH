<template>
  <div id="project-index" class="mt-3">
    <div v-if="!showCurrent">
      <div class="d-flex justify-content-between mb-3">
        <h5>{{ DV_facility.facilityName }}</h5>
        <a href="javascript:;" class="btn fav-btn" @click.prevent.stop="addNewProject">Add Project</a>
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
      ></project-show>
    </div>

    <sweet-modal 
      ref="projectForm" 
      overlay-theme="dark"
      @close="DV_projectForm = false"
    >
      <project-form
        v-if="DV_projectForm"
        :facility="DV_facility"
        :project="currentProject"
        @project-created="projectCreated"
        class="project-form-modal"
      ></project-form>
    </sweet-modal>
  </div>
</template>

<script>
  import ProjectShow  from './_show'
  import ProjectForm  from './_form'
  import {SweetModal} from 'sweet-modal-vue'
  export default {
    name: 'ProjectIndex',
    props: ['facility'],
    components: { ProjectShow, ProjectForm, SweetModal },
    data() {
      return {
        showCurrent: false,
        currentProject: null,
        DV_projectForm: false,
        DV_facility: this.facility
      }
    },
    methods: {
      showProject(project) {
        this.currentProject = project
        this.showCurrent = true
      },
      addNewProject() {
        this.DV_projectForm = true
        this.$refs.projectForm.open()
      },
      projectCreated(project) {
        this.currentProject = project
        this.showCurrent = true
        this.DV_projectForm = false
        this.$refs.projectForm.close()
        this.$emit('refresh-facility')
      },
      projectDeleted() {
        this.showCurrent = false
        this.$emit('refresh-facility')
      },
      editProject(res) {
        this.currentProject = res.project
        this.DV_projectForm = true
        this.$refs.projectForm.open()
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
