<template>
  <div class="notes-form" :class="{'fixed-form-mapView':isMapView}">
      <div v-if="isMapView" class="d-flex align-items-center mt-0 mb-2">
        <span class="fbody-icon"><i class="fal fa-clipboard-list mh-green-text"></i></span>
        <h4 class="f-head mb-0">{{DV_facility.facilityName}}</h4>
      </div>
       <div class="d-flex form-group sticky mb-2">
        <button
          :disabled="!readyToSave || loading"
          class="btn btn-success sticky-btn btn-sm"
          @click.prevent.stop="saveNote"
          data-cy="note_save_btn"
          >
          Save
        </button>
        <button
          class="btn btn-sm btn-warning sticky-btn ml-2"
          @click.prevent="cancelNoteSave"
          data-cy="note_close_btn"
          >
          Close
        </button>
        <button
          v-if="_isallowed('delete')"
          @click.prevent="deleteNote"
          class="btn btn-sm btn-danger sticky-btn ml-auto"
          data-cy="note_delete_btn"
          >
          <i class="fas fa-trash-alt mr-2"></i>
          Delete
        </button>
      </div>

   <div class="notes_input mt-2 paperLook formTitle" :class="{'_disabled': loading, 'border-0': from == 'manager_view'}" :load="log($route.params.projectId)">
      <div class="form-group">
       <label class="font-sm"><h5>Note</h5></label>
        <textarea class="form-control" v-model="DV_note.body" rows="5" v-validate="'required'" placeholder="Write note here..." data-cy="note_details"></textarea>

        <!-- <div class="simple-select form-group mx-0">
          <label class="font-sm">*Project:</label>
          <multiselect
            v-model="selectedFacilityProject"
            v-validate="'required'"
            track-by="id"
            label="name"
            placeholder="Select Facility"
            :options="getFacilityProjectOptions"
            :searchable="false"
            select-label="Select"
            deselect-label="Enter to remove"
            :disabled="!_isallowed('write')"
            data-cy="facility_project_id"
            >
            <template slot="singleLabel" slot-scope="{option}">
              <div class="d-flex">
                <span class='select__tag-name'>{{option.name}}</span>
              </div>
            </template>
          </multiselect>
        </div> -->

      </div>
      <div class="input-group mb-2">
        <label>Files Associated with this Note:</label>
        <div v-for="file in filteredFiles" class="d-flex mb-2 w-100">
          <div class="input-group-prepend">
            <div class="input-group-text clickable" :class="{'btn-disabled': !file.uri}" @click.prevent="downloadFile(file)">
              <i class="fas fa-file-image"></i>
            </div>
          </div>

          <input
            readonly
            type="text"
            class="form-control form-control-sm mw-95"
            :value="file.name || file.uri"
          />
          <div
            :class="{'_disabled': loading}"
            class="del-check clickable"
            @click.prevent="deleteFile(file)"
            >
            <i class="fas fa-times"></i>
          </div>
        </div>
      </div>
      <div class="form-group" >
        <attachment-input
          @input="addFile"
          :show-label="true"
        />
      </div>

    </div>
    <div v-if="loading" class="load-spinner spinner-border text-dark" role="status"></div>
  </div>
</template>

<script>
  import axios from 'axios'
  import humps from 'humps'
  import {mapGetters, mapMutations, mapActions} from 'vuex'
  import AttachmentInput from './../../shared/attachment_input'
  import { API_BASE_PATH } from '../../../mixins/utils'

  import MessageDialogService from "../../../services/message_dialog_service";

