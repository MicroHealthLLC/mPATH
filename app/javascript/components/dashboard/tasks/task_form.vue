<template>
  <form
    id="tasks-form"
    @submit.prevent="saveTask"
    class="mx-auto"
    accept-charset="UTF-8"
  >
    <h5 class="title d-flex justify-content-center">{{title}}</h5>
    <div
      v-if="showErrors"
      class="text-danger mb-3"
    >
      Please fill the required feilds before submitting
    </div>
    <div class="form-group mx-4">
      <label class="name">Name:</label>
      <input
        name="Name"
        v-validate="'required'"
        type="text"
        class="form-control form-control-sm"
        v-model="DV_task.text"
        placeholder="Text"
        :class="{'form-control': true, 'error': errors.has('Name') }"
      />
      <div v-show="errors.has('Name')" class="text-danger">
        {{ errors.first('Name') }}
      </div>
    </div>
    <div class="form-group mx-4">
      <label class="task-type">Task Type:</label>
      <select
        name="Task Type"
        v-validate="'required'"
        :class="{'form-control': true, 'error': errors.has('Task Type') }" class="form-control form-control-sm"
        v-model="DV_task.taskType"
      >
        <option disabled selected value="">Task Type</option>
        <option v-for="opt in taskTypes" :value="opt.value">
          {{opt.text}}
        </option>
      </select>
      <div v-show="errors.has('Task Type')" class="text-danger">
        {{ errors.first('Task Type') }}
      </div>
    </div>
    <div class="form-group mx-4">
      <label class="due-date">Due Date:</label>
      <input
        name="Due Date"
        :class="{'form-control': true, 'error': errors.has('Due Date') }"
        type="date"
        v-validate="'required'"
        class="form-control form-control-sm"
        v-model="DV_task.dueDate"
      />
      <div v-show="errors.has('Due Date')" class="text-danger">
        {{ errors.first('Due Date') }}
      </div>
    </div>
    <div class="form-group mx-4">
      <label class="due-date">Progress: (in %)</label>
      <input
        type="number"
        v-model="DV_task.progress"
        class="form-control"
        max="100"
        min="0"
      />
    </div>
    <div class="form-group mx-4">
      <label class="description">Description:</label>
      <textarea
        class="form-control"
        placeholder="task brief description"
        v-model="DV_task.notes"
        rows="4"
      />
    </div>
    <div class="mx-4">
      <div class="input-group mb-2">
        <div v-for="file in DV_task.taskFiles" class="d-flex mb-2 w-100">
          <div class="input-group-prepend">
            <div class="input-group-text">
              <i class="fas fa-file-image"></i>
            </div>
          </div>
          <input
            readonly
            type="text"
            class="form-control form-control-sm"
            :value="file.uri || file.name"
          />
          <button
            class="btn btn-danger btn-sm d-flex flex-row-reverse"
            @click.prevent="deleteFile(file)"
          >
            <i class="fas fa-times"></i>
          </button>
        </div>
      </div>
    </div>
    <div class="form-group mx-4" >
      <label class="files">Files:</label>
      <attachment-input
        @input="addFile"
        :show-label="true"
      />
    </div>
    <div class="d-flex form-group mt-4 ml-4">
      <button
        :disabled="!readyToSave"
        class="btn btn-success"
      >
        Save
      </button>
    </div>
  </form>
</template>

<script>
  import axios           from 'axios'
  import humps           from 'humps'
  import http            from './../../../common/http'
  import AttachmentInput from './../../shared/attachment_input'
  import utils           from './../../../mixins/utils'

  export default {
    name: 'TaskForm',
    props: ['facility', 'project', 'task', 'title'],
    components: {AttachmentInput},
    mixins: [utils],

    data() {
      return {
        DV_task: {
          text: '',
          dueDate: '',
          taskType: '',
          notes: '',
          progress: 0,
          taskFiles: []
        },
        showErrors: false,
        taskTypes: [
          { text: 'upgrade', value: 'upgrade' },
          { text: 'story', value: 'story' }
        ]
      }
    },
    mounted() {
      if (this.task) {
        this.DV_task = this.task
        this.DV_task.taskFiles = []
        this.addFile(this.task.attachFiles)
      }
    },
    methods: {
      addFile(files) {
        for (let file of files) {
          file.guid = this.guid()
          this.DV_task.taskFiles.push(file)
        }
        this.$forceUpdate()
      },
      deleteFile(file) {
        if (!file) { return; }

        if (file.uri) {
          http.put(`/projects/${this.project.id}/facilities/${this.facility.id}/tasks/${this.task.id}/destroy_file.json`, {file: file})
          .then((res)=> {
            _.remove(this.DV_task.taskFiles, (f) => f.guid === file.guid)
            this.$forceUpdate()
          })
          .catch((error) => {
            console.log("Unable to destroy the file..")
          })
        }
        else if (file.name) {
          _.remove(this.DV_task.taskFiles, (f) => f.guid === file.guid)
          this.$forceUpdate()
        }
      },
      saveTask() {
        this.$validator.validate().then((success) =>
        {
          if (!success) {
            this.showErrors = true
            return;
          }

          var formData = new FormData()
          formData.append('task[text]', this.DV_task.text)
          formData.append('task[due_date]', this.DV_task.dueDate)
          formData.append('task[task_type]', this.DV_task.taskType)
          formData.append('task[progress]', this.DV_task.progress)
          formData.append('task[notes]', this.DV_task.notes)

          for (var file of this.DV_task.taskFiles) {
            if (!file.id) {
              formData.append('task[task_files][]', file)
            }
          }

          var url = `/projects/${this.project.id}/facilities/${this.facility.id}/tasks.json`
          var method = "POST"
          var callback = "task-created"

          if (this.task && this.task.id) {
            url = `/projects/${this.project.id}/facilities/${this.facility.id}/tasks/${this.task.id}.json`
            method = "PUT"
            callback = "task-updated"
          }

          axios({
            method: method,
            url: url,
            data: formData,
            headers: {
              'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').attributes['content'].value
            }
          })
          .then((response)=> {
            this.$emit(callback, humps.camelizeKeys(response.data.task))
          })
          .catch((err)=> {
            console.log(err)
          })
        })
      }
    },
    computed: {
      readyToSave() {
        return (
          this.DV_task &&
          this.DV_task.text !== '' &&
          this.DV_task.taskType !== '' &&
          this.DV_task.dueDate !== ''
        )
      }
    },
    watch: {
      task: {
        handler: function(value) {
          this.DV_task = value
        },
        deep: true
      }
    }
  }
</script>

<style lang="scss" scoped>
  .form-control.error {
    border-color: #E84444;
  }
  .title {
    font-size: 15px;
    margin-left: 65px;
  }
  .name,
  .task-type,
  .due-date,
  .description,
  .files {
    font-size: 13px;
  }
</style>
