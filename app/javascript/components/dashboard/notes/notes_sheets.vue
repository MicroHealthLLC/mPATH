
<template>
  <div data-cy="notes">
    <div v-if="C_editForManager" class="blur_show float-right">   
    </div>
    <div data-cy="notes_show" class="notes_show mb-5 mx-2">
      <div v-if="note">
        <div class="crud-actions mx-3 float-right">
          <span class="mr-2 edit-action" @click.stop="editNoteMode" data-cy="note_edit_icon">
             <i class="fas fa-edit"></i> 
          </span>
          <span v-if="permitted('delete') && this.facility" class="mr-2 delete-action" @click.stop="deleteNote" data-cy="note_delete_icon">
            <i class="fas fa-trash-alt"></i>
          </span>
           <span class="mr-2 delete-action" v-if="this.contract && _isallowed('delete')" @click.prevent="delete_contract_note" data-cy="note_delete_icon">
            <i class="fas fa-trash-alt"></i>
          </span>
          <span class="mr-2 delete-action" v-if="this.vehicle && _isallowed('delete')" @click.prevent="delete_vehicle_note" data-cy="note_delete_icon">
            <i class="fas fa-trash-alt"></i>
          </span>
          
        </div>
        <div class="note_by my-2" >
          <!-- <span class="badge badge-secondary">Note by</span> -->
          <span class="text-muted font-sm" v-if="this.contract || this.vehicle">{{  note_by }}</span>
           <span class="text-muted font-sm" v-if="!this.contract && !this.vehicle && this.facility" >{{  noteBy }}</span>
        </div>
        <div v-if="facility && !this.vehicle && !this.contract">
        <div v-if="note.attachFiles.length > 0" class="note_files">
          <span class="badge badge-secondary mr-3" >Note Files</span>
          <span v-for="(file, i) in note.attachFiles" :key="i">
            <span class="file-icon" v-tooltip.bottom="`${file.name}`" @click="downloadFile(file)">
              <i class="fas fa-file-alt"></i>
            </span>
          </span>
        </div>
        </div>
        <div v-if="contract">
          <div v-if="note.attach_files.length > 0" class="note_files">
            <span class="badge badge-secondary mr-3" >Note Files</span>
            <span v-for="(file, i) in note.attach_files" :key="i">
              <span class="file-icon" v-tooltip.bottom="`${file.name}`" @click="downloadFile(file)">
                <i class="fas fa-file-alt"></i>
              </span>
            </span>
          </div>
        </div>
        <div v-if="vehicle">
          <div v-if="note.attach_files.length > 0" class="note_files">
            <span class="badge badge-secondary mr-3" >Note Files</span>
            <span v-for="(file, i) in note.attach_files" :key="i">
              <span class="file-icon" v-tooltip.bottom="`${file.name}`" @click="downloadFile(file)">
                <i class="fas fa-file-alt"></i>
              </span>
            </span>
          </div>
        </div>

        <div class="note_body my-2 font-sm" v-if="note">
          {{note.body}}
        </div>
      </div>
       <!-- <div v-else>     
        <notes-form
          v-if="permitted('write')"
          title="Edit Note"
          :note="DV_note"
          :facility="facility"       
           class="form-inside-modal"               
           @close-note-input="show=true"
          @note-updated="noteUpdated"
        />      
      </div> -->
    </div>
    
 </div>    
</template>


<script>
  import http from './../../../common/http'
  import {mapActions, mapGetters, mapMutations} from 'vuex'
  import NotesForm from './notes_form'
  import ContractNotesForm from './contract_notes_form'
  import VehicleNotesForm from './vehicle_notes_form'
  import {SweetModal} from 'sweet-modal-vue'
  import {API_BASE_PATH} from './../../../mixins/utils'

  import MessageDialogService from "../../../services/message_dialog_service";