export default {
    props: ['facility', 'note', 'title', 'from'],
    components: {
      AttachmentInput
    },
    data() {
      return {
        DV_note: this.INITIAL_NOTE_STATE(),
        DV_facility: Object.assign({}, this.facility),
        selectedFacilityProject: null,
        loading: true,
        destroyedFiles: []
      }
    },
    mounted() {
      if (!_.isEmpty(this.note)) {
        this.loadNote(this.note)
      } else {
        this.loading = false
        this.loadNote(this.DV_note)
      }
    },
    methods: {
      ...mapMutations([
        'setTaskForManager',
        'updateNotesHash'
      ]),
      ...mapActions([
        'noteDeleted'
      ]),
      INITIAL_NOTE_STATE() {
        return {
          facilityProjectId: this.facility.id,
          body: '',
          noteFiles: []
        }
      },
      log(e){
        console.log(e)

      },
     _isallowed(salut) {
        return this.checkPrivileges("notes_form", salut, this.$route)

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
      loadNote(note) {
        this.DV_note = {...this.DV_note, ..._.cloneDeep(note)}     
        this.DV_note.facilityProjectId = this.facility.id       
        this.selectedFacilityProject = this.getFacilityProjectOptions.find(t => t.id === this.DV_note.facilityProjectId)
        if (this.DV_note.attachFiles) this.addFile(this.DV_note.attachFiles, false)
        this.$nextTick(() => {
          this.errors.clear()
          this.$validator.reset()
          this.loading = false;
        })
      },
      addFile(files) {
        let _files = [...this.DV_note.noteFiles]
        for (let file of files) {
          file.guid = this.guid()
          _files.push(file)
        }
        this.DV_note.noteFiles = _files
      },
      deleteFile(file) {
        if (!file) return;
        this.$confirm(`Are you sure you want to delete attachment?`, 'Confirm Delete', {
          confirmButtonText: 'Delete',
          cancelButtonText: 'Cancel',
          type: MessageDialogService.msgTypes.WARNING
        }).then(() => {
          if (file.uri) {
            var index = this.DV_note.noteFiles.findIndex(f => f.guid === file.guid)
            Vue.set(this.DV_note.noteFiles, index, {...file, _destroy: true})
            this.destroyedFiles.push(file)
          }
          else if (file.name) {
            this.DV_note.noteFiles.splice(this.DV_note.noteFiles.findIndex(f => f.guid === file.guid), 1)
          }
        });
      },
      saveNote(){
        console.log(this.$route.params.projectId)
        console.log(this.facility.id)        
        this.$validator.validate().then((success) =>
        {
          if (!success || this.loading) {
            this.showErrors = !success
            return;
          }

          this.loading = true
          var formData = new FormData()
          formData.append('facility_project_id', this.DV_note.facilityProjectId)
          formData.append('note[body]', this.DV_note.body)
          formData.append('note[destroy_file_ids]', _.map(this.destroyedFiles, 'id'))
          for (var file of this.DV_note.noteFiles) {
            if (!file.id) {
              formData.append('note[note_files][]', file)
            }
          }

          var url = `${API_BASE_PATH}/programs/${this.currentProject.id}/projects/${this.$route.params.projectId}/notes.json`
          var method = "POST"
          var callback = "note-created"

          if (this.note && this.note.id) {
            url = `${API_BASE_PATH}/programs/${this.currentProject.id}/projects/${this.$route.params.projectId}/notes/${this.note.id}.json`
            method = "PUT"
            callback = "note-updated"
          }
          
          axios({
            method: method,
            url: url,
            data: formData,
            headers: {
              'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').attributes['content'].value
            }
          })
          .then((response) => {
            // this.$emit(callback, humps.camelizeKeys(response.data))             
            let note = response.data.note 
            var responseNote = humps.camelizeKeys(note)
            this.loadNote(responseNote)   
            this.updateNotesHash({ note: responseNote, facilityId: this.$route.params.projectId})
            if (this.$route.path.includes("sheet")) {
              this.$router.push(`/programs/${this.$route.params.programId}/sheet/projects/${this.$route.params.projectId}/notes/${note.id}`);
            } else if (this.$route.path.includes("map")) {
              this.$router.push(`/programs/${this.$route.params.programId}/map/projects/${this.$route.params.projectId}/notes/${note.id}`);           
            }
            MessageDialogService.showDialog({
              response: response
            });
          })
          .catch((err) => {
            console.log(err)
          })
          .finally(() => {
            this.loading = false
          })
        })
      },
      deleteNote() {
        this.$confirm(`Are you sure you want to delete this note?`, 'Confirm Delete', {
          confirmButtonText: 'Delete',
          cancelButtonText: 'Cancel',
          type: MessageDialogService.msgTypes.WARNING
        }).then(() => {
          // TODO: this is sending facilityProjectId in facilityId parameter. So now we will process with note id
          this.noteDeleted({note: this.DV_note, facilityId: this.$route.params.projectId, projectId: this.currentProject.id, cb: () => this.cancelNoteSave() })
        });
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
        'currentProject',
         'managerView'
      ]),
      readyToSave() {
        return (
          this.DV_note &&
          this.exists(this.DV_note.body)
          // this.DV_note &&
          // this.exists(this.DV_note.body) &&
          // this.exists(this.DV_note.facilityProjectId)
        )
      },
      isMapView() {
        return this.$route.name === 'ProjectMapView'
      },
      titleText() {
        return _.isEmpty(this.note) ? "Add Note" : "Edit Note"
      },
      filteredFiles() {
        return _.filter(this.DV_note.noteFiles, f => !f._destroy)
      }
    },
    watch: {
      selectedFacilityProject: {
        handler: function(value) {
          if(value){
            this.DV_note.facilityProjectId = value.id  
          }
        }, deep: true
      },
      note: {
        handler: function(value) {
          this.loadNote(this.note);
        }
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
