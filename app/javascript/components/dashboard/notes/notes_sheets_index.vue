<template>
  <div id="notes-index" data-cy="note_list">
    <div v-if="_isallowed('write') && newNote" class="mb-3">    
      <notes-form
        title="Add Note"
        :facility="DV_facility"
        :contract="contract"
        :vehicle="vehicle"
        @close-note-input="newNote=false"
        @note-created="noteCreated"
        class="notes_form_modal"
      ></notes-form> 
    </div>
    <div v-else >
     <span class="filters-wrapper w-60 pr-2">
      <div class="mb-3 row px-3" :class="{'justify-content-center': _isallowed('write')}">
        <div class="col-md-11 px-0">
          <div class="input-group" :class="{'search-tab': _isallowed('write')}">
           <el-input
            type="search"          
            placeholder="Search Notes"
            aria-label="Search"            
            aria-describedby="search-addon"    
             v-model="notesQuery"  
            data-cy="search_notes"
        >
          <el-button slot="prepend" icon="el-icon-search"></el-button>
        </el-input>
          
          </div>
        </div>
      </div>
          </span>
      <div class="row">
      <div class="col-md-11 form-check-inline w-100 mb-2 mx-0 font-sm pr-0">
        <div class="px-1 float-left" v-if="_isallowed('write')">
          <button @click.prevent="addNewNote"
          class="btn btn-md btn-primary addNote"
          data-cy="new_note"><i class="fas fa-plus-circle mr-2"></i>
          Add Note</button>
        </div>
        <div class="float-right ml-auto">
          <label class="form-check-label">
            <input type="checkbox" class="form-check-input" v-model="C_myNotes"> <i class="fas fa-user mr-1"></i>My Notes
          </label>
          <!-- <label class="form-check-label ml-2 text-primary">
            <h5 class="mb-0 mr-2" data-cy="note_total">Total Notes: {{filteredNotes.length}}</h5>
          </label> -->
        </div>
      </div>
      </div>

      
      <div class="notes-container row justify-content-center pt-2">
      <div v-if="_isallowed('read')" class="notes-rows pr-0 col-md-11" > 
        <div v-if="filteredNotes.length > 0" class="mb-3">
          <notes-sheets
            v-for="note in filteredNotes.slice().reverse()" 
            :key="note.id" 
            :facility="DV_facility"
            :contract="contract"
            :vehicle="vehicle"
            :note="note"
            :contractNote="note"
            :vehicleNote="note"
            id="notesHover"
            :from="from"
            @note-updated="noteUpdated"
            @note-deleted="noteDeleted"
            class="notes"
          ></notes-sheets>
        </div>      
        <div v-show="filteredNotes.length <= 0" class="text-danger ml-3">No notes found..</div>
        </div>
      <div v-else class="text-danger mx-2 mt-2">
        <h5> <i>Sorry, you don't have read-permissions for this tab! Please click on any available tab.</i></h5>
      </div>
    </div>
  </div>
  </div>

</template>

<script>
  import {mapMutations, mapGetters, mapActions} from "vuex"
  import NotesForm from './notes_form'
  import ContractNotesForm from './contract_notes_form'
  import VehicleNotesForm from './vehicle_notes_form'
  import NotesSheets from './notes_sheets'
  import {SweetModal} from 'sweet-modal-vue'

  import MessageDialogService from "../../../services/message_dialog_service";

export default {
    name: 'NotesSheetsIndex',
    components: {
      NotesForm,
      ContractNotesForm,
      VehicleNotesForm, 
      NotesSheets,
      SweetModal
    },
    props: ['facility', 'from', "contract", "vehicle"],
    data() {
      return {
        loading: true,
        newNote: false,
        myNotesCheckbox: false,
        notesQuery: '',    
        DV_facility: Object.assign({}, this.facility),
     
      }
    },
    methods: {
      ...mapMutations([
        'setTaskForManager',
        'setMyActionsFilter',
        'updateFacilityHash'
      ]),
       ...mapActions([
        'fetchContractNotes',
        'fetchVehicleNotes'       
      ]),
      _isallowed(salut) {
        return this.checkPrivileges("notes_sheets_index", salut, this.$route)

        // if (this.$route.params.contractId) {
        //   let fPrivilege = this.$contractPrivileges[this.$route.params.programId][this.$route.params.contractId]    
        //   let permissionHash = {"write": "W", "read": "R", "delete": "D"}
        //   let s = permissionHash[salut]
        //   return fPrivilege.notes.includes(s);
        // } else {
        //   let fPrivilege = this.$projectPrivileges[this.$route.params.programId][this.$route.params.projectId]    
        //   let permissionHash = {"write": "W", "read": "R", "delete": "D"}
        //   let s = permissionHash[salut]
        //   return fPrivilege.notes.includes(s); 
        // }
     },
     addNewNote() {
        this.setTaskForManager({key: 'note', value: {}})
        // Route to new task form page
        if(this.$route.params.contractId){
        this.$router.push(
          `/programs/${this.$route.params.programId}/sheet/contracts/${this.$route.params.contractId}/notes/new`
        );
        } else if(this.$route.params.vehicleId){
        this.$router.push(
          `/programs/${this.$route.params.programId}/sheet/vehicles/${this.$route.params.vehicleId}/notes/new`
        );
        } else
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
      noteDeleted(note) {
        this.DV_facility.notes.splice(this.DV_facility.notes.findIndex(n => n.id == note.id), 1)
      }
    },
    mounted() {
    // GET request action to retrieve all lessons for project
    //  console.log(this.filteredLessons.filtered.lessons)
    if (this.$route.params.contractId && !this.vehicle && !this.facility){
        this.fetchContractNotes(this.$route.params);
     } else if (this.$route.params.vehicleId && !this.contract &&!this.facility){
        this.fetchVehicleNotes(this.$route.params);
     }   
    },
    computed: {
      ...mapGetters([
        'myActionsFilter',
        'contractNotes',
        'vehicleNotes'
      ]),
      filteredNotes() {
        const resp = this.exists(this.notesQuery.trim()) ? new RegExp(_.escapeRegExp(this.notesQuery.trim().toLowerCase()), 'i') : null
        let notes = this.DV_facility.notes;
        if (this.$route.params.contractId){
          notes = this.contractNotes
        } else if (this.$route.params.vehicleId){
          notes = this.vehicleNotes
        }    
         return _.filter(notes, n => {
          //  console.log(notes)
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
      },
    //   contract: {
    //   handler: function(value) {
    //     this.DV_contract = Object.assign({}, value)
    //     this.loading = true
    //   }, deep: true
    // }
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
