<template>
  <div id="notes-index">
    <div v-if="_isallowed('write') && newNote" class="mb-3">
      <notes-form
        title="Add Note"
        :facility="DV_facility"
        @close-note-input="newNote=false"
        @note-created="noteCreated"
      ></notes-form>
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
          <button @click.stop="addNewNote" class="btn btn-sm btn-light">Add Note</button>
        </div>
      </div>
      <div class="form-check-inline justify-content-end w-100 pr-3 mb-2 font-sm">
        <label class="form-check-label">
          <input type="checkbox" class="form-check-input" v-model="C_myNotes">My Notes
        </label>
        <label class="form-check-label ml-2 text-primary">
          Total: {{filteredNotes.length}}
        </label>
      </div>
      <div v-if="_isallowed('read')">
        <div v-if="filteredNotes.length > 0" v-for="note in filteredNotes">
          <notes-show
            :facility="DV_facility"
            :note="note"
            :from="from"
            @note-updated="noteUpdated"
            @note-deleted="noteDeleted"
          ></notes-show>
        </div>
        <div v-show="filteredNotes.length <= 0" class="text-danger ml-3">No notes found..</div>
      </div>
      <div v-else class="text-danger mx-2 my-4">You don't have permissions to read!</div>
    </div>
  </div>
</template>

<script>
  import {mapMutations, mapGetters} from "vuex"
  import NotesForm from './notes_form'
  import NotesShow from './notes_show'

  export default {
    name: 'NotesIndex',
    components: {NotesForm, NotesShow},
    props: ['facility', 'from'],
    data() {
      return {
        loading: true,
        newNote: false,
        notesQuery: '',
        DV_facility: Object.assign({}, this.facility)
      }
    },
    methods: {
      ...mapMutations([
        'setTaskForManager',
        'setMyActionsFilter'
      ]),
      addNewNote() {
        if (this.from == "manager_view") {
          this.setTaskForManager({key: 'note', value: {}})
        } else {
          this.newNote = true
        }
      },
      noteCreated(note) {
        this.newNote = false
        this.DV_facility.notes.unshift(note)
      },
      noteUpdated(note) {
        var index = this.DV_facility.notes.findIndex(n => n.id == note.id)
        if (index > -1) Vue.set(this.DV_facility.notes, index, note)
      },
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
      _isallowed() {
        return salut => this.$currentUser.role == "superadmin" || this.$permissions.notes[salut]
      },
      C_myNotes: {
        get() {
          return _.map(this.myActionsFilter, 'value').includes('notes')
        },
        set(value) {
          if (value) this.setMyActionsFilter([...this.myActionsFilter, {name: "My Notes", value: "notes"}])
          else this.setMyActionsFilter(this.myActionsFilter.filter(f => f.value !== "notes"))
        }
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

  #notes-index {
    height: 500px;
  }
  .search-tab {
    width: 80%;
  }
</style>
