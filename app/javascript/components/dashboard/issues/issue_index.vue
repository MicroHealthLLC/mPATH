<template>
  <div v-if="!loading" class="mt-4">
    <div v-if="newIssue">
      <button
        class="btn btn-sm btn-link float-right"
        style="margin-top:-20px"
        @click.prevent.stop="newIssue=false"
        >
        back
      </button>
      <issue-form
        :facility="facility"
        :issue="currentIssue"
        :issue-types="issueTypes"
        :issue-severities="issueSeverities"
        @issue-created="issueCreated"
        @issue-updated="issueUpdated"
        class="issue-form-modal"
      />
    </div>
    <div v-else>
      <div class="d-flex align-item-center justify-content-between">
        <div class="d-flex w-100">
          <div class="simple-select w-100 mr-2">
            <multiselect
              v-model="C_issueTypeFilter"
              track-by="name"
              label="name"
              placeholder="Filter by Issue Type"
              :options="issueTypes"
              :searchable="false"
              :multiple="true"
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
          <div class="simple-select w-100 mr-2">
            <multiselect
              v-model="C_issueSeverityFilter"
              track-by="name"
              label="name"
              placeholder="Filter by Issue Severity"
              :options="issueSeverities"
              :searchable="false"
              :multiple="true"
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
        </div>
        <button v-if="_isallowed('write')" class="new-issue-btn btn btn-sm btn-light" @click.prevent="reportNew">Add Issue</button>
      </div>
      <div class="m-3">
        <div class="form-check-inline">
          <label class="form-check-label">
            <input type="radio" class="form-check-input" v-model="viewList" value="active" name="listoption">Active
          </label>
        </div>
        <div class="form-check-inline">
          <label class="form-check-label">
            <input type="radio" class="form-check-input" v-model="viewList" value="completed" name="listoption">Completed
          </label>
        </div>
        <div class="form-check-inline">
          <label class="form-check-label">
            <input type="radio" class="form-check-input" v-model="viewList" name="listoption" value="all">All
          </label>
        </div>
      </div>
      <div class="mt-1">
        <hr>
        <div v-if="_isallowed('read')">
          <div v-if="filteredIssues.length > 0">
            <issue-show
              v-for="issue in filteredIssues"
              :key="issue.id"
              :issue="issue"
              :facility="facility"
              @issue-edited="issueEdited"
              @issue-deleted="issueDeleted"
            />
          </div>
          <p v-else class="text-danger ml-2">No issues found..</p>
        </div>
        <p v-else class="text-danger mx-2"> You don't have permissions to read!</p>
      </div>
    </div>
  </div>
</template>

<script>
  import http from './../../../common/http'
  import IssueForm from './issue_form'
  import IssueShow from './issue_show'
  import {mapGetters, mapMutations} from 'vuex'

  export default {
    name: 'ProjectShow',
    props: ['facility'],
    components: {IssueForm, IssueShow},

    data() {
      return {
        loading: true,
        newIssue: false,
        viewList: 'active',
        currentIssue: null
      }
    },
    mounted() {
      this.loading = false
    },
    methods: {
       ...mapMutations([
        'setIssueTypeFilter',
        'setIssueSeverityFilter'
      ]),
      issueCreated(issue) {
        this.facility.issues.unshift(issue)
        this.newIssue = false
        this.$emit('refresh-facility')
      },
      issueUpdated(issue) {
        var index = this.facility.issues.findIndex((t) => t.id == issue.id)
        this.facility.issues[index] = issue
        this.newIssue = false
        this.$emit('refresh-facility')
      },
      issueDeleted(issue) {
        http
          .delete(`/projects/${this.currentProject.id}/facilities/${this.facility.id}/issues/${issue.id}.json`)
          .then((res) => {
            var issues = [...this.facility.issues]
            _.remove(issues, (t) => t.id == issue.id)
            this.$emit('refresh-facility')
          })
          .catch((err) => console.log(err))
      },
      issueEdited(issue) {
        this.currentIssue = issue
        this.newIssue = true
      },
      reportNew() {
        this.currentIssue = null
        this.newIssue = true
      }
    },
    computed: {
      ...mapGetters([
        'currentProject',
        'issueTypes',
        'issueSeverities',
        'issueTypeFilter',
        'issueSeverityFilter'
      ]),
      _isallowed() {
        return salut => this.$currentUser.role == "superadmin" || this.$permissions.issues[salut]
      },
      filteredIssues() {
        var typeIds = _.map(this.C_issueTypeFilter, 'id')
        var severityIds = _.map(this.C_issueSeverityFilter, 'id')
        var issues = _.sortBy(_.filter(this.facility.issues, ((issue) => {
          let valid = Boolean(issue && issue.hasOwnProperty('progress'))
          if (typeIds.length > 0) valid = valid && typeIds.includes(issue.issueTypeId)
          if (severityIds.length > 0) valid = valid && severityIds.includes(issue.issueSeverityId)
          switch (this.viewList) {
            case "active": {
              valid = valid && issue.progress < 100
              break
            }
            case "completed": {
              valid = valid && issue.progress == 100
              break
            }
            default: {
              break
            }
          }
          return valid;
        })), ['dueDate'])

        return issues
      },
      C_issueTypeFilter: {
        get() {
          return this.issueTypeFilter
        },
        set(value) {
          this.setIssueTypeFilter(value)
        }
      },
      C_issueSeverityFilter: {
        get() {
          return this.issueSeverityFilter
        },
        set(value) {
          this.setIssueSeverityFilter(value)
        }
      },
    }
  }
</script>

<style lang="scss" scoped>
  .new-issue-btn {
    width: 20%;
    height: max-content;
  }
</style>
