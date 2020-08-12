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
    <div class="simple-select form-group mx-4">
      <label class="font-sm">Issue Type:</label>
      <multiselect
        v-model="selectedIssueType"
        v-validate="'required'"
        track-by="id"
        label="name"
        placeholder="Issue Type"
        :options="issueTypes"
        :searchable="false"
        select-label="Select"
        deselect-label="Remove"
        :class="{'error': errors.has('Issue Type')}"
        >
        <template slot="singleLabel" slot-scope="{option}">
          <div class="d-flex">
            <span class='select__tag-name'>{{option.name}}</span>
          </div>
        </template>
      </multiselect>
      <div v-show="errors.has('Issue Type')" class="text-danger">
        {{ errors.first('Issue Type') }}
      </div>
    </div>
    <div class="simple-select form-group mx-4">
      <label class="font-sm">Issue Severity:</label>
      <multiselect
        v-model="selectedIssueSeverity"
        v-validate="'required'"
        track-by="id"
        label="name"
        placeholder="Issue Severity"
        :options="issueSeverities"
        :searchable="false"
        select-label="Select"
        deselect-label="Remove"
        :class="{'error': errors.has('Issue Severity')}"
        >
        <template slot="singleLabel" slot-scope="{option}">
          <div class="d-flex">
            <span class='select__tag-name'>{{option.name}}</span>
          </div>
        </template>
      </multiselect>
      <div v-show="errors.has('Issue Severity')" class="text-danger">
        {{ errors.first('Issue Severity') }}
      </div>
    </div>
    <div class="form-row mx-4">
      <div class="form-group col-md-6 pl-0">
        <label class="font-sm">Start Date:</label>
        <v2-date-picker
          v-validate="'required'"
          v-model="DV_issue.startDate"
          value-type="YYYY-MM-DD"
          format="DD MMM YYYY"
          placeholder="DD MM YYYY"
          name="Start Date"
          class="w-100 vue2-datepicker"
          :disabled-date="disabledStartDate"
        />
        <div v-show="errors.has('Start Date')" class="text-danger">
          {{ errors.first('Start Date') }}
        </div>
      </div>
      <div class="form-group col-md-6 pr-0">
        <label class="font-sm">Due Date:</label>
        <v2-date-picker
          v-validate="'required'"
          v-model="DV_issue.dueDate"
          value-type="YYYY-MM-DD"
          format="DD MMM YYYY"
          placeholder="DD MM YYYY"
          name="Due Date"
          class="w-100 vue2-datepicker"
          :disabled="DV_issue.startDate === ''"
          :disabled-date="disabledDueDate"
        />
        <div v-show="errors.has('Due Date')" class="text-danger">
          {{ errors.first('Due Date') }}
        </div>
      </div>
    </div>
    <div class="form-group user-select mx-4">
      <label class="font-sm mb-0">Assign Users:</label>
      <multiselect
        v-model="issueUsers"
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
        <label class="font-sm mb-0 d-inline-flex align-items-center"><input type="checkbox" v-model="DV_issue.autoCalculate"><span>&nbsp;&nbsp;Auto Calculate Progress</span></label>
      </span>
      <vue-slide-bar
        v-model="DV_issue.progress"
        :line-height="8"
        :is-disabled="DV_issue.autoCalculate"
        :draggable="!DV_issue.autoCalculate"
      ></vue-slide-bar>
    </div>
    <div class="form-group mx-4">
      <label class="font-sm">Checklists:</label>
      <span class="ml-2 clickable" @click.prevent="addChecks"><i class="fas fa-plus-circle"></i></span>
      <div v-if="filteredChecks.length > 0">
        <div v-for="(check, index) in DV_issue.checklists" class="d-flex w-104" v-if="!check._destroy">
          <label class="form-control" :key="index">
            <input type="checkbox" name="check" :checked="check.checked" @change="updateCheckItem($event, 'check', index)" :key="`check_${index}`" :disabled="!check.text.trim()">
            <input :value="check.text" name="text" @input="updateCheckItem($event, 'text', index)" :key="`text_${index}`" placeholder="Check point" type="text" class="checklist-text">
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
  import {mapGetters} from 'vuex'

  export default {
    name: 'IssueForm',
    props: ['facility', 'issue', 'title', 'issueTypes', 'issueSeverities'],
    components: {AttachmentInput},
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
          autoCalculate: true,
          userIds: [],
          issueFiles: [],
          checklists: []
        },
        selectedIssueType: null,
        selectedIssueSeverity: null,
        issueUsers: [],
        showErrors: false
      }
    },
    mounted() {
      if (this.issue) {
        this.DV_issue = {...this.DV_issue, ..._.cloneDeep(this.issue)}
        this.issueUsers = _.filter(this.projectUsers, u => this.DV_issue.userIds.includes(u.id))
        this.selectedIssueType = this.issueTypes.find(t => t.id === this.DV_issue.issueTypeId)
        this.selectedIssueSeverity = this.issueSeverities.find(t => t.id === this.DV_issue.issueSeverityId)
        this.addFile(this.issue.attachFiles)
      }
    },
    methods: {
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
          http.put(`/projects/${this.currentProject.id}/facilities/${this.facility.id}/issues/${this.issue.id}/destroy_file.json`, {file: file})
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
          formData.append('issue[auto_calculate]', this.DV_issue.autoCalculate)

          for (var u_id of this.DV_issue.userIds) {
            formData.append('issue[user_ids][]', u_id)
          }

          for (var i in this.DV_issue.checklists) {
            var check = this.DV_issue.checklists[i]
            for (var key in check) {
              formData.append(`issue[checklists_attributes][${i}][${key}]`, check[key])
            }
          }

          for (var file of this.DV_issue.issueFiles) {
            if (!file.id) {
              formData.append('issue[issue_files][]', file)
            }
          }

          var url = `/projects/${this.currentProject.id}/facilities/${this.facility.id}/issues.json`
          var method = "POST"
          var callback = "issue-created"

          if (this.issue && this.issue.id) {
            url = `/projects/${this.currentProject.id}/facilities/${this.facility.id}/issues/${this.issue.id}.json`
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
        date.setHours(0,0,0,0)
        const today = new Date()
        today.setHours(0,0,0,0)
        return date < today
      },
      disabledDueDate(date) {
        date.setHours(0,0,0,0)
        const startDate = new Date(this.DV_issue.startDate)
        startDate.setHours(0,0,0,0)
        return date < startDate
      },
      addChecks() {
        this.DV_issue.checklists.push({text: '', checked: false})
      },
      destroyCheck(check, index) {
        var confirm = window.confirm(`Are you sure, you want to delete this checklist item?`)
        if (!confirm) return;

        var i = check.id ? this.DV_issue.checklists.findIndex(c => c.id === check.id) : index
        Vue.set(this.DV_issue.checklists, i, {...check, _destroy: true})
      },
      calculateProgress(checks=null) {
        try {
          if (!checks) checks = this.DV_issue.checklists
          var checked = _.filter(checks, v => !v._destroy && v.checked && v.text.trim()).length
          var total = _.filter(checks, v => !v._destroy && v.text.trim()).length
          this.DV_issue.progress = Number((((checked / total) * 100) || 0).toFixed(2))
        } catch {
          this.DV_issue.progress = 0
        }
      },
      updateCheckItem(event, name, index) {
        if (name === 'text') {
          this.DV_issue.checklists[index].text = event.target.value
          if (!event.target.value) this.DV_issue.checklists[index].checked = false
        } else if (name === 'check' && this.DV_issue.checklists[index].text) {
          this.DV_issue.checklists[index].checked = event.target.checked
        }
      }
    },
    computed: {
      ...mapGetters([
        'currentProject',
        'projectUsers'
      ]),
      readyToSave() {
        return (
          this.DV_issue &&
          this.DV_issue.title !== '' &&
          this.DV_issue.issueTypeId !== '' &&
          this.DV_issue.issueSeverityId !== '' &&
          this.DV_issue.dueDate !== '' &&
          this.DV_issue.startDate !== ''
        )
      },
      filteredChecks() {
        return _.filter(this.DV_issue.checklists, c => !c._destroy)
      }
    },
    watch: {
      issue: {
        handler: function(value) {
          this.DV_issue = {...this.DV_issue, ..._.cloneDeep(value)}
        },
        deep: true
      },
      "DV_issue.checklists": {
        handler: function(value) {
          if (this.DV_issue.autoCalculate) this.calculateProgress(value)
        }, deep: true
      },
      "DV_issue.autoCalculate"(value) {
        if (value) this.calculateProgress()
      },
      issueUsers: {
        handler: function(value) {
          if (value) this.DV_issue.userIds = _.uniq(_.map(value, 'id'))
        }, deep: true
      },
      selectedIssueType: {
        handler(value) {
          this.DV_issue.issueTypeId = value ? value.id : null
        }, deep: true
      },
      selectedIssueSeverity: {
        handler(value) {
          this.DV_issue.issueSeverityId = value ? value.id : null
        }, deep: true
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
