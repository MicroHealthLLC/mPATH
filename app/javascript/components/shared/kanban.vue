<template>
  <div id="kanban" data-cy="kanban">

    <div class="overflow-x-auto">
      <div class="d-flex py-2" v-if="!loading">
        <div
          v-for="column in columns"
          :key="column.title"
          class="rounded-lg kan-col my-2 p-3 column-width mx-3"
          data-cy="kanban_col"
          >
          <div class="row mb-3 kan-header" data-cy="kanban_col_title">
            <div class="col">
              <div class="badge">
                <span>{{column.title}}</span>
              </div>
            </div>
            <div class="col-2 px-0" v-if="viewPermit(kanbanType, 'write')" data-cy="kanban_add_btn">
              <span class="badge add" v-tooltip="`Add new ${kanbanType}`" @click.prevent="handleAddNew(column.stage)">
                <i class="fa fa-plus" aria-hidden="true"></i>
              </span>
            </div>
            <!-- <div class="input-group">
              <div class="input-group-prepend">
                <span class="input-group-text" id="search-addon"><i class="fa fa-search"></i></span>
              </div>
              <input type="text" class="form-control form-control-sm" placeholder="Search tasks.." aria-label="Search" aria-describedby="search-addon"v-on:input="handleSearchQueryChange" :data-stage-id="`${column.stage.id}`" :data-kanban-type="`${kanbanType}`">
            </div> -->
          </div>
          <div class="kan-body">
          <draggable :move="handleMove" @change="(e) => handleChange(e, column.tasks)" :list="column.tasks" :animation="100" ghost-class="ghost-card" group="tasks" :key="column.title" class="kanban-draggable" data-cy="kanban_draggable">
            <div
              :is="cardShow"
              v-for="task in column.tasks"
              :key="`${task.id}_${column.stage.id}`"
              :task="task"
              :issue="task"
              fromView="kanban_view"
              class="mt-2 task-card"
            ></div>
          </draggable>
          </div>
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
    handleChange(item, tasks) {
      if (tasks.length > 0) {
        let projectId = tasks[0].projectId
        let facilityId = tasks[0].facilityId
        let data = {[this.kanbanType]: {}}
        for (let task of tasks) {
          data[this.kanbanType][task.id] = {}
          data[this.kanbanType][task.id].kanbanOrder = tasks.indexOf(task)
          if ('added' in item) {
            data[this.kanbanType][task.id][this.stageId] = this.stages.find(s => s.name == this.movingSlot).id
          }
        }
        this.updateKanbanTaskIssues({projectId, facilityId, data, type: this.kanbanType})
        this.movingSlot = ''
      }
    },
    handleAddNew(stage) {
      this.$emit('on-add-new', stage)
    },
    handleSearchQueryChange(event){
      this.$emit('on-search-change', event.target)
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
    margin-right: 18px;
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
    min-width: 18rem;
    width: 18rem;
    height: 76vh;
    overflow-y: hidden;
  }

  .ghost-card {
    opacity: 0.5;
    background: #F7FAFC;
    border: 1px solid #4299e1;
  }
  .overflow-x-auto {
    overflow-x: auto;
    margin-right: -10px;
    overflow-y: hidden !important;
  }
  .kan-col {
    background-color: #ededed;
    box-shadow: 0 5px 10px rgba(56,56, 56,0.19), 0 6px 6px rgba(56,56,56,0.23);
    position: relative;  
    overflow: hidden;
    padding-bottom: 5px;
  }

  .kan-body {
    position: absolute;
    max-height: 73vh;
    overflow-y: scroll !important; 
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
