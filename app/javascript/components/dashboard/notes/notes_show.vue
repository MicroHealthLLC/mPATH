<template>
  <div v-if="!loading" class="notes_show mb-5 mx-2">
    <div v-if="show">
      <div v-if="permitted" class="crud-actions mx-3 float-right">
        <span class="mr-2 font-sm edit-action" @click.stop="show = false">
          <i class="fas fa-edit"></i>
        </span>
        <span class="font-sm delete-action" @click.stop="deleteNote">
          <i class="fas fa-trash-alt"></i>
        </span>
      </div>
      <div class="note_by my-2">
        <span class="badge badge-secondary">Note by</span>
        <span class="text-muted font-sm">{{noteBy}}</span>
      </div>
      <div v-if="DV_note.attachFiles.length > 0" class="note_files">
        <span class="badge badge-secondary mr-3">Note Files</span>
        <span v-for="file in DV_note.attachFiles">
          <span class="file-icon" v-tooltip.bottom="`${file.name}`" @click="downloadFile(file)">
            <i class="fas fa-file-alt"></i>
          </span>
        </span>
      </div>
      <div class="note_body my-2 font-sm">
        {{DV_note.body}}
      </div>
    </div>
    <div v-else>
      <notes-form
        :note="DV_note"
        :facility="facility"
        @close-note-input="show = true"
        @note-updated="noteUpdated"
      />
    </div>
  </div>
</template>

<script>
  import http from './../../../common/http'
  import NotesForm from './notes_form'

  export default {
    props: ['facility', 'note'],
    components: {NotesForm},
    data() {
      return {
        show: true,
        loading: true,
        DV_note: null
      }
    },
    mounted() {
      if (this.note) {
        this.loading = false
        this.DV_note = this.note
      }
    },
    methods: {
      noteUpdated(note) {
        this.show = true
        this.$emit('note-updated', note)
      },
      deleteNote() {
        var confirm = window.confirm(`Are you sure, you want to delete this note?`)
        if (!confirm) return;

        http
          .delete(`/projects/${this.$route.params.projectId}/facilities/${this.facility.id}/notes/${this.note.id}.json`)
          .then((res) => {
            this.loading = false;
            this.$emit('note-deleted', this.note);
          })
          .catch((err) => {
            this.loading = false;
            console.error(err);
          })
      },
      downloadFile(file) {
        let url = window.location.origin + file.uri
        window.open(url, '_blank');
      }
    },
    computed: {
      noteBy() {
        if (this.loading) return null
        else return `${this.DV_note.user.firstName} ${this.DV_note.user.lastName} at ${new Date(this.DV_note.createdAt).toUTCString()}`
      },
      permitted() {
        if (this.loading) return false
        return this.note.userId === this.$currentUser.id && this._isallowed
      },
      _isallowed() {
        return ["admin", "subscriber"].includes(this.$currentUser.role)
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
    border: 1px solid #ccc;
    border-radius: 5px;
    padding: 10px;
    word-break: break-word;
    max-height: 200px;
    overflow-y: auto;
  }
  .file-icon {
    cursor: pointer;
    font-size: 15px;
    color: gray;
    margin-right: 10px;
  }
</style>
