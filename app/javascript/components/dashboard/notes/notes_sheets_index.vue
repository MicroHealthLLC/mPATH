<template>
  <div id="notes-index" data-cy="note_list" class="mt-5"> 
    <el-tabs type="border-card"  v-model="editableTabsValue"  @tab-click="handleClick" >   
      <el-tab-pane>
        <template slot="label" >          
          <span class="text-right">
           <i class="fa-solid fa-plus-large"    @click="addTab(editableTabsValue)"> </i>           
          </span>
        </template>
      <el-table
      v-if="tableTasks && tableTasks.length > 0"
      :data="tableTasks "
      height="450"
      class="crudRow mt-4"
      :header-row-style="{textAlign: 'center'}"
    >
    <el-table-column
      fixed
      prop="planned_effort"
      label="Planned Effort"
      width="80"
      header-align="center"
    >
    </el-table-column>
    <el-table-column
      fixed
      prop="actual_effort"
      label="Actual Effort"
      width="80"
      header-align="center"
    >
    </el-table-column>
    <el-table-column
      fixed
      prop="name"
      label="Tasks"
      width="275"
      header-align="center"
    >
   
    </el-table-column>
    <el-table-column label="Week of" header-align="center">
      <el-table-column v-for="weekof, i in Weeks" :key="i" :label='weekof'>
     <template>    
      <!-- <template slot-scope="scope">     -->
      <el-input placeholder="hrs" v-model="input" :key="i"></el-input>
     </template>              
      </el-table-column>
    </el-table-column>
         </el-table>
         <span v-else>
          BOBN
         </span>

      </el-tab-pane>
    
      <el-tab-pane label="Summary" :class="active">   
      <el-table
      v-if="tableTasks && tableTasks.length > 0"
      :data="tableTasks "
      height="450"
      class="crudRow mt-4"
      :header-row-style="{textAlign: 'center'}"
    >
    <el-table-column
      fixed
      prop="planned_effort"
      label="Planned Effort"
      width="80"
      header-align="center"
    >
    </el-table-column>
    <el-table-column
      fixed
      prop="actual_effort"
      label="Actual Effort"
      width="80"
      header-align="center"
    >
    </el-table-column>
    <el-table-column
      fixed
      prop="name"
      label="Tasks"
      width="275"
      header-align="center"
    >
   
    </el-table-column>
    <el-table-column label="Week of" header-align="center">
      <el-table-column v-for="weekof, i in Weeks" :key="i" :label='weekof'>
     <template slot-scope="scope">  
      <span>
          {{ 
          userTime
          .filter(t => t.id == scope.row.id) 
          .map(t => t.timesheets)
          .flat()
          .filter(t => t.date_of_week == weekof)    
          .map(t => t.hours).reduce((partialSum, a) => partialSum + a, 0)            
          }}           
      </span>
     </template>              
      </el-table-column>
    </el-table-column>
      </el-table>
      </el-tab-pane>
      <el-tab-pane
        v-for="(item, index) in timesheets"
        :key="item.id"
        :label="item.full_name"
        :name="index"
      >
      <el-table
      v-if="tableTasks && tableTasks.length > 0"
      :data="tableTasks "
      height="450"
      class="crudRow mt-4"
      :header-row-style="{textAlign: 'center'}"
    >
    <el-table-column
      fixed
      prop="planned_effort"
      label="Planned Effort"
      width="80"
      header-align="center"
    >
    </el-table-column>
    <el-table-column
      fixed
      prop="actual_effort"
      label="Actual Effort"
      width="80"
      header-align="center"
    >
    </el-table-column>
    <el-table-column
      fixed
      prop="name"
      label="Tasks"
      width="275"
      header-align="center"
    >
   
    </el-table-column>
    <el-table-column label="Week of" header-align="center">
      <el-table-column v-for="weekof, i in Weeks" :key="i" :label='weekof'>
     <template slot-scope="scope">  
      <span v-if="!editMode">
        <!-- {{ i }} -->

        {{ 
          item.tasks.filter(t => t.id == scope.row.id )
          .map(t => t.timesheets)
          .flat()
          .filter(t => t.date_of_week == weekof)    
          .map(t => t.hours)[0]          
          }}   
      </span>
      <span v-if="editMode">
        <el-input placeholder="hrs" v-model="item.tasks.filter(t => t.id == scope.row.id )
          .map(t => t.timesheets)
          .flat()
          .filter(t => t.date_of_week == weekof)    
          .map(t => t.hours)[0]" :key="i"></el-input>
      </span>
     </template>              
      </el-table-column>
    </el-table-column>
      </el-table>
      </el-tab-pane>
      <el-button type="primary" @click="editToggle" class="calendarBtn"  circle>
        <i class="fa-light fa-calendar-pen text-light"></i>
      </el-button>
     
    </el-tabs>
   
  </div>

