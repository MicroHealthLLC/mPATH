<template>
  <div id="notes-index" data-cy="note_list">
<h1>TEST</h1>
  </div>

</template>

<script>
  import {mapMutations, mapGetters} from "vuex"
  import TimeSheets from './time_sheets'
  import {SweetModal} from 'sweet-modal-vue'

  export default {
    name: 'TimeSheetsIndex',
    components: {    
      TimeSheets,
      SweetModal
    },
    props: ['facility', 'from'],
    data() {
      return {
        loading: true,
        newNote: false,
        myNotesCheckbox: false,
        notesQuery: '',
        DV_facility: Object.assign({}, this.facility)
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
