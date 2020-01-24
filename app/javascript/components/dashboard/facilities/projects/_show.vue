<template>
  <div id="project-show" class="mt-4">
    <div class="project-actions">
      <div v-if="facility.creator && $currentUser.id === facility.creator.id" class="crud-actions mx-3">
        <span class="mr-3 edit-action" @click.stop="editProject">
          <i class="fas fa-edit"></i>
        </span>
        <span class="delete-action" @click.stop="deleteProject">
          <i class="fas fa-trash-alt"></i>
        </span>
      </div>
    </div>
    <h4 class="mt-2 text-center">{{facility.facilityName}}</h4>
    <div class="mt-2 d-flex">
      <span class="fbody-icon"><i class="fas fa-check"></i></span>
      <h5 class="text-secondary">{{ DV_project.name }}</h5>
    </div>
    <div class="mt-2 d-flex align-items-center">
      <div>Type: {{DV_project.projectType}}</div>
      <div class="ml-2 badge badge-pill" :class="{ 'badge-success': DV_project.status == 'completed', 'badge-warning': DV_project.status == 'pending' }">{{DV_project.status}}</div>
    </div>
    <div class="mt-2 progress">
      <div class="progress-bar bg-info" :style="`width: ${DV_project.progress}%`">{{DV_project.progress}}%</div>
    </div>
    <div class="mt-2">
      <p class="f-notes text-muted">
        {{DV_project.description || 'No description'}}
      </p>
    </div>
    <hr/>
    <div>
      <task-index
        v-if="DV_project"
        :project="DV_project" 
        :facility="facility"
        @refresh-project="refreshProject"
      />
    </div>
  </div>
</template>

<script>
  import TaskIndex from './tasks/_index'
  import http      from './../../../../common/http'
  
  export default {
    name: 'ProjectShow',
    props: ['project', 'facility'],
    components: { TaskIndex },
    data() {
      return {
        loading: true,
        DV_project: this.project
      }
    },
    methods: {
      fetchProject() {
        http
          .get(`/facilities/${this.facility.id}/projects/${this.project.id}.json`)
          .then((res) => {
            this.DV_project = res.data.project
            this.loading = false
          })
          .catch(err => console.log(err))
      },
      refreshProject() {
        this.loading = true
        this.fetchProject()
      },
      editProject() {
        this.$emit('edit-project', {facility: this.facility, project: this.DV_project})
      },
      deleteProject() {
        http
          .delete(`/facilities/${this.facility.id}/projects/${this.DV_project.id}.json`)
          .then((res) => {
            this.loading = false;
            this.$emit('deleted-project', this.DV_project);
          })
          .catch((err) => {
            this.loading = false;
            console.error(err);
          })
      }
    },
    watch: {
      project: {
        handler: function(value) {
          this.DV_project = value
        },
        deep: true
      }
    }
  }  
</script>

<style lang="scss" scoped>
  hr {
    margin: 1em 0.25em;
    border: 0;
    border-top: 1px solid rgba(0, 0, 0, 0.1);
  }
  .project-actions {
    position: absolute;
    right: 10px;
    top: 10px;
  }
  .f-notes {
    border: 1px solid #ccc;
    border-radius: 5px;
    padding: 5px;
    overflow-y: auto;
    min-height: 15vh;
    max-height: 30vh;
  }
</style>