</template>

<script>
  import {mapMutations, mapGetters} from "vuex"
  import NotesForm from './notes_form'
  import NotesSheets from './notes_sheets'
  import {SweetModal} from 'sweet-modal-vue'

  export default {
    name: 'NotesSheetsIndex',
    components: {
      NotesForm,
      NotesSheets,
      SweetModal
    },
    props: ['facility', 'from'],
    data() {
      return {       
        tabIndex: this.editableTabsValue,
        loading: true,
        input: '',
        editMode: false, 
        newNote: false,
        myNotesCheckbox: false,
        notesQuery: '',
        DV_facility: Object.assign({}, this.facility),
        Weeks: [ '2-Jan', '9-Jan', '16-Jan','30-Jan', '6-Feb', '13-Feb', '20-Feb', '27-Feb','6-Mar', '20-Mar', '27-Mar' ],
    
      //PROJECT
      timesheets: [

        {
           id: 1,
           full_name: "Frank Tucker",
           organization: "Test Org",
           tasks: [

                {

                    id: 10,
                    text: "Task One",  
                    due_date: "2023-02-19",
                    progress: 0,                  
                    start_date: "2023-02-16",
                    facility_project_id: 1445,              
                    planned_effort: 100,
                    actual_effort: 90,
                    timesheets: [

                        {

                            id: 19,
                            date_of_week: "2-Jan",
                            hours: 2.5,
                            user_id: 1,
                            facility_project_id: 1460,
                            created_at: "2023-02-16T16:56:25.112-05:00",
                            updated_at: "2023-02-16T16:56:25.112-05:00"

                        }

                    ]

                },
                {
                    id: 12,
                    text: "Task Two",  
                    due_date: "2023-02-19",
                    progress: 0,                  
                    start_date: "2023-02-16",
                    facility_project_id: 1445,              
                    planned_effort: 85,
                    actual_effort: 65,
                    timesheets: [

                        {

                            id: 19,
                            date_of_week: "2-Jan",
                            hours: 2,
                            user_id: 1,
                            facility_project_id: 1460,
                            created_at: "2023-02-16T16:56:25.112-05:00",
                            updated_at: "2023-02-16T16:56:25.112-05:00"

                        }

                    ]

                },
                {

                id: 13,
                text: "Task Three",  
                due_date: "2023-02-19",
                progress: 0,                  
                start_date: "2023-02-16",
                facility_project_id: 1445,              
                planned_effort: 85,
                actual_effort: 65,
                timesheets: [

                    {

                        id: 19,
                        date_of_week: "27-Mar",
                        hours: 5,
                        user_id: 1,
                        facility_project_id: 1460,
                        created_at: "2023-02-16T16:56:25.112-05:00",
                        updated_at: "2023-02-16T16:56:25.112-05:00"

                    }

                ]

                },
            ]

        },
          {
            id: 2,        
            full_name: "Juan Rivera",
            tasks: [

                {

                    id: 10,
                    text: "Task One",  
                    due_date: "2023-02-19",
                    progress: 0,                  
                    start_date: "2023-02-16",
                    facility_project_id: 1445,              
                    planned_effort: 100,
                    actual_effort: 90,
                    timesheets: [

                        {

                            id: 19,
                            date_of_week: "2-Jan",
                            hours: 1,
                            user_id: 1,
                            facility_project_id: 1460,
                            created_at: "2023-02-16T16:56:25.112-05:00",
                            updated_at: "2023-02-16T16:56:25.112-05:00"

                        }

                    ]

                },
                {

                    id: 12,
                    text: "Task Two",  
                    due_date: "2023-02-19",
                    progress: 0,                  
                    start_date: "2023-02-16",
                    facility_project_id: 1445,              
                    planned_effort: 85,
                    actual_effort: 65,
                    timesheets: [

                        {

                            id: 19,
                            date_of_week: "2-Jan",
                            hours: 1.5,
                            user_id: 1,
                            facility_project_id: 1460,
                            created_at: "2023-02-16T16:56:25.112-05:00",
                            updated_at: "2023-02-16T16:56:25.112-05:00"

                        }

                    ]

                },
                {

                  id: 13,
                  text: "Task Three",  
                  due_date: "2023-02-19",
                  progress: 0,                  
                  start_date: "2023-02-16",
                  facility_project_id: 1445,              
                  planned_effort: 85,
                  actual_effort: 65,
                  timesheets: [

                      {

                          id: 19,
                          date_of_week: "27-Mar",
                          hours: 2.5,
                          user_id: 1,
                          facility_project_id: 1460,
                          created_at: "2023-02-16T16:56:25.112-05:00",
                          updated_at: "2023-02-16T16:56:25.112-05:00"

                      }

                  ]

                  },
            ]

        },
          {
            id: 3,    
            full_name: "Billy Bob",
            organization: "Test Org",
            tasks: [

                {

                    id: 12,
                    text: "Task 2",  
                    due_date: "2023-02-19",
                    progress: 0,                  
                    start_date: "2023-02-16",
                    facility_project_id: 1445,              
                    planned_effort: 100,
                    actual_effort: 90,
                    timesheets: [
                        {
                            id: 19,
                            date_of_week: "9-Jan",
                            hours: 3,
                            user_id: 1,
                            facility_project_id: 1460,
                            created_at: "2023-02-16T16:56:25.112-05:00",
                            updated_at: "2023-02-16T16:56:25.112-05:00"

                        }
                    ]
                },
                {
                    id: 13,
                    text: "Task 3",  
                    due_date: "2023-02-19",
                    progress: 0,                  
                    start_date: "2023-02-16",
                    facility_project_id: 1445,              
                    planned_effort: 85,
                    actual_effort: 65,
                    timesheets: [

                        {

                            id: 19,
                            date_of_week: "2-Jan",
                            hours: 6,
                            user_id: 1,
                            facility_project_id: 1460,
                            created_at: "2023-02-16T16:56:25.112-05:00",
                            updated_at: "2023-02-16T16:56:25.112-05:00"

                        }

                    ]

                },
            ]

        }

      ],
      tableTasks: [
      {
       name: 'Task 1',
       id: 10,
       planned_effort: 100, 
       actual_effort: 90, 
       users: [
           {
            name: 'Joe Smith',
            taskId: 10,    
            time: [
            {
             week: '2-Jan',
             a_effort: 40
            },
            {
             week: '9-Jan',
             a_effort: 40
            },
            {
             week: '16-Jan',
             a_effort: 40
            },
           ]
        },
        {
          name: 'Ricky Bobby',
          taskId: 10,    
          time: [
            {
             week: '2-Jan',
             a_effort: 40
            },
            {
             week: '9-Jan',
             a_effort: 40
            },
            {
             week: '16-Jan',
             a_effort: 40
            },
           ]
        },
        {
          name: 'Juan Garcia',
          taskId: 10,    
          time: [
            {week: '6-Feb',
            a_effort: 40
            },
            {week: '13-Feb',
            a_effort: 40
            },
            {week: '20-Feb',
             a_effort: 40
            },
           ]
        },
        {
          name: 'Bob Smith',
          taskId: 10,    
          time: [
            {week: '27-Feb',
            a_effort: 40
            },
            {week: '6-Mar',
            a_effort: 40
            },
            {week: '20-Mar',
             a_effort: 40
            },
            {week: '27-Mar',
             a_effort: 40
            },
           ]
        },

       ]    
      },
      { 
       name: 'Task 2',
       planned_effort: 110,
       id: 12, 
       actual_effort: 95,  
       users: [
          {
          name: 'Joe Tasker',
          taskId: 12,    
          time: [
          {
             week: '30-Jan',
             a_effort: 40
            },
            {
             week: '6-Feb',
             a_effort: 40
            },
            {
             week: '13-Feb',
             a_effort: 40
            },
           ]
        },    
        {
          name: 'Bob Smith',
          taskId: 12,    
          time: [
          {
             week: '2-Jan',
             a_effort: 40
            },
            {
             week: '9-Jan',
             a_effort: 40
            },
            {
             week: '16-Jan',
             a_effort: 40
            },
           ]
        },
       ]      
    
      },
      { 
       name: 'Task 3',
       planned_effort: 150, 
       id: 13, 
       actual_effort: 110, 
       users: [
        
         {
          name: 'Bambam Three',
          taskId: 13, 
          time: [
          {
             week: '6-Mar',
             a_effort: 40
            },
            {
             week: '20-Mar',
             a_effort: 40
            },
            {
             week: '27-Mar',
             a_effort: 40
            },
           ]
        },
        {
          name: 'Juan Garcia',
          taskId: 13,    
          time: [
           {
             week: '2-Jan',
             a_effort: 40
            },
            {
             week: '9-Jan',
             a_effort: 40
            },
            {
             week: '16-Jan',
             a_effort: 40
            },
           ]
        },
        {
          name: 'Bob Smith',
          taskId: 13,    
          time: [
            {
             week: '2-Jan',
             a_effort: 40
            },
            {
             week: '9-Jan',
             a_effort: 40
            },
            {
             week: '16-Jan',
             a_effort: 40
            },
           ]
        },

       ]      
    
      },

      ],   
      }
    },
    methods: {
      ...mapMutations([
   
      ]),
      addTab(targetName) {
        let newTabName = ++this.tabIndex + '';
        this.timesheets.push({
          full_name: this.$currentUser.full_name,
          name: newTabName,
          content: 'New Tab content',
          id: this.$currentUser.id 
        });
        this.editableTabsValue = newTabName;
      },
      handleClick(tab, event){
        console.log(tab)
        console.log(event)
      },
      editToggle(){
        this.editMode = !this.editMode
      },
      _isallowed(salut) {
        var programId = this.$route.params.programId;
        var projectId = this.$route.params.projectId
        let fPrivilege = this.$projectPrivileges[programId][projectId]
        let permissionHash = {"write": "W", "read": "R", "delete": "D"}
        let s = permissionHash[salut]
        return  fPrivilege.notes.includes(s); 
      },
     addNewNote() {
        this.setTaskForManager({key: 'note', value: {}})
        // Route to new task form page
        this.$router.push(
          `/programs/${this.$route.params.programId}/sheet/projects/${this.$route.params.projectId}/notes/new`
        );
      },
      noteCreated(note) {
        this.$emit('refresh-facility')
        this.newNote = false
        this.facility.notes.unshift(note)
      },
      noteUpdated(note, refresh=true) {
        let index = this.facility.notes.findIndex((t) => t.id == note.id)
        if (index > -1) Vue.set(this.facility.notes, index, note)
        if (refresh) {
          this.newNote = false
          this.$emit('refresh-facility')
        } else {
          this.updateFacilityHash(this.facility)
        }
      },
      // noteUpdated(note) {
      //   let index = this.DV_facility.notes.findIndex(n => n.id == note.id)
      //   if (index > -1) Vue.set(this.DV_facility.notes, index, note)
      // },
      noteDeleted(note) {
        this.DV_facility.notes.splice(this.DV_facility.notes.findIndex(n => n.id == note.id), 1)
      }
    },
    computed: {
      ...mapGetters([
        'myActionsFilter'
      ]),
     userTime(){
        if(this.timesheets && this.timesheets.length > 0){
          return this.timesheets.map(t => t.tasks).flat()
        }
      },
      editableTabsValue(){
        return this.timesheets.length
      }, 
      filteredNotes() {
        const resp = this.exists(this.notesQuery.trim()) ? new RegExp(_.escapeRegExp(this.notesQuery.trim().toLowerCase()), 'i') : null
        return _.filter(this.DV_facility.notes, n => {
          let valid = this.C_myNotes ? this.$currentUser.id == n.userId : true
          if (resp) valid = valid && resp.test(n.body)
          return valid
        })
      },
      C_myNotes: {
        get() {
          return this.myNotesCheckbox;
          // return _.map(this.myActionsFilter, 'value').includes('notes')
        },
        set(value) {
          this.myNotesCheckbox = value
          // if (value) this.setMyActionsFilter([...this.myActionsFilter, {name: "My Notes", value: "notes"}])
          // else this.setMyActionsFilter(this.myActionsFilter.filter(f => f.value !== "notes"))
        }
      }
    },
    watch: {
      facility: {
        handler: function(value) {
          this.DV_facility = Object.assign({}, value)
          this.loading = true
        }, deep: true
      }
    }
  }
