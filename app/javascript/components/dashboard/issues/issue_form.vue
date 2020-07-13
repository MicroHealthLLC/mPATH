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
        placeholder="Title"
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
    <div class="form-group mx-4">
      <label class="font-sm">Issue Severity:</label>
      <select
        name="Issue Severity"
        v-validate="'required'"
        :class="{'form-control': true, 'error': errors.has('Issue Severity') }" class="form-control form-control-sm"
        v-model="DV_issue.issueSeverityId"
        >
        <option disabled selected value="">Issue Severity</option>
        <option v-for="opt in issueSeverities" :value="opt.id">
          {{opt.name}}
        </option>
      </select>
      <div v-show="errors.has('Issue Severity')" class="text-danger">
        {{ errors.first('Issue Severity') }}
      </div>
    </div>
    <div class="form-group mx-4">
      <label class="font-sm mb-0">Progress: (in %)</label>
      <vue-slide-bar
        v-model="DV_issue.progress"
        :line-height="8"
      />
    </div>
    <div class="form-row mx-3">
      <div class="form-group col-md-6">
        <label class="font-sm">Start Date:</label>
        <v2-date-picker
          v-validate="'required'"
          v-model="DV_issue.startDate"
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
          v-model="DV_issue.dueDate"
          value-type="YYYY-MM-DD"
          format="DD MMM YYYY"
          placeholder="yyyy-mm-dd"
          name="Due Date"
          :disabled="DV_issue.startDate === ''"
          :disabled-date="disabledDueDate"
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
        placeholder="issue brief description"
        v-model="DV_issue.description"
        rows="4"
      />
    </div>
    <div class="mx-4">
      <div class="input-group mb-2">
        <div v-for="file in DV_issue.issueFiles" class="d-flex mb-2 w-100">
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
  import utils from './../../../mixins/utils'

  export default {
    name: 'TaskForm',
    props: ['facility', 'project', 'issue', 'title', 'issueTypes', 'issueSeverities'],
    components: {AttachmentInput},
    mixins: [utils],

    data() {
      return {
        DV_issue: {
          title: '',
          startDate: '',
          dueDate: '',
          issueTypeId: '',
          progress: 0,
          issueSeverityId: '',
          description: '',
          issueFiles: []
        },
        showErrors: false
      }
    },
    mounted() {
      if (this.issue) {
        this.DV_issue = _.cloneDeep(this.issue)
        this.DV_issue.issueFiles = []
        this.addFile(this.issue.attachFiles)
      }
    },
    methods: {
      getDate(days=0) {
        var date = new Date
        date.setDate(date.getDate() + days)
        return date
      },
      addFile(files=[]) {
        for (let file of files) {
          file.guid = this.guid()
          this.DV_issue.issueFiles.push(file)
        }
        this.$forceUpdate()
      },
      deleteFile(file) {
        if (!file) return;
        var confirm = window.confirm(`Are you sure, you want to delete attachment?`)
        if (!confirm) return;

        if (file.uri) {
          http.put(`/projects/${this.$route.params.projectId}/facilities/${this.facility.id}/issues/${this.issue.id}/destroy_file.json`, {file: file})
          .then((res)=> {
            _.remove(this.DV_issue.issueFiles, (f) => f.guid === file.guid)
            this.$forceUpdate()
          })
          .catch((error) => {
            console.log("Unable to destroy the file..")
          })
        }
        else if (file.name) {
          _.remove(this.DV_issue.issueFiles, (f) => f.guid === file.guid)
          this.$forceUpdate()
        }
      },
      saveIssue() {
        this.$validator.validate().then((success) => {
          if (!success) {
            this.showErrors = true
            return;
          }

          var formData = new FormData()
          formData.append('issue[title]', this.DV_issue.title)
          formData.append('issue[due_date]', this.DV_issue.dueDate)
          formData.append('issue[start_date]', this.DV_issue.startDate)
          formData.append('issue[issue_type_id]', this.DV_issue.issueTypeId)
          formData.append('issue[issue_severity_id]', this.DV_issue.issueSeverityId)
          formData.append('issue[progress]', this.DV_issue.progress)
          formData.append('issue[description]', this.DV_issue.description)

          for (var file of this.DV_issue.issueFiles) {
            if (!file.id) {
              formData.append('issue[issue_files][]', file)
            }
          }

          var url = `/projects/${this.$route.params.projectId}/facilities/${this.facility.id}/issues.json`
          var method = "POST"
          var callback = "issue-created"

          if (this.issue && this.issue.id) {
            url = `/projects/${this.$route.params.projectId}/facilities/${this.facility.id}/issues/${this.issue.id}.json`
            method = "PUT"
            callback = "issue-updated"
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
            this.$emit(callback, humps.camelizeKeys(response.data.issue))
          })
          .catch((err)=> {
            console.log(err)
          })
        })
      },
      downloadFile(file) {
        let url = window.location.origin + file.uri
        window.open(url, '_blank');
      },
      disabledStartDate(date) {
        const today = new Date()
        today.setHours(0,0,0,0)
        return date < today
      },
      disabledDueDate(date) {
        const startDate = new Date(this.DV_issue.startDate)
        startDate.setHours(0,0,0,0)
        return date < startDate
      }
    },
    computed: {
      readyToSave() {
        return (
          this.DV_issue &&
          this.DV_issue.title !== '' &&
          this.DV_issue.issueTypeId !== '' &&
          this.DV_issue.issueSeverityId !== '' &&
          this.DV_issue.dueDate !== '' &&
          this.DV_issue.startDate !== ''
        )
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
</style>
