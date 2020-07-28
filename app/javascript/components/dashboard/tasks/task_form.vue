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
      Please fill the required fields before submitting
    </div>
    <div class="form-group mx-4">
      <label class="font-sm">Name:</label>
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
      <label class="font-sm">Task Type:</label>
      <select
        name="Task Type"
        v-validate="'required'"
        :class="{'form-control': true, 'error': errors.has('Task Type') }" class="form-control form-control-sm"
        v-model="DV_task.taskTypeId"
        >
        <option disabled selected value="">Task Type</option>
        <option v-for="opt in taskTypes" :value="opt.id">
          {{opt.name}}
        </option>
      </select>
      <div v-show="errors.has('Task Type')" class="text-danger">
        {{ errors.first('Task Type') }}
      </div>
    </div>
    <div class="form-row mx-3">
      <div class="form-group col-md-6">
        <label class="font-sm">Start Date:</label>
        <v2-date-picker
          v-validate="'required'"
          v-model="DV_task.startDate"
          value-type="YYYY-MM-DD"
          format="DD MMM YYYY"
          placeholder="yyyy-mm-dd"
          name="Start Date"
          :disabled-date="disabledStartDate"
        />
        <div v-show="errors.has('Start Date')" class="text-danger">
          {{ errors.first('Start Date') }}
        </div>
      </div>
      <div class="form-group col-md-6">
        <label class="font-sm">Due Date:</label>
        <v2-date-picker
          v-validate="'required'"
          v-model="DV_task.dueDate"
          value-type="YYYY-MM-DD"
          format="DD MMM YYYY"
          placeholder="yyyy-mm-dd"
          name="Due Date"
          :disabled="DV_task.startDate === ''"
          :disabled-date="disabledDueDate"
        />
        <div v-show="errors.has('Due Date')" class="text-danger">
          {{ errors.first('Due Date') }}
        </div>
      </div>
    </div>
    <div class="form-group mx-4">
      <label class="font-sm mb-0">Progress: (in %)</label>
      <span class="ml-3">
        <label class="font-sm mb-0 d-inline-flex align-items-center"><input type="checkbox" v-model="DV_task.autoCalculate"><span>&nbsp;&nbsp;Auto Calculate Progress</span></label>
      </span>
      <vue-slide-bar
        v-model="DV_task.progress"
        :line-height="8"
        :draggable="!DV_task.autoCalculate"
      ></vue-slide-bar>
    </div>

    <div class="form-group mx-4">
      <label class="font-sm">Checklists:</label>
      <span class="ml-2 clickable" @click.prevent="addChecks"><i class="fas fa-plus-circle"></i></span>
      <div v-if="filteredChecks.length > 0">
        <div v-for="(check, index) in DV_task.checklists" class="d-flex w-104" v-if="!check._destroy">
          <label class="form-control" :key="index">
            <input type="checkbox" v-model="check.checked" :key="`check_${index}`">
            <input v-model="check.text" :key="`text_${index}`" placeholder="Check point" type="text" class="checklist-text">
          </label>
          <span class="del-check clickable" @click.prevent="destroyCheck(check, index)"><i class="fas fa-times-circle"></i></span>
        </div>
      </div>
      <p v-else class="text-danger font-sm">No checks..</p>
    </div>
    <div class="form-group mx-4">
      <label class="font-sm">Description:</label>
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
            <div class="input-group-text clickable" :class="{'btn-disabled': !file.uri}" @click.prevent="downloadFile(file)">
              <i class="fas fa-file-image"></i>
            </div>
          </div>
          <input
            readonly
            type="text"
            class="form-control form-control-sm"
            :value="file.name || file.uri"
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
      <label class="font-sm">Files:</label>
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
  import axios from 'axios'
  import humps from 'humps'
  import http from './../../../common/http'
  import AttachmentInput from './../../shared/attachment_input'

  export default {
    name: 'TaskForm',
    props: ['facility', 'project', 'task', 'title', 'taskTypes'],
    components: {AttachmentInput},
    data() {
      return {
        DV_task: {
          text: '',
          startDate: '',
          dueDate: '',
          taskTypeId: '',
          notes: '',
          progress: 0,
          autoCalculate: true,
          taskFiles: [],
          checklists: []
        },
        _ismounted: false,
        showErrors: false
      }
    },
    mounted() {
      if (this.task) {
        this.DV_task = _.cloneDeep(this.task)
        this.DV_task.taskFiles = []
        this.addFile(this.task.attachFiles)
      }
      this._ismounted = true
    },
    methods: {
      getDate(days=0) {
        var date = new Date
        date.setDate(date.getDate() + days)
        return date
      },
      addFile(files) {
        for (let file of files) {
          file.guid = this.guid()
          this.DV_task.taskFiles.push(file)
        }
        this.$forceUpdate()
      },
      deleteFile(file) {
        if (!file) return;
        var confirm = window.confirm(`Are you sure, you want to delete attachment?`)
        if (!confirm) return;

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
          formData.append('task[start_date]', this.DV_task.startDate)
          formData.append('task[task_type_id]', this.DV_task.taskTypeId)
          formData.append('task[progress]', this.DV_task.progress)
          formData.append('task[auto_calculate]', this.DV_task.autoCalculate)
          formData.append('task[notes]', this.DV_task.notes)

          for (var i in this.DV_task.checklists) {
            var check = this.DV_task.checklists[i]
            for (var key in check) {
              formData.append(`task[checklists_attributes][${i}][${key}]`, check[key])
            }
          }

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
      },
      addChecks() {
        this.DV_task.checklists.push({text: '', checked: false})
      },
      downloadFile(file) {
        let url = window.location.origin + file.uri
        window.open(url, '_blank');
      },
      destroyCheck(check, index) {
        var confirm = window.confirm(`Are you sure, you want to delete this checklist item?`)
        if (!confirm) return;

        var i = check.id ? this.DV_task.checklists.findIndex(c => c.id === check.id) : index
        Vue.set(this.DV_task.checklists, i, {...check, _destroy: true})
      },
      disabledStartDate(date) {
        date.setHours(0,0,0,0)
        const today = new Date()
        today.setHours(0,0,0,0)
        return date < today
      },
      disabledDueDate(date) {
        date.setHours(0,0,0,0)
        const startDate = new Date(this.DV_task.startDate)
        startDate.setHours(0,0,0,0)
        return date < startDate
      },
      calculateProgress(checks=null) {
        try {
          if (!checks) checks = this.DV_task.checklists
          var checked = _.filter(checks, v => !v._destroy && v.checked).length
          var total = _.filter(checks, v => !v._destroy).length
          this.DV_task.progress = Number((((checked / total) * 100) || 0).toFixed(2))
        } catch {
          this.DV_task.progress = 0
        }
      }
    },
    computed: {
      readyToSave() {
        return (
          this.DV_task &&
          this.DV_task.text !== '' &&
          this.DV_task.taskTypeId !== '' &&
          this.DV_task.dueDate !== '' &&
          this.DV_task.startDate !== ''
        )
      },
      filteredChecks() {
        return _.filter(this.DV_task.checklists, c => !c._destroy)
      }
    },
    watch: {
      task: {
        handler: function(value) {
          this.DV_task = _.cloneDeep(value)
        },
        deep: true
      },
      "DV_task.dueDate"(value) {
        if (this._ismounted && this.facility.dueDate) {
          if (moment(value).isAfter(this.facility.dueDate, 'day')) {
            confirm('Task Due Date is past Project Due Date!')
          }
        }
      },
      "DV_task.checklists": {
        handler: function(value) {
          if (this.DV_task.autoCalculate) this.calculateProgress(value)
        }, deep: true
      },
      "DV_task.autoCalculate"(value) {
        if (value) this.calculateProgress()
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
  .checklist-text {
    margin-left: 5px;
    border: 0;
    width: 92%;
    outline: none;
  }
  .del-check {
    position: relative;
    top: -5px;
    display: flex;
    right: 10px;
    background: #fff;
    height: fit-content;
    color: red;
  }
</style>
