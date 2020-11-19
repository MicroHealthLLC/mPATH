<template>
  <div id="kanban">
    <div class="overflow-x-auto">
      <div class="d-flex" v-if="!loading">
        <div
          v-for="column in columns"
          :key="column.title"
          class="bg-light rounded-lg p-3 column-width mr-4"
        >
          <p class="badge"><span>{{column.title}}</span></p>
          <draggable :move="handleChange" :list="column.tasks" :animation="100" ghost-class="ghost-card" group="tasks" :key="column.title" >
            <div
              :is="cardShow"
              v-for="task in column.tasks"
              :key="task.id"
              :task="task"
              :issue="task"
              class="mt-3 cursor-move task-card"
            ></div>
          </draggable>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import Draggable from "vuedraggable"
import TaskShow from './../dashboard/tasks/task_show'
import IssueShow from './../dashboard/issues/issue_show'
import {mapActions} from 'vuex'

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
      columns: []
    };
  },
  mounted() {
    for (let stage of this.stages) {
      this.columns.push({
        stage: stage,
        title: stage.name,
        tasks: _.filter(this.cards, c => c[this.stageId] == stage.id)
      })
    }
    this.loading = false
  },
  methods: {
    ...mapActions([
      'updateWatchedTasks',
      'updateWatchedIssues'
    ]),
    handleChange(item) {
      let task = item.draggedContext.element
      task[this.stageId] = this.stages.find(s => s.name == item.relatedContext.component.$vnode.key).id
      if (this.kanbanType === 'tasks') this.updateWatchedTasks(task)
      else if (this.kanbanType === 'issues') this.updateWatchedIssues(task)
      return true;
    }
  },
  computed: {
    cardShow() {
      return this.kanbanType == 'tasks' ? 'TaskShow' : 'IssueShow'
    }
  }
};
</script>

<style scoped>
  .task-card {
    border: 1px solid;
    border-radius: 3px;
    background: #fff;
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
  .badge {
    display: flex;
    cursor: pointer;
    padding: 5px;
    transition: auto;
    color: #fff;
    padding: 5px;
    font-size: 1rem;
    background-color: #17a2b8;
    justify-content: center;
  }
  .cursor-move {
    cursor: move;
  }
</style>
