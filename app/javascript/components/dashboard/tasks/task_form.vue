<template>
  <div>
    <form
      id="tasks-form"
      @submit.prevent="saveTask"
      class="mx-auto"
      :class="{'_disabled': loading}"
      accept-charset="UTF-8"
      >
      <h5 class="text-center mb-2">{{title}}</h5>
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
          placeholder="Task Name"
          :class="{'form-control': true, 'error': errors.has('Name') }"
        />
        <div v-show="errors.has('Name')" class="text-danger">
          {{errors.first('Name')}}
        </div>
      </div>
      <div class="simple-select form-group mx-4">
        <label class="font-sm">Milestone:</label>
        <multiselect
          v-model="selectedTaskType"
          v-validate="'required'"
          track-by="id"
          label="name"
          placeholder="Select milestone"
          :options="taskTypes"
          :searchable="false"
          select-label="Select"
          deselect-label="Remove"
          >
          <template slot="singleLabel" slot-scope="{option}">
            <div class="d-flex">
              <span class='select__tag-name'>{{option.name}}</span>
            </div>
          </template>
        </multiselect>
      </div>
      <div class="form-row mx-4">
        <div class="form-group col-md-6 pl-0">
          <label class="font-sm">Start Date:</label>
          <v2-date-picker
            v-validate="'required'"
            v-model="DV_task.startDate"
            value-type="YYYY-MM-DD"
            format="DD MMM YYYY"
            placeholder="DD MM YYYY"
            name="Start Date"
            class="w-100 vue2-datepicker"
            :disabled-date="disabledStartDate"
          />
          <div v-show="errors.has('Start Date')" class="text-danger">
            {{errors.first('Start Date')}}
          </div>
        </div>
        <div class="form-group col-md-6 pr-0">
          <label class="font-sm">Due Date:</label>
          <v2-date-picker
            v-validate="'required'"
            v-model="DV_task.dueDate"
            value-type="YYYY-MM-DD"
            format="DD MMM YYYY"
            placeholder="DD MM YYYY"
            name="Due Date"
            class="w-100 vue2-datepicker"
            :disabled="DV_task.startDate === '' || DV_task.startDate === null"
            :disabled-date="disabledDueDate"
          />
          <div v-show="errors.has('Due Date')" class="text-danger">
            {{errors.first('Due Date')}}
          </div>
        </div>
      </div>
      <div class="form-group user-select mx-4">
        <label class="font-sm mb-0">Assign Users:</label>
        <multiselect
          v-model="taskUsers"
          track-by="id"
          label="fullName"
          placeholder="Search and select users"
          :options="projectUsers"
          :searchable="true"
          :multiple="true"
          select-label="Select"
          deselect-label="Remove"
          :close-on-select="false"
          >
          <template slot="singleLabel" slot-scope="{option}">
            <div class="d-flex">
              <span class='select__tag-name'>{{option.fullName}}</span>
            </div>
          </template>
        </multiselect>
      </div>
      <div class="form-group mx-4">
        <label class="font-sm mb-0">Progress: (in %)</label>
        <span class="ml-3">
          <label class="font-sm mb-0 d-inline-flex align-items-center"><input type="checkbox" v-model="DV_task.autoCalculate"><span>&nbsp;&nbsp;Auto Calculate Progress</span></label>
        </span>
        <vue-slide-bar
          v-model="DV_task.progress"
          :line-height="8"
          :is-disabled="DV_task.autoCalculate"
          :draggable="!DV_task.autoCalculate"
        ></vue-slide-bar>
      </div>
      <div class="form-group mx-4">
        <label class="font-sm">Checklists:</label>
        <span class="ml-2 clickable" @click.prevent="addChecks">
          <i class="fas fa-plus-circle"></i>
        </span>
        <div v-if="filteredChecks.length > 0">
          <div v-for="(check, index) in DV_task.checklists" class="d-flex w-104 mb-3" v-if="!check._destroy && isMyCheck(check)">
            <div class="form-control h-100" :key="index">
              <input type="checkbox" name="check" :checked="check.checked" @change="updateCheckItem($event, 'check', index)" :key="`check_${index}`" :disabled="!check.text.trim()">
              <input :value="check.text" name="text" @input="updateCheckItem($event, 'text', index)" :key="`text_${index}`" placeholder="Check point" type="text" class="checklist-text">
              <div class="simple-select form-group m-0">
                <label class="font-sm">Assigned To:</label>
                <multiselect
                  v-model="check.user"
                  track-by="id"
                  label="fullName"
                  placeholder="Search and select users"
                  :options="projectUsers"
                  :searchable="true"
                  :disabled="!check.text"
                  select-label="Select"
                  deselect-label="Remove"
                  >
                  <template slot="singleLabel" slot-scope="{option}">
                    <div class="d-flex">
                      <span class='select__tag-name'>{{option.fullName}}</span>
                    </div>
                  </template>
                </multiselect>
              </div>
            </div>
            <span class="del-check clickable" @click.prevent="destroyCheck(check, index)">
              <i class="fas fa-times"></i>
            </span>
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
          <div v-for="file in filteredFiles" class="d-flex mb-2 w-100">
            <div class="input-group-prepend">
              <div class="input-group-text clickable" :class="{'btn-disabled': !file.uri}" @click.prevent="downloadFile(file)">
                <i class="fas fa-file-image"></i>
              </div>
            </div>
            <input
              readonly
              type="text"
              class="form-control form-control-sm mw-95"
              :value="file.name || file.uri"
            />
            <div
              :class="{'_disabled': loading}"
              class="del-check clickable"
              @click.prevent="deleteFile(file)"
              >
              <i class="fas fa-times"></i>
            </div>
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
    <div v-if="loading" class="load-spinner spinner-border text-dark" role="status"></div>
  </div>
