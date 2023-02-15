<template>
  <div id="notes-index" data-cy="note_list" class="mt-5">
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
      <span v-if="scope.row.users.filter(t => t.taskId == scope.row.id)">

        {{ scope.row.users
          .filter(t => t.taskId == scope.row.id)
          .map(t => t.time)
          .flat()
          .filter(t => t.week == weekof)
          .map(t => t.a_effort).reduce((partialSum, a) => partialSum + a, 0)       
        }}
      </span>
       
     </template>              
      </el-table-column>
    </el-table-column>
    </el-table>
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
        loading: true,
        newNote: false,
        myNotesCheckbox: false,
        notesQuery: '',
        DV_facility: Object.assign({}, this.facility),
        Weeks: [ '2-Jan', '9-Jan', '16-Jan','30-Jan', '6-Feb', '13-Feb', '20-Feb', '27-Feb','6-Mar', '20-Mar', '27-Mar' ],
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
        'setTaskForManager',
        'setMyActionsFilter',
        'updateFacilityHash'
      ]),
      //TODO: change the method name of isAllowed
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
