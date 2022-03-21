<template>
  <div class="notes-form" :class="{'fixed-form-mapView':isMapView}">
      <div v-if="isMapView" class="d-flex align-items-center mt-0 mb-2">
        <span class="fbody-icon"> <i class="far fa-file-contract mh-orange-text"></i></span>
        <h4 class="f-head mb-0">{{ contract.name || contract.nickname}}</h4>
      </div>
       <div class="d-flex form-group sticky mb-2">
        <button
          :disabled="!readyToSave || !contentLoaded"
          class="btn btn-success sticky-btn btn-sm"
          @click.prevent.stop="saveNote"
          data-cy="note_save_btn"
          >
          Save
        </button>
        <button
          class="btn btn-sm btn-warning sticky-btn ml-2"
          @click.prevent="close"
          data-cy="note_close_btn"
          >
          Close
        </button>
        <button         
          @click.prevent="deleteNote"
          class="btn btn-sm btn-danger sticky-btn ml-auto"
          data-cy="note_delete_btn"
          v-if="_isallowed('delete')"
          >
          <i class="fas fa-trash-alt mr-2"></i>
          Delete
        </button>
       
      </div>

   <div class="notes_input mt-2 paperLook formTitle" :class="{'_disabled': !contentLoaded, 'border-0': from == 'manager_view'}">
      <div class="form-group">
       <label class="font-sm">
         <h5>Note</h5>
      </label>
      <textarea class="form-control" 
        v-model="contractNote.body" 
        rows="5" 
        v-validate="'required'"
        placeholder="Write note here..." 
        data-cy="note_details">
      </textarea>
     </div>
      <div class="input-group mb-2">
        <label>Files Associated with this Note:</label>
        <div v-for="(file, index) in files" :key="index" class="d-flex mb-2 w-100">
          <div class="input-group-prepend">
            <div class="input-group-text clickable" :class="{'btn-disabled': !file.uri}" @click.prevent="downloadFile(file)">
              <i class="far fa-file mr-2"></i>
            </div>
          </div>    

          <span 
            v-if="file"         
            class="form-control form-control-sm mw-95"          
          > 
            {{ file.name }}
          </span>
          <div
            :class="{'_disabled': !contentLoaded}"
            class="del-check clickable"
            @click.prevent="deleteFile(file.id, index)"
            >
            <i class="fas fa-times"></i>
          </div>
        </div>
      </div>
      <div class="form-group" >
          <AttachmentInput
          @input="addFile"
          :show-label="true"   
        />
      </div>

    </div>
    <!-- <div v-if="loading" class="load-spinner spinner-border text-dark" role="status"></div> -->
  </div>
</template>