</template>

<script>
  import axios from 'axios'
  import humps from 'humps'
  import AttachmentInput from './../../shared/attachment_input'
  import {mapGetters} from 'vuex'

  export default {
    name: 'TaskForm',
    props: ['facility', 'task', 'title'],
    components: {AttachmentInput},
    data() {
      return {
        DV_task: {
          text: '',
          startDate: '',
          dueDate: '',
          taskTypeId: '',
          userIds: [],
          notes: '',
          progress: 0,
          autoCalculate: true,
          taskFiles: [],
          checklists: []
        },
        destroyedFiles: [],
        selectedTaskType: null,
        taskUsers: [],
        _ismounted: false,
        showErrors: false,
        loading: true
      }
    },
    mounted() {
      if (this.task) {
        this.DV_task = {...this.DV_task, ..._.cloneDeep(this.task)}
        this.taskUsers = _.filter(this.projectUsers, u => this.DV_task.userIds.includes(u.id))
        this.selectedTaskType = this.taskTypes.find(t => t.id === this.DV_task.taskTypeId)
        this.addFile(this.task.attachFiles)
      }
      this.loading = false
      this._ismounted = true
    },
    methods: {
      addFile(files) {
        let _files = [...this.DV_task.taskFiles]
        for (let file of files) {
          file.guid = this.guid()
          _files.push(file)
        }
        this.DV_task.taskFiles = _files
      },
      deleteFile(file) {
        if (!file) return;
        var confirm = window.confirm(`Are you sure, you want to delete attachment?`)
        if (!confirm) return;

        if (file.uri) {
          var index = this.DV_task.taskFiles.findIndex(f => f.guid === file.guid)
          Vue.set(this.DV_task.taskFiles, index, {...file, _destroy: true})
          this.destroyedFiles.push(file)
        }
        else if (file.name) {
          this.DV_task.taskFiles.splice(this.DV_task.taskFiles.findIndex(f => f.guid === file.guid), 1)
        }
      },
      saveTask() {
        this.$validator.validate().then((success) =>
        {
          if (!success || this.loading) {
            this.showErrors = !success
            return;
          }

          this.loading = true
          var formData = new FormData()
          formData.append('task[text]', this.DV_task.text)
          formData.append('task[due_date]', this.DV_task.dueDate)
          formData.append('task[start_date]', this.DV_task.startDate)
          formData.append('task[task_type_id]', this.DV_task.taskTypeId)
          formData.append('task[progress]', this.DV_task.progress)
          formData.append('task[auto_calculate]', this.DV_task.autoCalculate)
          formData.append('task[notes]', this.DV_task.notes)
          formData.append('task[destroy_file_ids]', _.map(this.destroyedFiles, 'id'))

          if (this.DV_task.userIds.length) {
            for (var u_id of this.DV_task.userIds) {
              formData.append('task[user_ids][]', u_id)
            }
          }
          else {
            formData.append('issue[user_ids][]', [])
          }

          for (var i in this.DV_task.checklists) {
            var check = this.DV_task.checklists[i]
            if (!check.text && !check._destroy) continue
            for (var key in check) {
              if (key === 'user') key = 'user_id'
              var value = key == 'user_id' ? check.user ? check.user.id : null : check[key]
              formData.append(`task[checklists_attributes][${i}][${key}]`, value)
            }
          }

          for (var file of this.DV_task.taskFiles) {
            if (!file.id) {
              formData.append('task[task_files][]', file)
            }
          }

          var url = `/projects/${this.currentProject.id}/facilities/${this.facility.id}/tasks.json`
          var method = "POST"
          var callback = "task-created"

          if (this.task && this.task.id) {
            url = `/projects/${this.currentProject.id}/facilities/${this.facility.id}/tasks/${this.task.id}.json`
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
          .then((response) => {
            this.$emit(callback, humps.camelizeKeys(response.data.task))
          })
          .catch((err) => {
            console.log(err)
          })
          .finally(() => {
            this.loading = false
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
          var checked = _.filter(checks, v => !v._destroy && v.checked && v.text.trim()).length
          var total = _.filter(checks, v => !v._destroy && v.text.trim()).length
          this.DV_task.progress = Number((((checked / total) * 100) || 0).toFixed(2))
        } catch(err) {
          this.DV_task.progress = 0
        }
      },
      updateCheckItem(event, name, index) {
        if (name === 'text') {
          this.DV_task.checklists[index].text = event.target.value
          if (!event.target.value) this.DV_task.checklists[index].checked = false
        } else if (name === 'check' && this.DV_task.checklists[index].text) {
          this.DV_task.checklists[index].checked = event.target.checked
        }
      },
      isMyCheck(check) {
        return this.C_myTasks && check.id ? check.user.id == this.$currentUser.id : true
      }
    },
    computed: {
      ...mapGetters([
        'currentProject',
        'taskTypes',
        'projectUsers',
        'myActionsFilter'
      ]),
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
      },
      filteredFiles() {
        return _.filter(this.DV_task.taskFiles, f => !f._destroy)
      },
      C_myTasks() {
        return _.map(this.myActionsFilter, 'value').includes('tasks')
      }
    },
    watch: {
      task: {
        handler: function(value) {
          this.DV_task = {...this.DV_task, ..._.cloneDeep(value)}
          this.destroyedFiles = []
        },
        deep: true
      },
      "DV_task.startDate"(value) {
        if (this._ismounted && !value) this.DV_task.dueDate = ''
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
      },
      taskUsers: {
        handler: function(value) {
          if (value) this.DV_task.userIds = _.uniq(_.map(value, 'id'))
        }, deep: true
      },
      selectedTaskType: {
        handler: function(value) {
          this.DV_task.taskTypeId = value ? value.id : null
        }, deep: true
      }
    }
  }
</script>

<style lang="scss" scoped>
  .form-control.error {
    border-color: #E84444;
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
