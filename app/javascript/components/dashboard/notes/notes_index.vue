<template>
  <div>
    <div v-if="_isallowed('write') && newNote" class="mb-3">
      <notes-form
        :facility="DV_facility"
        @close-note-input="newNote=false"
        @note-created="noteCreated"
      />
    </div>
    <div v-else>
      <div class="mb-4 d-flex mx-2" :class="{'align-items-center justify-content-between': _isallowed('write')}">
        <div class="input-group" :class="{'search-tab': _isallowed('write')}">
          <div class="input-group-prepend">
            <span class="input-group-text" id="search-addon"><i class="fa fa-search"></i></span>
          </div>
          <input type="text" class="form-control form-control-sm" placeholder="type to search.." aria-label="Search" aria-describedby="search-addon" v-model="notesQuery">
        </div>
        <div v-if="_isallowed('write')">
          <button @click.stop="newNote=true" class="btn btn-sm btn-light">Add Note</button>
        </div>
      </div>
      <div v-if="_isallowed('read')">
        <div v-if="filteredNotes.length > 0" v-for="note in filteredNotes">
          <notes-show
            :facility="DV_facility"
            :note="note"
            @note-updated="noteUpdated"
            @note-deleted="noteDeleted"
          />
        </div>
        <div v-show="filteredNotes.length <= 0" class="text-danger ml-3">No notes found..</div>
      </div>
      <div v-else class="text-danger mx-2 my-4">You don't have permissions to read!</div>
    </div>
  </div>
</template>

<script>
  import NotesForm from './notes_form'
  import NotesShow from './notes_show'

  export default {
    name: 'NotesIndex',
    components: {NotesForm, NotesShow},
    props: ['facility'],
    data() {
      return {
        loading: true,
        newNote: false,
        notesQuery: '',
        DV_facility: Object.assign({}, this.facility)
      }
    },
    methods: {
      noteCreated(note) {
        this.newNote = false
        this.DV_facility.notes.unshift(note)
      },
      noteUpdated(note) {
        var index = this.DV_facility.notes.findIndex(n=> n.id == note.id)
        if (index > -1) {
          this.DV_facility.notes[index] = note
        }
        this.$forceUpdate()
      },
      noteDeleted(note) {
        _.remove(this.DV_facility.notes, (n) => n.id == note.id)
        this.$forceUpdate()
      }
    },
    computed: {
      filteredNotes() {
        if (this.notesQuery.trim() !== '') {
          const resp = new RegExp(_.escapeRegExp(this.notesQuery.trim().toLowerCase()), 'i')
          const isMatch = (result) => resp.test(result.body)
          return _.filter(this.DV_facility.notes, isMatch)
        }
        return this.DV_facility.notes;
      },
      _isallowed() {
        return salut => this.$currentUser.role == "superadmin" || this.$permissions.notes[salut]
      }
    },
    watch: {
      facility: {
        handler: function(value) {
          this.DV_facility = Object.assign({}, value)
          this.loading = true
        },
        deep: true
      }
    }
  }
</script>

<style lang="scss" scoped>
  .search-tab {
    width: 80%;
  }
</style>