<script>
  import {mapGetters, mapMutations, mapActions} from 'vuex'
  import AttachmentInput from './../../shared/attachment_input'

  export default {
    name: 'ContractNotesForm',
    props: ['title', 'from', 'contract'],    
    components: {
      AttachmentInput
    },
    data() {
      return {
       destroyFileIds: []
      }
    },
    mounted() {
     if (this.$route.params.noteId != "new") {
      this.fetchContractNote({
        id: this.$route.params.noteId,
        ...this.$route.params,
      });
    }
   },
    methods: {
      ...mapMutations([
        'setTaskForManager',
        'updateNotesHash',
        'SET_CONTRACT_NOTE',
        'SET_CONTRACT_NOTE_STATUS'

      ]),
      ...mapActions([
        'noteDeleted',
        'addContractNote',
        'deleteContractNote',
        'fetchContractNote',
        'updateContractNote'
      ]),
     _isallowed(salut) {
             return this.checkPrivileges("contract_notes_form", salut, this.$route)

        let fPrivilege = this.$contractPrivileges[this.$route.params.programId][this.$route.params.contractId]
        let permissionHash = {"write": "W", "read": "R", "delete": "D"}
        let s = permissionHash[salut]
        return fPrivilege.notes.includes(s);
     },
      addFile(files) {
      files.forEach((file) => {
        file.guid = this.guid();
        this.contractNote.attach_files.push(file);
      });
      },
    deleteFile(id, index) {
      this.$confirm(
        `Are you sure you want to delete this file?`,
        "Confirm Delete",
        {
          confirmButtonText: "Delete",
          cancelButtonText: "Cancel",
          type: "warning",
        }
      )
        .then(() => {
          this.files.splice(index, 1);
          if (id) {
            this.destroyFileIds.push(id);
          }
        })
        .catch(() => {});
    },
    saveNote() {
      this.$validator.validate().then((success) =>
      {
        if (!success || !this.contentLoaded) {
          this.showErrors = !success
          return;
        }
      let noteData = {
        note: {
          body: this.contractNote.body,
          destroy_file_ids: [...this.destroyFileIds],
          attach_files: [...this.files.filter((file) => !file.id)],
          
        },
      };
        if (this.contractNote.id) {
        this.updateContractNote({
          ...noteData,
          ...this.$route.params,
        }); 
      } else if (!this.contractNote.id || this.$route.params.noteId == 'new')  {
        noteData.note.user_id = this.$currentUser.id;
        this.addContractNote({
          ...noteData,
          ...this.$route.params,
        });
      }         
      })
    },
    deleteNote() {
         this.$confirm(
        `Are you sure you want to delete this note?`,
        "Confirm Delete", 
        {
          confirmButtonText: "Delete",
          cancelButtonText: "Cancel",
          type: "warning",
        }
      )
        .then(() => {
          this.deleteContractNote({ id: this.contractNote.id, contractId: this.$route.params.contractId });
          console.log({ id: this.contractNote.id, ...this.$route.params })
          this.$message({
            type: "success",
            message: "Note successfully deleted",
            showClose: true,
          });
           this.$router.push(
            `/programs/${this.$route.params.programId}/${this.tab}/contracts/${this.$route.params.contractId}/notes`
          );
        })
        .catch(() => {
          this.$message({
            type: "info",
            message: "Delete canceled",
            showClose: true,
          });
        });      
    },
    close() {
      this.SET_CONTRACT_NOTE({}),
          this.$router.push(
            `/programs/${this.$route.params.programId}/${this.tab}/contracts/${this.$route.params.contractId}/notes`
          );
        },
      cancelNoteSave() {
        this.$emit('close-note-input')
        this.setTaskForManager({key: 'note', value: null})
      },
      downloadFile(file) {
        let url = window.location.origin + file.uri
        window.open(url, '_blank');
      }
    },
    computed: {
      ...mapGetters([
        'getFacilityProjectOptions',
        'contractNote',
        'contentLoaded',
        'contractNoteStatus',
        'currentProject',
         'managerView'
      ]),
      files(){
        if(
         this.contractNote &&
         this.contractNote.attach_files &&
         this.contractNote.attach_files.length > 0
         ){
          return this.contractNote.attach_files.map(f => f)
        } else return []
      },
      readyToSave() {
        return (
          this.contractNote &&
          this.exists(this.contractNote.body)
          // this.DV_note &&
          // this.exists(this.DV_note.body) &&
          // this.exists(this.DV_note.facilityProjectId)
        )
      },
         tab() {
      if (this.$route.path.includes("map")) {
        return "map";
      } else if (this.$route.path.includes("sheet")) {
        return "sheet";
     } else if (this.$route.path.includes("calendar")) {
        return "calendar";
      } else if (this.$route.path.includes("lessons")) {
        return "lessons";
      } else {
        return "kanban";
      }
    },
      isMapView() {
        return this.$route.name === 'ProjectMapView'
      },
      titleText() {
        return _.isEmpty(this.contractNote) ? "Add Note" : "Edit Note"
      },
    },
    watch: {
     contractNoteStatus: {
        handler() {
            if (this.contractNoteStatus == 200) {
            this.$message({
                message: `Note saved successfully.`,
                type: "success",
                showClose: true,
            });
            this.SET_CONTRACT_NOTE_STATUS(0);
            }       
        },
    },
   }
  }
</script>

<style scoped lang="scss">
  .notes_input {
    border: 1px solid #ccc;
    border-radius: 5px;
    padding: 15px;
  }
  .fixed-form-mapView {
    width: 100%;
    top:0;
    position: absolute !important;
  }
  .close-icon {
    float: right;
    cursor: pointer;
    display: flex;
    flex-direction: row-reverse;
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
  .formTitle {
    padding-top: 25px;
  }
  .paperLook {
    box-shadow: 0 10px 20px rgba(0,0,0,0.19), 0 6px 6px rgba(0,0,0,0.23);
    padding-bottom: 20px;
    margin-bottom: 10px;
    position: relative;
  }
  .sticky-btn {
    margin-top: 5px;
    margin-bottom: 5px;
    box-shadow: 0 5px 10px rgba(56,56, 56,0.19), 0 1px 1px rgba(56,56,56,0.23);
  }
  .sticky {
    position: sticky;
    position: -webkit-sticky;
    justify-content: center;
    margin-bottom: -2.5rem;
    z-index: 1000;
    left: 15;
    top: 0;
    width: 100%;
    padding: 6px;
    background-color: rgba(237, 237, 237, 0.85);
    box-shadow: 0 10px 20px rgba(56,56, 56,0.19), 0 3px 3px rgba(56,56,56,0.23);
  }
  .fa-building {
    font-size: large !important;
    color: #383838 !important;
  }
</style>