</script>

<style lang="scss" scoped>
.calendarBtn {
  font-size: 2.5rem;
  margin-top: 1rem;
  float: right;
  transition: all .2s ease-in-out; 
  box-shadow: 0 2.5px 5px rgba(56, 56, 56, 0.19),
      0 3px 3px rgba(56, 56, 56, 0.23);
}

.calendarBtn:hover {
  transform: scale(1.06);
}

/deep/ #tab-0 {
  background-color: rgb(234, 234, 185) !important;
}
/deep/ .el-table .cell {
    word-break: break-word;
}
/deep/ .el-table thead {
    color: #383838 !important;
}
  #search-addon {
    background-color: #ededed !important;
  }
  #notes-index {
    height: 500px;
  }
  input[type=search] {
    color: #383838;
    text-align: left;
    cursor: pointer;
    display: block;
  }
  .addNote{
    box-shadow: 0 5px 10px rgba(56,56, 56,0.19), 0 1px 1px rgba(56,56,56,0.23);
  }
  .notes{
    padding:8px;
    box-shadow: 0 5px 10px rgba(56,56, 56,0.19), 0 1px 1px rgba(56,56,56,0.23);
    z-index: 100;
  }
  #notesHover:hover {
    box-shadow: 0.5px 0.5px 1px 1px rgba(56,56, 56,0.29), 0 2px 2px rgba(56,56,56,0.23);
    background-color: rgba(91, 192, 222, 0.3);
    border-left: solid rgb(91, 192, 222);
  }
  .notes-container {
    position: relative;
    overflow: auto;  
    height: 61vh;    
  }
  .filters-wrapper {
    float: right;
    margin-top: -50px;
}
  @media screen and (max-width: 1500px) {
  .filters-wrapper {
    width: 65% !important;
  } 
}
  // notes-rows creates a scroallable div within a container, preventing the need to scroll beyond the viewport height
  // .notes-rows {
  //   overflow-y: scroll;
  //   box-shadow: 0.5px 0.5px 1px 1px rgba(56,56, 56,0.29), 0 2px 2px rgba(56,56,56,0.23);
  //   max-height: 59vh;
  //   border-top: solid 4px #ededed;
  //   padding-top: 8px;  
  // }
  
</style>
