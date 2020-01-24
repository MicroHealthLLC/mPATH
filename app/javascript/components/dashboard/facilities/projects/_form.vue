<template>
  <form id="project-form" @submit.prevent="saveProject" class="mx-auto" accept-charset="UTF-8">
    <div class="form-group">
      <input type="text" class="form-control" v-model="DV_project.name" placeholder="Project Name" />
    </div>
    <div class="form-group">
      <select class="form-control" v-model="DV_project.status">
        <option disabled value="">Status</option>
        <option 
          v-for="opt in projectStatuses"
          :value="opt.value"
        >
          {{opt.text}}
        </option>
      </select>
    </div>
    <div class="form-group">
      <select class="form-control" v-model="DV_project.projectType">
        <option disabled value="">Project Type</option>
        <option 
          v-for="opt in projectTypes"
          :value="opt.value"
        >
          {{opt.text}}
        </option>
      </select>
    </div>
    <div class="form-group">
      <textarea class="form-control" placeholder="project brief description" v-model="DV_project.description" rows="4"></textarea>
    </div>
    <div class="clearfix form-group mt-4">
      <button :disabled="!readyToSave" class="btn btn-primary float-right">Save</button>
    </div>
  </form>
</template>

<script>
  import http from './../../../../common/http'
  
  export default {
    name: 'Projectform',
    props: ['facility', 'project'],
    data() {
      return {
        DV_project: {
          name: '',
          status: '',
          projectType: '',
          description: ''
        },
        projectStatuses: [
          {text: 'Pending', value: 'pending'},
          {text: 'Completed', value: 'completed'}
        ],
        projectTypes: [
          {text: 'Project Type 1', value: 'project_type1'},
          {text: 'Project Type 2', value: 'project_type2'}
        ]
      }
    },
    mounted() {
      if (this.project) this.DV_project = this.project
    },
    methods: {
      saveProject() {
        var data = {project: this.DV_project}
        if (this.project && this.project.id) {
          http.put(`/facilities/${this.facility.id}/projects/${this.project.id}.json`, data)
            .then((res) => {
              this.$emit('project-update', res.data.project);
            })
            .catch(err => console.error(err))
        }
        else {
          http.post(`/facilities/${this.facility.id}/projects.json`, data)
            .then((res) => {
              this.$emit('project-created', res.data.project);
            })
            .catch(err => console.error(err))
        }
      }
    },
    computed: {
      readyToSave() {
        return (
          this.DV_project && 
          this.DV_project.name.trim() !== ''
        );
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
</style>