export default {
    props: ['facility', 'note', 'from', "contract", "contractNote", 'vehicle', 'vehicleNote'],
    components: {
      NotesForm,
      ContractNotesForm,
      VehicleNotesForm, 
      SweetModal
    },
    data() {
      return {
        loading: true,
        DV_note: null,  
     }
    },
    mounted() {
      // this.fetchContractNote({
      //   id: this.$route.params.noteId,
      //   ...this.$route.params,
      // });
      if (!_.isEmpty(this.note) && this.$route.params.projectId) {
        this.loading = false
        this.DV_note = this.note
      } else if (!_.isEmpty(this.contractNote) && this.$route.params.contractId) {
        this.loading = false
        this.DV_note = this.contractNote
      } else if (!_.isEmpty(this.vehicleNote) && this.$route.params.vehicleId) {
        this.loading = false
        this.DV_note = this.vehicleNote
      }
    },
    methods: {
      ...mapMutations([
        'setTaskForManager'
      ]),
          ...mapActions([
        'fetchContractNote',
        'deleteContractNote',
        'fetchVehicleNote',
        'deleteVehicleNote'
      ]),
     _isallowed(salut) {
        return this.checkPrivileges("notes_sheets", salut, this.$route)

      //  if (this.$route.params.contractId) {
      //     let fPrivilege = this.$contractPrivileges[this.$route.params.programId][this.$route.params.contractId]    
      //     let permissionHash = {"write": "W", "read": "R", "delete": "D"}
      //     let s = permissionHash[salut]
      //     return fPrivilege.notes.includes(s);
      //   } else {
      //     let fPrivilege = this.$projectPrivileges[this.$route.params.programId][this.$route.params.projectId]    
      //     let permissionHash = {"write": "W", "read": "R", "delete": "D"}
      //     let s = permissionHash[salut]
      //     return fPrivilege.notes.includes(s); 
      //   }
     },
     editNoteMode() {
        if (this.contract) {      
           this.show = false          
           this.$router.push(`/programs/${this.$route.params.programId}/sheet/contracts/${this.$route.params.contractId}/notes/${this.note.id}`)
        } else if (this.vehicle) {      
           this.show = false          
           this.$router.push(`/programs/${this.$route.params.programId}/sheet/vehicles/${this.$route.params.vehicleId}/notes/${this.note.id}`)
        } else {
          this.show = false
          // this.DV_note = this.note
          // this.$refs.notesFormModal && this.$refs.notesFormModal.open() 
          this.$router.push(`/programs/${this.$route.params.programId}/sheet/projects/${this.$route.params.projectId}/notes/${this.DV_note.id}`)
        }
      }, 
      noteUpdated(note) {
        this.show = true
        this.$emit('note-updated', note)
      },
      onCloseForm() {
        this.$refs.notesFormModal && this.$refs.notesFormModal.close()
        // this.has_note = false    
      },
      deleteNote() {
        this.$confirm(`Are you sure you want to delete this note?`, 'Confirm Delete', {
          confirmButtonText: 'Delete',
          cancelButtonText: 'Cancel',
          type: MessageDialogService.msgTypes.WARNING
        }).then(() => {
          http
            .delete(`${API_BASE_PATH}/programs/${this.currentProject.id}/projects/${this.facility.id}/notes/${this.note.id}.json`)
            .then((res) => {
              this.loading = false
              this.$emit('note-deleted', this.note)
              MessageDialogService.showDialog({
                response: res
              })
            })
            .catch((err) => {
              this.loading = false
              console.error(err)
            })
        });
      },
      delete_contract_note() {
         this.$confirm(
        `Are you sure you want to delete this note?`,
        "Confirm Delete",
        {
          confirmButtonText: "Delete",
          cancelButtonText: "Cancel",
          type: MessageDialogService.msgTypes.WARNING,
        }
      )
        .then(() => {
          this.deleteContractNote({ id: this.contractNote.id, contractId: this.$route.params.contractId });
          MessageDialogService.showDialog({
            message: "Note successfully deleted",
            
          });
        })
        .catch(() => {
          MessageDialogService.showDialog({
            type: MessageDialogService.msgTypes.INFO,            message: "Delete canceled",            
          });
        });      
    },
    delete_vehicle_note() {
         this.$confirm(
        `Are you sure you want to delete this note?`,
        "Confirm Delete",
        {
          confirmButtonText: "Delete",
          cancelButtonText: "Cancel",
          type: MessageDialogService.msgTypes.WARNING,
        }
      )
        .then(() => {
          this.deleteVehicleNote({ id: this.vehicleNote.id, vehicleId: this.$route.params.vehicleId });
          MessageDialogService.showDialog({
            
            message: "Note successfully deleted",
            
          });
        })
        .catch(() => {
          MessageDialogService.showDialog({
            type: MessageDialogService.msgTypes.INFO,            message: "Delete canceled",
            
          });
        });      
    },
      downloadFile(file) {
        if (this._isallowed('write')) {
          let url = window.location.origin + file.uri
          window.open(url, '_blank')
        }
      }
    },
    computed: {
      ...mapGetters([
        'currentProject',
        'managerView',

      ]),
      noteBy() {
        if (this.loading) return null
        return `${this.DV_note.user.fullName} at ${new Date(this.DV_note.createdAt).toLocaleString()}`
      },
      note_by() {
        if (this.contract || this.vehicle) 
        return `${this.note.user.full_name} at ${new Date(this.note.created_at).toLocaleString()}`
      },
      permitted() {
        return salut => !this.loading && this.note.userId === this.$currentUser.id && this._isallowed(salut)
      },
      C_editForManager() {
        return this.managerView.note && this.managerView.note.id == this.DV_note.id
      }
    },
    watch: {
      note: {
        handler: function(value) {
          this.DV_note = value
        },
        deep: true
      }
    }
  }
</script>

<style scoped lang="scss">
  .notes_input {
    border: 1px solid #ccc;
    border-radius: 5px;
    padding: 15px;
  }
  .note_body {
    padding-top: 10px;
    word-break: break-word;
    min-height: 80px;
    overflow-y: auto;
    font-size: 1.06rem;
  }
  .file-icon {
    cursor: pointer;
    font-size: 15px;
    color: gray;
    margin-right: 10px;
  } 
   .notes_form_modal.sweet-modal-overlay {
    z-index: 10000001;
  }
  .notes_form_modal.sweet-modal-overlay ::v-deep .sweet-modal {
    min-width: 80vw;
    max-height: 80vh;
    .sweet-content {
      padding-top: 30px;
      text-align: unset;
    }   
      .form-inside-modal {
      form {
        position: inherit !important;
      }
    }
    
  }
</style>
