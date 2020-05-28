<template>
  <form
    id="issues-form"
    @submit.prevent="saveIssue"
    class="mx-auto"
    accept-charset="UTF-8"
    >
    <div
      v-if="showErrors"
      class="text-danger mb-3"
      >
      Please fill the required feilds before submitting
    </div>
    <div class="form-group mx-4">
      <label class="font-sm">Title:</label>
      <input
        name="title"
        v-validate="'required'"
        type="text"
        class="form-control form-control-sm"
        v-model="DV_issue.title"
        placeholder="Text"
        :class="{'form-control': true, 'error': errors.has('title') }"
      />
      <div v-show="errors.has('title')" class="text-danger">
        {{ errors.first('title') }}
      </div>
    </div>
    <div class="form-group mx-4">
      <label class="font-sm">Issue Type:</label>
      <select
        name="Issue Type"
        v-validate="'required'"
        :class="{'form-control': true, 'error': errors.has('Issue Type') }" class="form-control form-control-sm"
        v-model="DV_issue.issueTypeId"
        >
        <option disabled selected value="">Issue Type</option>
        <option v-for="opt in issueTypes" :value="opt.id">
          {{opt.name}}
        </option>
      </select>
      <div v-show="errors.has('Issue Type')" class="text-danger">
        {{ errors.first('Issue Type') }}
      </div>
    </div>
    <div class="form-row mx-3">
      <div class="form-group col-md-6">
        <label class="font-sm">Start Date:</label>
        <date-picker
          v-validate="'required'"
          input-class="form-control form-control-sm"
          v-model="DV_issue.startDate"
          :disabled-dates="disabledStartDates"
          placeholder="Start Date"
          name="Start Date"
        />
        <div v-show="errors.has('Start Date')" class="text-danger">
          {{ errors.first('Start Date') }}
        </div>
      </div>
      <div class="form-group col-md-6">
        <label class="font-sm">Due Date:</label>
        <date-picker
          v-validate="'required'"
          input-class="form-control form-control-sm"
          v-model="DV_issue.dueDate"
          :disabled-dates="disabledDueDates"
          placeholder="Due date"
          name="Due Date"
          :disabled="DV_issue.startDate === ''"
        />
        <div v-show="errors.has('Due Date')" class="text-danger">
          {{ errors.first('Due Date') }}
        </div>
      </div>
    </div>
    <div class="form-group mx-4">
      <label class="font-sm">Description:</label>
      <textarea
        class="form-control"
        placeholder="task brief description"
        v-model="DV_issue.description"
        rows="4"
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
    props: ['facility', 'project', 'issue', 'title', 'issueTypes', 'issueStatuses', 'issueSeverities'],
    components: {AttachmentInput},
    mixins: [utils],

    data() {
      return {
        DV_issue: {
          title: '',
          startDate: '',
          dueDate: '',
          issueTypeId: '',
          issueStatusId: '',
          issueSeverityId: '',
          description: ''
        },
        showErrors: false
      }
    },
    mounted() {
      if (this.issue) {
        this.DV_issue = this.issue
        this.DV_issue.dueDate = new Date(this.issue.dueDate)
        this.DV_issue.startDate = new Date(this.issue.startDate)
      }
    },
    methods: {
      getDate(days=0) {
        var date = new Date
        date.setDate(date.getDate() + days)
        return date
      },
      saveIssue() {
        debugger
        return
        this.$validator.validate().then((success) =>
        {
          if (!success) {
            this.showErrors = true
            return;
          }

          var formData = new FormData()
          formData.append('task[text]', this.DV_issue.text)
          formData.append('task[due_date]', this.DV_issue.dueDate)
          formData.append('task[start_date]', this.DV_issue.startDate)
          formData.append('task[task_type_id]', this.DV_issue.taskTypeId)
          formData.append('task[progress]', this.DV_issue.progress)
          formData.append('task[notes]', this.DV_issue.notes)

          for (var file of this.DV_issue.taskFiles) {
            if (!file.id) {
              formData.append('task[task_files][]', file)
            }
          }

          var url = `/projects/${this.project.id}/facilities/${this.facility.id}/issues.json`
          var method = "POST"
          var callback = "task-created"

          if (this.task && this.task.id) {
            url = `/projects/${this.project.id}/facilities/${this.facility.id}/issues/${this.task.id}.json`
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
          this.DV_issue &&
          this.DV_issue.title !== '' &&
          this.DV_issue.issueTypeId !== '' &&
          this.DV_issue.issueStatusId !== '' &&
          this.DV_issue.issueSeverityId !== '' &&
          this.DV_issue.dueDate !== '' &&
          this.DV_issue.startDate !== ''
        )
      },
      disabledStartDates() {
        return { to: this.getDate(-1) }
      },
      disabledDueDates() {
        return { to: new Date(this.DV_issue.startDate) }
      }
    },
    watch: {
      issue: {
        handler: function(value) {
          this.DV_issue = value
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
  .vdp-datepicker /deep/ {
    .form-control[readonly] {
      background-color: unset;
    }
    .vdp-datepicker__calendar {
      width: 100%;
    }
    .vdp-datepicker__calendar .cell {
      height: unset;
      line-height: unset;
    }
  }
</style>
