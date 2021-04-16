<template>
  <div>
    <form
      id="lesson-form"
      @submit.prevent="saveLesson"
      class="mx-auto tasks-form"
      accept-charset="UTF-8"
      :class="{'fixed-form-mapView':isMapView, _disabled: loading, 'kanban-form':isKanbanView }"
    >
      This is form
    </form>
  </div>
</template>

<script>
  import axios from 'axios'
  import Draggable from "vuedraggable"
  import FormTabs from './../../shared/FormTabs'
  import humps from 'humps'
  import {mapGetters, mapMutations, mapActions} from 'vuex'
  import AttachmentInput from './../../shared/attachment_input'
  import * as Moment from 'moment'
  import {extendMoment} from 'moment-range'
  const moment = extendMoment(Moment)
  export default {
    name: 'LessonForm',
    props: ['facility', 'task', 'title', 'fixedStage'],
    components: {
      AttachmentInput, Draggable, FormTabs
    },
    data() {
      return {
        DV_task: this.INITIAL_TASK_STATE(),
        DV_facility: Object.assign({}, this.facility),
        paginate: ['filteredNotes'],
        destroyedFiles: [],
        editTimeLive:"",
        selectedTaskType: null,
        selectedTaskStage: null,
        responsibleUsers: null,
        accountableTaskUsers:null,
        consultedTaskUsers:[],
        informedTaskUsers:[],
        relatedIssues: [],
        relatedTasks: [],
        relatedRisks: [],
        editToggle: false,
        _ismounted: false,
        showErrors: false,
        loading: true,
        movingSlot: '',
        currentTab: 'tab1',
        tabs: [
          {
            label: "Task Info",
            key: "tab1",
            closable: false,
            form_fields: [
              "Task Name",
              "Description",
              "Start Date",
              "Category",
              "Stage",
              "Start Date",
              "Due Date",
            ],
          },
          {
            label: "Assignments",
            key: "tab2",
            closable: false,
            form_fields: ["Responsible", "Accountable", "Consulted", "Informed"],
          },
          {
            label: "Checklist",
            key: "tab3",
            closable: false,
            form_fields: ["Checklists"],
          },
          {
            label: "Files & Links",
            key: "tab4",
            closable: false,
            form_fields: ["Files"],
          },
          {
            label: "Related",
            key: "tab5",
            closable: false,
            form_fields: ["Related Tasks", "Related Issues", "Related Risks"],
          },
          {
            label: "Updates",
            key: "tab6",
            closable: false,
            form_fields: ["Progress", "Updates"],
          },
        ],
      }
    },
    mounted() {
      if (!_.isEmpty(this.task)) {
        this.loadTask(this.task)
      }else{
        this.loadTask(this.DV_task)
      }
      if (this.fixedStage) {
        this.selectedTaskStage = this.taskStages.find(t => t.id === this.fixedStage)
      }
      this.loading = false
      this._ismounted = true
     },
    methods: {
       ...mapMutations([
        'setTaskForManager',
        'updateTasksHash'
      ]),
      ...mapActions([
        'taskDeleted',
        'taskUpdated',
        'updateWatchedTasks'
      ]),
      INITIAL_TASK_STATE() {
        return {
          text: '',
          startDate: '',
          dueDate: '',
          facilityProjectId: this.facility.id,
          checklistDueDate: '',
          taskTypeId: '',
          taskStageId: '',
          responsibleUserIds: [],
          accountableUserIds:[],
          consultedUserIds:[],
          informedUserIds:[],
          subTaskIds: [],
          subIssueIds: [],
          subRiskIds: [],
          description: '',
          progress: 0,
          autoCalculate: true,
          taskFiles: [],
          checklists: [],
          notes: []
        }
      },
      log(e){
        // console.log("This is the taskStages: " + e)
      },
      selectedStage(item){    
        this.selectedTaskStage = item
      },  
      clearStages() {
        this.selectedTaskStage = null
        this.taskStageId = ""
      },
      urlShortener(str, length, ending) {
        if (length == null) {
          length = 70;
        }
        if (ending == null) {
          ending = '...';
        }
        if (str.length > length) {
          return str.substring(0, length - ending.length) + ending;
        } else {
          return str;
        }
      },
      scrollToChecklist(){
        this.$refs.addCheckItem.scrollIntoView({behavior: "smooth", block: "start", inline: "nearest"});
        this.DV_task.checklists.push({text: '', checked: false})
      },
      scrollToUpdates(){
        this.$refs.addUpdates.scrollIntoView({behavior: "smooth", block: "end", inline: "nearest"});
        this.DV_task.notes.unshift({body: '', user_id: '', guid: this.guid()})
      },
      handleMove(item) {
        this.movingSlot = item.relatedContext.component.$vnode.key
        return true
      },
      onChangeTab(tab) {
        this.currentTab = tab ? tab.key : 'tab1'
      },
      handleEnd(e, checklists){
        var cc = this.DV_task.checklists
        var count = 0
        for(var checklist of cc){
          checklist.position = count
          count++
        }
      },
      editProgress() {
       this.editToggle = !this.editToggle
       //this.editTimeLive = moment.format('DD MMM YYYY, h:mm a')

      },
      deleteTask() {
        let confirm = window.confirm(`Are you sure you want to delete "${this.DV_task.text}"?`)
        if (!confirm) {return}
        this.taskDeleted(this.DV_task)
        this.cancelSave()
      },
      progressListTitleText(progressList){
        if(!progressList.id) return;
        var date = moment(progressList.createdAt).format("MM/DD/YYYY")
        var time = moment(progressList.createdAt).format("hh:mm:ss a")
        return `${progressList.user.fullName} at ${date} ${time} `
      },
         // RACI USERS commented out out here.....Awaiting backend work
      loadTask(task) {
        this.DV_task = {...this.DV_task, ..._.cloneDeep(task)}
        this.responsibleUsers = _.filter(this.activeProjectUsers, u => this.DV_task.responsibleUserIds.includes(u.id))[0]
        this.accountableTaskUsers = _.filter(this.activeProjectUsers, u => this.DV_task.accountableUserIds.includes(u.id))[0]
        this.consultedTaskUsers = _.filter(this.activeProjectUsers, u => this.DV_task.consultedUserIds.includes(u.id))
        this.informedTaskUsers = _.filter(this.activeProjectUsers, u => this.DV_task.informedUserIds.includes(u.id))
        this.relatedIssues = _.filter(this.filteredIssues, u => this.DV_task.subIssueIds.includes(u.id))
        this.relatedTasks = _.filter(this.filteredTasks, u => this.DV_task.subTaskIds.includes(u.id))
        this.relatedRisks = _.filter(this.filteredRisks, u => this.DV_task.subRiskIds.includes(u.id))
        this.selectedTaskType = this.taskTypes.find(t => t.id === this.DV_task.taskTypeId)
        this.selectedTaskStage = this.taskStages.find(t => t.id === this.DV_task.taskStageId)
        this.selectedFacilityProject = this.getFacilityProjectOptions.find(t => t.id === this.DV_task.facilityProjectId)
        if (this.DV_task.attachFiles) this.addFile(this.DV_task.attachFiles, false)
        this.$nextTick(() => {
          this.errors.clear()
          this.$validator.reset()
        })
      },
      addFile(files, append = true) {
        let _files = append ? [...this.DV_task.taskFiles] : []
        for (let file of files) {
          file.guid = this.guid()
          _files.push(file)
        }
        this.DV_task.taskFiles = _files
      },
      deleteFile(file) {
        if (!file) return;
        let confirm = window.confirm(`Are you sure you want to delete attachment?`)
        if (!confirm) return;

        if (file.uri || file.link) {
          let index = this.DV_task.taskFiles.findIndex(f => f.guid === file.guid)
          if(file.id){
            Vue.set(this.DV_task.taskFiles, index, {...file, _destroy: true})
            this.destroyedFiles.push(file)
          }
          this.DV_task.taskFiles.splice(this.DV_task.taskFiles.findIndex(f => f.guid === file.guid), 1)
        }
        else if (file.name) {
          this.DV_task.taskFiles.splice(this.DV_task.taskFiles.findIndex(f => f.guid === file.guid), 1)
        }
      },
       toggleWatched() {
        if (this.DV_task.watched) {
          let confirm = window.confirm(`Are you sure, you want to remove this task from on-watch?`)
          if (!confirm) {return}
        }
          this.DV_task = {...this.DV_task, watched: !this.DV_task.watched}
          this.updateWatchedTasks(this.DV_task)
      },
      cancelSave() {
        this.$emit('on-close-form')
        this.setTaskForManager({key: 'task', value: null})
      },
      saveTask() {
        if (!this._isallowed('write')) return
        this.$validator.validate().then((success) =>
        {
          if (!success || this.loading) {
            this.showErrors = !success
            return;
          }
          this.editToggle = !this.editToggle
          this.loading = true
          let formData = new FormData()
          formData.append('task[text]', this.DV_task.text)
          formData.append('task[due_date]', this.DV_task.dueDate)
          formData.append('task[start_date]', this.DV_task.startDate)
          formData.append('task[task_type_id]', this.DV_task.taskTypeId)
          formData.append('task[task_stage_id]', this.DV_task.taskStageId)
          formData.append('task[progress]', this.DV_task.progress)
          formData.append('task[auto_calculate]', this.DV_task.autoCalculate)
          formData.append('task[description]', this.DV_task.description)
          formData.append('task[destroy_file_ids]', _.map(this.destroyedFiles, 'id'))
          // RACI USERS START HERE Awaiting backend work

          //Responsible USer Id
            //  formData.append('responsible_user_ids', this.DV_task.responsibleUserIds)
          if (this.DV_task.responsibleUserIds && this.DV_task.responsibleUserIds.length) {
            for (let u_id of this.DV_task.responsibleUserIds) {
              formData.append('responsible_user_ids[]', u_id)
            }
          }
          else {
            formData.append('responsible_user_ids[]', [])
          }
          // Accountable UserId
         if (this.DV_task.accountableUserIds && this.DV_task.accountableUserIds.length) {
            for (let u_id of this.DV_task.accountableUserIds) {
              formData.append('accountable_user_ids[]', u_id)
            }
          }
          else {
            formData.append('accountable_user_ids[]', [])
          }
          // Consulted UserId

          if (this.DV_task.consultedUserIds.length) {
            for (let u_id of this.DV_task.consultedUserIds) {
              formData.append('consulted_user_ids[]', u_id)
            }
          }
          else {
            formData.append('consulted_user_ids[]', [])
          }
          // Informed UserId

          if (this.DV_task.informedUserIds.length) {
            for (let u_id of this.DV_task.informedUserIds) {
              formData.append('informed_user_ids[]', u_id)
            }
          }
          else {
            formData.append('informed_user_ids[]', [])
          }
          // RACI USERS ABOVE THIS LINE  Awaiting backend work
          // More RACI Users in Computed section below
          if (this.DV_task.subTaskIds.length) {
            for (let u_id of this.DV_task.subTaskIds) {
              formData.append('task[sub_task_ids][]', u_id)
            }
          }
          else {
            formData.append('task[sub_task_ids][]', [])
          }
          if (this.DV_task.subIssueIds.length) {
            for (let u_id of this.DV_task.subIssueIds) {
              formData.append('task[sub_issue_ids][]', u_id)
            }
          }
          else {
            formData.append('task[sub_issue_ids][]', [])
          }
          if (this.DV_task.subRiskIds.length) {
            for (let u_id of this.DV_task.subRiskIds) {
              formData.append('task[sub_risk_ids][]', u_id)
            }
          }
          else {
            formData.append('task[sub_risk_ids][]', [])
          }
          for (let i in this.DV_task.checklists) {
            let check = this.DV_task.checklists[i]
            if (!check.text && !check._destroy) continue
            for (let key in check) {
              if (key === 'user') key = 'user_id'
              let value = key == 'user_id' ? check.user ? check.user.id : null : check[key]
              // if (key === "dueDate"){
              //   key = "due_date"
              // }
              key = humps.decamelize(key)
              if(['created_at', 'updated_at', 'progress_lists'].includes(key)) continue
              formData.append(`task[checklists_attributes][${i}][${key}]`, value)
              for (let pi in check.progressLists) {
                let progressList = check.progressLists[pi]
                if (!progressList.body && !progressList._destroy) continue
                for (let pkey in progressList) {
                  if (pkey === 'user') pkey = 'user_id'
                  let pvalue = pkey == 'user_id' ? progressList.user ? progressList.user.id : null : progressList[pkey]
                  pkey = humps.decamelize(pkey)
                  if(['created_at', 'updated_at'].includes(pkey)) continue
                  formData.append(`task[checklists_attributes][${i}][progress_lists_attributes][${pi}][${pkey}]`, pvalue)
                }
              }
            }
          }
          for (let i in this.DV_task.notes) {
            let note = this.DV_task.notes[i]
            if (!note.body && !note._destroy) continue
            for (let key in note) {
              let value = key == 'user_id' ? note.user_id ? note.user_id : this.$currentUser.id : note[key]
              formData.append(`task[notes_attributes][${i}][${key}]`, value)
            }
          }
          for (let file of this.DV_task.taskFiles) {
            if(file.id) continue
            if (!file.link) {
              formData.append('task[task_files][]', file)
            }else if(file.link){
              formData.append('file_links[]', file.name)
            }
          }
          let url = `/projects/${this.currentProject.id}/facilities/${this.$route.params.projectId}/tasks.json`
          let method = "POST"
          let callback = "task-created"
          if (this.task && this.task.id) {
            url = `/projects/${this.currentProject.id}/facilities/${this.task.facilityId}/tasks/${this.task.id}.json`
            method = "PUT"
            callback = "task-updated"
          }
          // var beforeSaveTask = this.task
          axios({
            method: method,
            url: url,
            data: formData,
            headers: {
              'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').attributes['content'].value
            }
          })
          .then((response) => {
            // if(beforeSaveTask.facilityId && beforeSaveTask.projectId )
            //   this.$emit(callback, humps.camelizeKeys(beforeSaveTask))
            var responseTask = humps.camelizeKeys(response.data.task)
            this.loadTask(responseTask)
            //this.$emit(callback, responseTask)
            this.updateTasksHash({task: responseTask})
            if (response.status === 200) {
              this.$message({
                message: `${response.data.task.text} was saved successfully.`,
                type: "success",
                showClose: true,
              });
            }
            //Route to newly created task form page
            if (this.$route.path.includes("sheet")) {
              this.$router.push(`/programs/${this.$route.params.programId}/sheet/projects/${this.$route.params.projectId}/tasks/${response.data.task.id}`);
            } else if (this.$route.path.includes("map")) {
              this.$router.push(`/programs/${this.$route.params.programId}/map/projects/${this.$route.params.projectId}/tasks/${response.data.task.id}`);
            } else {
              this.$router.push(`/programs/${this.$route.params.programId}/kanban/projects/${this.$route.params.projectId}/tasks/${response.data.task.id}`);
            }
            
          })
          .catch((err) => {
            // var errors = err.response.data.errors
            console.log(err)
          })
          .finally(() => {
            this.loading = false
          })
        })
      },
      addProgressList(check){
        var postion = check.progressLists.length
        check.progressLists.push({body: '', position: postion})
        this.editToggle = true;
      },
      addChecks() {
        var postion = this.DV_task.checklists.length
        this.DV_task.checklists.push({text: '', checked: false, position: postion, progressLists: []})
      },
      addFilesInput(){
        this.DV_task.taskFiles.push({name: "", uri: '', link: true,guid: this.guid()})
      },
      addNote() {
        this.DV_task.notes.unshift({body: '', user_id: '', guid: this.guid()})
      },

      destroyNote(note) {
        let confirm = window.confirm(`Are you sure you want to delete this update note?`)
        if (!confirm) return;
        let i = note.id ? this.DV_task.notes.findIndex(n => n.id === note.id) : this.DV_task.notes.findIndex(n => n.guid === note.guid)
        Vue.set(this.DV_task.notes, i, {...note, _destroy: true})
      },
      noteBy(note) {
        return note.user ? `${note.user.fullName} at ${new Date(note.createdAt).toLocaleString()}` : `${this.$currentUser.full_name} at (Now)`
      },
      downloadFile(file) {
        let url = window.location.origin + file.uri
        window.open(url, '_blank');
      },
      destroyProgressList(check, progressList, index) {
        let confirm = window.confirm(`Are you sure you want to delete this Progress List item?`)
        if (!confirm) return;
        let i = progressList.id ? check.progressLists.findIndex(c => c.id === progressList.id) : index
        Vue.set(check.progressLists, i, {...progressList, _destroy: true})
        this.saveTask()
      },
      destroyCheck(check, index) {
        let confirm = window.confirm(`Are you sure you want to delete this checklist item?`)
        if (!confirm) return;
        let i = check.id ? this.DV_task.checklists.findIndex(c => c.id === check.id) : index
        Vue.set(this.DV_task.checklists, i, {...check, _destroy: true})
        this.saveTask()
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
          let checked = _.filter(checks, v => !v._destroy && v.checked && v.text.trim()).length
          let total = _.filter(checks, v => !v._destroy && v.text.trim()).length
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
        } else if (name === 'dueDate' && this.DV_task.checklists[index].text) {
          this.DV_task.checklists[index].dueDate = event.target.value
        }
      },
      updateFileLinkItem(event, name, input) {
        //var v = event.target.value
        //var valid = /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,6}(:[0-9]{1,5})?(\/.*)?$/i/.test(v);
        if(event.target.value){
          input.name = event.target.value
        }
      },
      updateProgressListItem(event, name, progressList) {
        progressList.body = event.target.value
      },
      isMyCheck(check) {
        return this.C_myTasks && check.id ? (check.user && check.user.id == this.$currentUser.id) : true
      },
      allowDeleteNote(note) {
        return this._isallowed('delete') && note.guid || (note.userId == this.$currentUser.id)
      },
      allowEditNote(note) {
        return this._isallowed('write') && note.guid || (note.userId == this.$currentUser.id)
      },
      disabledDateRange(date) {
        var dueDate = new Date(this.DV_task.dueDate)
        dueDate.setDate(dueDate.getDate() + 1)
        return date < new Date(this.DV_task.startDate) || date > dueDate;
      },
    },
    computed: {
      ...mapGetters([
        'getFacilityProjectOptions',
        'currentProject',
        'taskTypes',
        'taskStages',
        'activeProjectUsers',
        'projectUsers',
        'myActionsFilter',
        'currentTasks',
        'currentIssues',
        'currentRisks',
        'managerView',
        'facilities',
      ]),
      readyToSave() {
        return (
          this.DV_task &&
          this.exists(this.DV_task.text) &&
          this.exists(this.DV_task.taskTypeId) &&
          this.exists(this.DV_task.dueDate) &&
          this.exists(this.DV_task.startDate)
        )
      },
      isMapView() {
        return this.$route.name === 'ProjectMapView'
      },
      isKanbanView() {
        return this.$route.name === 'ProjectKanbanView'
      },
      filteredChecks() {
        return _.filter(this.DV_task.checklists, c => !c._destroy)
      },
      filteredFiles() {
        return _.filter(this.DV_task.taskFiles, f => !f._destroy)
      },
      C_myTasks() {
        return _.map(this.myActionsFilter, 'value').includes('tasks')
      },
      filteredTasks() {
        return _.filter(this.currentTasks, t => t.id !== this.DV_task.id)
      },
      filteredRisks() {
        return _.filter(this.currentRisks, t => t.id !== this.DV_task.id)
      },
      filteredIssues() {
        return this.currentIssues
      },
      filteredNotes() {
        return _.orderBy(_.filter(this.DV_task.notes, n => !n._destroy), 'createdAt', 'desc')
      },
      _isallowed() {
        return salut => this.$currentUser.role == "superadmin" || this.$permissions.tasks[salut]
      },
      C_title() {
        return this._isallowed('write') ? this.task.id ? "Edit Task" : "Add Task" : "Task"
      },
      isSheetsView() {
        return this.$route.name === 'ProjectSheets'
      },
      tab() {
        if (this.$route.path.includes("map")) {
          return "map";
        } else if (this.$route.path.includes("sheet")) {
          return "sheet";
        } else {
          return "kanban";
        }
      },
      projectNameLink() {
        if (this.$route.path.includes("kanban")) {
          return `/programs/${this.$route.params.programId}/${this.tab}/projects/${this.$route.params.projectId}/tasks`
        } else {
          return `/programs/${this.$route.params.programId}/${this.tab}/projects/${this.$route.params.projectId}`
        }
      }
    },
    watch: {
      task: {
        handler: function(value) {
          this.loadTask(this.task)
        }
      },
      "DV_task.startDate"(value) {
        if (this._ismounted && !value) this.DV_task.dueDate = ''
      },
      "DV_task.dueDate"(value) {
        if (this._ismounted && this.facility.dueDate) {
          if (moment(value).isAfter(this.facility.dueDate, 'day')) {
            alert('Task Due Date is past Project Due Date!')
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
  // RACI USERS HERE awaiting backend work
   responsibleUsers: {
        handler: function(value) {
          if (value){
              this.DV_task.responsibleUserIds = _.uniq(_.map( _.flatten([value]) , 'id'))
          }else{
            this.DV_task.responsibleUserIds = null
          }
        }, deep: true
      },
    accountableTaskUsers: {
        handler: function(value) {
          if (value){
            this.DV_task.accountableUserIds = _.uniq(_.map( _.flatten([value]) , 'id'))
          }else{
            this.DV_task.accountableUserIds = null
          }
        }, deep: true
      },
        consultedTaskUsers: {
        handler: function(value) {
          if (value) {

            this.DV_task.consultedUserIds = _.uniq(_.map(value, 'id'))
          }else{
            this.DV_task.consultedUserIds = []
          }
        }, deep: true
      },
      informedTaskUsers: {
        handler: function(value) {
          if (value){
            this.DV_task.informedUserIds = _.uniq(_.map(value, 'id'))
          }else{
            this.DV_task.informedUserIds = []
          }
        }, deep: true
      },
      relatedIssues: {
        handler: function(value) {
          if (value) this.DV_task.subIssueIds = _.uniq(_.map(value, 'id'))
        }, deep: true
      },
      relatedTasks: {
        handler: function(value) {
          if (value) this.DV_task.subTaskIds = _.uniq(_.map(value, 'id'))
        }, deep: true
      },
      relatedRisks: {
        handler: function(value) {
          if (value) this.DV_task.subRiskIds = _.uniq(_.map(value, 'id'))
        }, deep: true
      },
      selectedTaskType: {
        handler: function(value) {
          // console.log("SelectedTaskType: " + value)
          this.DV_task.taskTypeId = value ? value.id : null
        }, deep: true
      },
      selectedTaskStage: {
        handler: function(value) {
          this.DV_task.taskStageId = value ? value.id : null
        }, deep: true
      },
      filteredTasks: {
        handler(value) {
          let ids = _.map(value, 'id')
          this.relatedTasks = _.filter(this.relatedTasks, t => ids.includes(t.id))
        }, deep: true
      },
      filteredIssues: {
        handler(value) {
          let ids = _.map(value, 'id')
          this.relatedIssues = _.filter(this.relatedIssues, t => ids.includes(t.id))
        }, deep: true
      },
      filteredRisks: {
        handler(value) {
          let ids = _.map(value, 'id')
          this.relatedRisks = _.filter(this.relatedRisks, t => ids.includes(t.id))
        }, deep: true
      },
      "filteredNotes.length"(value, previous) {
        this.$nextTick(() => {
          if (this.$refs.paginator && (value === 1 || previous === 0)) {
            this.$refs.paginator.goToPage(1)
          }
        })
      }
    }
  };
</script>

<style scoped lang="scss">
  .tasks-form {
    
  }
  .kanban-form {
    left: 16.4%;
    width: 83.33%;
    z-index: 100;
  }
  .fixed-form-mapView {
    width: 100%;
    top:0;
    position: absolute;
    transform: scale(1.03);
  }
  td, th {
    border: solid 1px #ededed;
    padding: 1px 3px;
  }
  tbody {
    background-color: #fff;
  }

  th {
    background:  #ededed;
    color: #383838;
    padding: 1px 3px;
  }
  .form-control.error {
    border-color: #E84444;
  }
  .checklist-text {
    margin-left: 5px;
    min-height: 33px;
    border: 0;
    width: 95%;
    outline: none;
    border: solid #ededed 1px;
    border-radius: 4px;
  }
  .drag {
    cursor: all-scroll;
  }
  .del-check {
    position: absolute;
    display: flex;
    font-weight: 500;
    right: 2rem;
    background: transparent;
    height: fit-content;
    color: #dc3545;
  }
  ul {
    list-style-type: none;
    padding: 0;
  }
  .paperLook {
    padding-bottom: 20px;
    margin-bottom: 10px;
    position: relative;
  }
  .paginate-links.filteredNotes {
    list-style: none !important;
    user-select: none;
    text-decoration-line: none !important;
    margin-bottom: 18px;
    a {
      width: 20px;
      height: 25px;
      margin-right: 0;
      border-radius: 2px;
      background-color: white;
      box-shadow: 0 2.5px 5px rgba(56,56, 56,0.19), 0 3px 3px rgba(56,56,56,0.23);
      color: #383838;
      padding: 5px 12px;
      cursor: pointer;
      text-decoration-line: none !important;
    }
    a:hover {
      background-color: #ededed;
    }
    li.active a {
      font-weight: bold;
      color: #383838;
      background-color: rgba(211, 211, 211, 10%);
    }
    a.active  {
      background-color: rgba(211, 211, 211, 10%);
    }
    li.next:before {
      content: ' | ';
      margin-right: 13px;
      color: #ddd;
    }
    li.disabled a {
      color: #ccc;
      cursor: no-drop;
    }
    li {
      display: inline !important;
      margin: 1px;
      color: #383838 !important;
    }
  }
  .red-border {
    border: solid .5px red;
  }
  .sticky-btn {
    margin-top: 5px;
    margin-bottom: 5px;
    box-shadow: 0 5px 10px rgba(56,56, 56,0.19), 0 1px 1px rgba(56,56,56,0.23);
  }

  .scrollToChecklist, .addCheckProgBtn, .check-items {
    box-shadow: 0 2.5px 5px rgba(56,56, 56,0.19), 0 1px 1px rgba(56,56,56,0.23);
  }
  .addCheckProgBtn:hover {
    background-color: lightgray !important;
  }
  .check-due-date {
    text-align: end;
  }
  .disabled {
    opacity: 0.6;
  }
   .simple-select /deep/ .multiselect {
    .multiselect__placeholder {

      text-overflow: ellipsis;
    }
  }
  .custom-tab {
    background-color: #fff;
    box-shadow: 0 2.5px 5px rgba(56,56, 56,0.19), 0 3px 3px rgba(56,56,56,0.23);
  }
  .fixed-form {
    overflow-y: auto;
    overflow-x: hidden;
    height: calc(100vh - 275px);
  }
  .fixed-form-mapView {
   width: 100%;
   position: absolute;
  }
  .display-length {
   border-radius: 0.15rem;
   margin-right: 12px;
  }
  .fa-building {
    font-size: large !important;
    color: #383838 !important;
  }
  .error-list {
  list-style-type: circle;
  li {
    width: max-content;
  }
}
.text-danger {
  font-size: 13px;
}
.error-border {
  border: 1px solid red;
  border-radius: 4px;
}
.overflow-ellipsis {
  white-space: nowrap;
  text-overflow: ellipsis;
  overflow-x: hidden;
}
 /deep/.el-collapse-item__header {
  background-color: #fafafa;
 }
 /deep/ .el-collapse {
  border-top: none !important;
  border-bottom: none !important;
}
/deep/.el-collapse-item__content {
  padding-bottom: 0 !important;
}
/deep/.el-collapse-item__header {
  background-color: #fafafa;
}
 #roll_up {
  /deep/.el-collapse-item__header {
    float: right;
    padding: 1em;
    margin-top: -36px;
    color: #d9534f !important;
    border-bottom: none !important;
    background-color: #fafafa !important;
  }
}
.informed.el-input__inner {
  height: 32px;
}
.no-text-decoration:link {
  text-decoration: none;
  color: #495057;
  text-decoration-color: none;
}
.no-text-decoration:active{
  text-decoration: none;
  color: #495057;
  text-decoration-color: none;
}
.no-text-decoration:visited {
  text-decoration: none;
  color: #495057;
  text-decoration-color: none;
}
.hover {
  background: transparent;
  border-radius: 0 !important;
}
.hover:hover {
  cursor: pointer;
  background-color: rgba(91, 192, 222, 0.3);
}
input.file-link {
  outline:0 none;
}
.clearStageBtn {
  box-shadow: 0 2.5px 5px rgba(56,56, 56,0.19), 0 3px 3px rgba(56,56,56,0.23);
}

.exampleTwo.el-steps, .exampleTwo.el-steps--simple {
  border: 1px solid #DCDFE6;
  background: #fff; 
}

.overSixSteps {
/deep/.el-step__title {
  font-size: 11px !important;
  line-height: 23px !important;
  margin: 5px !important;
 }
}
a {
  color: #007bff
}
a:hover {
  text-decoration: unset;
}
</style>

