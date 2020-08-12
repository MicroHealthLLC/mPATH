<template>
  <div class="notes_input mt-2">
    <span class="close-icon" @click.stop="$emit('close-note-input')">
      <i class="fas fa-times"></i>
    </span>
    <center>{{title}}</center>
    <div class="form-group">
      <label class="badge badge-secondary">Note</label>
      <textarea class="form-control" v-model="DV_note.body" rows="5" v-validate="'required'" placeholder="your note comes here..."></textarea>
    </div>
    <div class="input-group mb-2">
      <div v-for="file in DV_note.noteFiles" class="d-flex mb-2 w-100">
        <div class="input-group-prepend">
          <div class="input-group-text clickable" :class="{'btn-disabled': !file.uri}" @click.prevent="downloadFile(file)">
            <i class="fas fa-file-image"></i>
          </div>
        </div>
        <input
          readonly
          type="text"
          class="form-control form-control-sm"
          :value="file.name || file.uri"
        />
        <button
          class="btn btn-danger btn-sm d-flex flex-row-reverse"
          @click.prevent="deleteFile(file)"
          >
          <i class="fas fa-times"></i>
        </button>
      </div>
    </div>
    <div class="form-group" >
      <attachment-input
        @input="addFile"
        :show-label="true"
      />
    </div>
    <div class="d-flex form-group mt-4">
      <button
        :disabled="!readyToSave"
        class="btn btn-success btn-sm"
        @click.prevent.stop="saveNote"
        >
        Save
      </button>
    </div>
  </div>
</template>

<script>
  import axios from 'axios'
  import humps from 'humps'
  import http from './../../../common/http'
  import AttachmentInput from './../../shared/attachment_input'
  import {mapGetters} from 'vuex'

  export default {
    props: ['facility', 'note', 'title'],
    components: {AttachmentInput},
    data() {
      return {
        DV_note: {
          body: '',
          noteFiles: []
        }
      }
    },
    mounted() {
      if (this.note) {
        this.DV_note = Object.assign({}, this.note)
        this.DV_note.noteFiles = []
        this.addFile(this.note.attachFiles)
      }
    },
    methods: {
      addFile(files) {
        for (let file of files) {
          file.guid = this.guid()
          this.DV_note.noteFiles.push(file)
        }
        this.$forceUpdate()
      },
      deleteFile(file) {
        if (!file) return;

        var confirm = window.confirm(`Are you sure, you want to delete attachment?`)
        if (!confirm) return;

        if (file.uri) {
          http.put(`/projects/${this.currentProject.id}/facilities/${this.facility.id}/notes/${this.note.id}/destroy_file.json`, {file: file})
          .then((res)=> {
            _.remove(this.DV_note.noteFiles, (f) => f.guid === file.guid)
            this.$forceUpdate()
          })
          .catch((error) => {
            console.log("Unable to destroy the file..")
          })
        }
        else if (file.name) {
          _.remove(this.DV_note.noteFiles, (f) => f.guid === file.guid)
          this.$forceUpdate()
        }
      },
      saveNote() {
        this.$validator.validate().then((success) =>
        {
          if (!success) {
            this.showErrors = true
            return;
          }

          var formData = new FormData()
          formData.append('note[body]', this.DV_note.body)
          for (var file of this.DV_note.noteFiles) {
            if (!file.id) {
              formData.append('note[note_files][]', file)
            }
          }

          var url = `/projects/${this.currentProject.id}/facilities/${this.facility.id}/notes.json`
          var method = "POST"
          var callback = "note-created"

          if (this.note && this.note.id) {
            url = `/projects/${this.currentProject.id}/facilities/${this.facility.id}/notes/${this.note.id}.json`
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
          .then((response)=> {
            this.$emit(callback, humps.camelizeKeys(response.data))
          })
          .catch((err)=> {
            console.log(err)
          })
        })
      },
      downloadFile(file) {
        let url = window.location.origin + file.uri
        window.open(url, '_blank');
      }
    },
    computed: {
      ...mapGetters([
        'currentProject'
      ]),
      readyToSave() {
        return (
          this.DV_note &&
          this.DV_note.body !== ''
        )
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
  .close-icon {
    float: right;
    cursor: pointer;
    display: flex;
    flex-direction: row-reverse;
  }
</style>
