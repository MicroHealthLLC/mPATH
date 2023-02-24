
<template>
<div>
  <h1>TEST</h1>
</div>   
</template>


<script>
  import http from './../../../common/http'
  import {mapGetters, mapMutations} from 'vuex'
  import {SweetModal} from 'sweet-modal-vue'


  export default {
    props: ['facility', 'note', 'from'],
    components: {
      SweetModal
    },
    data() {
      return {
        show: true,
        loading: true,
        DV_note: null,  
        // has_note: false        
      }
    },
    mounted() {
      if (!_.isEmpty(this.note)) {
        this.loading = false
        this.DV_note = this.note
      }
    },
    methods: {
      ...mapMutations([
        'setTaskForManager'
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
     editNoteMode() {
        if (this.from == "manager_view") {                
          this.setTaskForManager({key: 'note', value: this.DV_note})
          this.$refs.notesFormModal && this.$refs.notesFormModal.open() 
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
        var confirm = window.confirm(`Are you sure, you want to delete this note?`)
        if (!confirm) return;

        http
          .delete(`#{API_BASE_PATH}/programs/${this.currentProject.id}/projects/${this.facility.id}/notes/${this.note.id}.json`)
          .then((res) => {
            this.loading = false
            this.$emit('note-deleted', this.note)
          })
          .catch((err) => {
            this.loading = false
            console.error(err)
          })
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
        'managerView'
      ]),
      noteBy() {
        if (this.loading) return null
        return `${this.DV_note.user.fullName} at ${new Date(this.DV_note.createdAt).toLocaleString()}`
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
  // .notes_form_modal.sweet-modal-overlay /deep/ .sweet-modal {
  //   min-width: 80vw;
  //   max-height: 80vh;
  //   .sweet-content {
  //     padding-top: 30px;
  //     text-align: unset;
  //   }   
  //     .form-inside-modal {
  //     form {
  //       position: inherit !important;
  //     }
  //   }
    
  // }
</style>
