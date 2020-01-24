<template>
  <form id="tasks-form" @submit.prevent="saveTask" class="mx-auto" accept-charset="UTF-8">
    <div class="form-group">
      <input type="text" class="form-control" v-model="DV_task.text" placeholder="Text" />
    </div>
    <div class="form-group">
      <select class="form-control" v-model="DV_task.taskType">
        <option disabled value="">Task Type</option>
        <option 
          v-for="opt in taskTypes"
          :value="opt.value"
        >
          {{opt.text}}
        </option>
      </select>
    </div>
    <div class="form-group">
      <input type="date" class="form-control" v-model="DV_task.dueDate" />
    </div>
    <div class="form-group">
      <textarea class="form-control" placeholder="task brief description" v-model="DV_task.notes" rows="4"></textarea>
    </div>
    <div class="clearfix form-group mt-4">
      <button :disabled="!readyToSave" class="btn btn-primary float-right">Save</button>
    </div>
  </form>
</template>

<script>
  import http from './../../../../../common/http'
  
  export default {
    name: 'TaskForm',
    props: ['facility', 'project', 'task'],
    data() {
      return {
        DV_task: {
          text: '',
          dueDate: '',
          taskType: '',
          notes: ''
        },
        taskTypes: [
          { text: 'upgrade', value: 'upgrade' },
          { text: 'story', value: 'story' }
        ]
      }
    },
    mounted() {
      if (this.task) this.DV_task = this.task
    },
    methods: {
      saveTask() {
        var data = {task: this.DV_task}
        if (this.task && this.task.id) {
          http.put(`/facilities/${this.facility.id}/projects/${this.project.id}/tasks/${this.task.id}.json`, data)
            .then((res) => {
              this.$emit('task-update', res.data.task);
            })
            .catch(err => console.error(err))
        }
        else {
          http.post(`/facilities/${this.facility.id}/projects/${this.project.id}/tasks.json`, data)
            .then((res) => {
              this.$emit('task-created', res.data.task);
            })
            .catch(err => console.error(err))
        }
      }
    },
    computed: {
      readyToSave() {
        return (
          this.DV_task && 
          this.DV_task.text.trim() !== ''
        );
      }
    },
    watch: {
      facility: {
        handler: function(value) {
          this.DV_task = value
        },
        deep: true
      }
    }
  }  
</script>

<style lang="scss" scoped>
</style>
