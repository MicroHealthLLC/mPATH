<template>
  <div id="kanban">
    <div class="overflow-x-auto">
      <div class="d-flex" v-if="!loading">
        <div
          v-for="column in columns"
          :key="column.title"
          class="rounded-lg kan-col p-3 column-width mx-3"
          >
          <div class="row mb-4">
            <div class="col">
              <div class="badge">
                <span>{{column.title}}</span>
              </div>
            </div>
            <div class="col-2 px-0" v-if="viewPermit(kanbanType, 'write')">
              <span class="badge add" v-tooltip="`Add new ${kanbanType}`" @click.prevent="handleAddNew(column.stage)">
                <i class="fa fa-plus" aria-hidden="true"></i>
              </span>
            </div>
          </div>
          <draggable :move="handleMove" @change="handleChange" :list="column.tasks" :animation="100" ghost-class="ghost-card" group="tasks" :key="column.title" class="kanban-draggable">
            <div
              :is="cardShow"
              v-for="task in column.tasks"
              :key="`${task.id}_${column.stage.id}`"
              :task="task"
              :issue="task"
              fromView="kanban_view"
              class="mt-3 task-card"
            ></div>
          </draggable>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import Draggable from "vuedraggable"
import {mapActions, mapGetters} from 'vuex'
import TaskShow from './../dashboard/tasks/task_show'
import IssueShow from './../dashboard/issues/issue_show'

export default {
  name: "Kanban",
  components: {
    TaskShow,
    IssueShow,
    Draggable
  },
  props: ['stages', 'cards', 'kanbanType'],
  data() {
    return {
      loading: true,
      stageId: this.kanbanType == 'tasks' ? 'taskStageId' : 'issueStageId',
      columns: [],
      movingSlot: ''
    };
  },
  mounted() {
    this.setupColumns(Object.assign([], this.cards))
    this.loading = false
  },
  methods: {
    ...mapActions([
      'updateKanbanTaskIssues'
    ]),
    setupColumns(cards) {
      this.stageId = this.kanbanType === 'issues' ? 'issueStageId' : 'taskStageId'
      for (let stage of this.stages) {
        this.columns.push({
          stage: stage,
          title: stage.name,
          tasks: _.filter(cards, c => c[this.stageId] == stage.id)
        })
      }
    },
    handleMove(item) {
      this.movingSlot = item.relatedContext.component.$vnode.key
      return true
    },
    handleChange(item) {
      let type = 'added' in item ? 'added' : 'moved' in item ? 'moved' : null
      if (!type) return
      let task = Object.assign({}, item[type].element)
      if (type === 'added') task[this.stageId] = this.stages.find(s => s.name == this.movingSlot).id
      task.kanbanOrder = item[type].newIndex
      this.updateKanbanTaskIssues({task, type: this.kanbanType})
      this.movingSlot = ''
    },
    handleAddNew(stage) {
      this.$emit('on-add-new', stage)
    }
  },
  computed: {
    ...mapGetters([
      'viewPermit'
    ]),
    cardShow() {
      return this.kanbanType == 'tasks' ? 'TaskShow' : 'IssueShow'
    }
  },
  watch: {
    cards: {
      handler(value) {
        this.columns = []
        this.setupColumns(Object.assign([], value))
      }, deep: true
    }
  }
};
</script>

<style scoped lang="scss">
  .task-card {
    border-radius: 3px;
    cursor: move;
    background: #fff;
    border: none !important;
    border-top: solid 8px #ffa500 !important;
    padding: 6px;
    box-shadow: 0 2.5px 5px rgba(56,56, 56,0.19), 0 3px 3px rgba(56,56,56,0.23) !important;
  }
  .kanban-draggable {
    min-height: calc(100vh - 230px);
  }
  .column-width {
    min-width: 20rem;
    width: 20rem;
    max-height: calc(100vh - 130px);
    height: calc(100vh - 130px);
    overflow-y: auto;
  }
  .ghost-card {
    opacity: 0.5;
    background: #F7FAFC;
    border: 1px solid #4299e1;
  }
  .overflow-x-auto {
    overflow-x: auto;
  }
  .kan-col {
    background-color: #fafafa;
    box-shadow: 0 5px 10px rgba(56,56, 56,0.19), 0 6px 6px rgba(56,56,56,0.23);
  }
  .badge {
    display: flex;
    cursor: pointer;
    padding: 5px;
    transition: auto;
    color: #ffffff;
    font-size: 1rem;
    background-color: #17a2b8;
    justify-content: center;
    box-shadow: 0 2.5px 5px rgba(56,56, 56,0.19), 0 3px 3px rgba(56,56,56,0.23);
    &.add {
      background-color: #17a2b8;
      width: 40px;
    }
  }
</style>
