<template>
  <div id="kanban" data-cy="kanban">
    <div>
      <div class="d-flex">
        <div
          v-for="column in columns"
          :key="column.title"          
          class="rounded-lg kan-col py-2 unset mt-4 mb-2 mr-4"        
          :class="{'no-stage': column.stage.id == null}"
          :style="`${ column.stage.id == null ? 'width:1rem' : 'min-width:18.5rem'  }`"
          data-cy="kanban_col"
          >
          <div>
            <h1 style="z-index:100">{{column.tasks.facilityName}}</h1>
          </div>
          <div class="row mb-3 kan-header" data-cy="kanban_col_title">
            <div class="col">
              <div class="badge">
                <span>{{column.title}}</span>
                <span class="font-sm add" v-tooltip="`Add new ${kanbanType}`" @click.prevent="handleAddNew(column.stage)" v-if="_isallowed('write')" data-cy="kanban_add_btn">
                <i class="fa fa-plus" aria-hidden="true"></i>
              </span>
              </div>
               
            </div>
           
          </div>
          <div class="kan-body">
            <draggable :move="handleMove" @change="(e) => handleChange(e, column.tasks)"  :list="column.tasks" :animation="100" ghost-class="ghost-card" group="tasks" :key="column.title" class="kanban-draggable" data-cy="kanban_draggable" v-if="_isallowed('write')">
              <div
                :is="cardShow"
                v-for="task in column.tasks"
                :key="`${task.id}_${column.stage.id}`"               
                :task="task"
                :issue="task"
                :risk="task"             
                fromView="kanban_view"
                class="mr-auto mb-3 task-card"
              ></div>
            </draggable> 
             <div :list="column.tasks" :animation="100" ghost-class="ghost-card" group="tasks" :key="column.title" class="kanban-draggable" data-cy="kanban_draggable" v-else>
              <div
                :is="cardShow"
                v-for="task in column.tasks"
                :key="`${task.id}_${column.stage.id}`"
                :task="task"
                :issue="task"
                :risk="task"
                fromView="kanban_view"
                class="mr-auto mb-3 read-only-card"
              ></div>
            </div>           
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
import RiskShow from './../dashboard/risks/risk_show'
import MessageDialogService from "../../services/message_dialog_service";

export default {
  name: "Kanban",
  components: {
    TaskShow,
    IssueShow,
    RiskShow,
    Draggable
  },
  props: ['stages', 'cards', 'kanbanType'],
  data() {
    return {
      loading: true,     
      stageId: _.camelCase(`${this.kanbanType}tageId`),     
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
    //TODO: change the method name of isAllowed
    // _isallowed(view,salut) {
    //   var programId = this.$route.params.programId;
    //   var projectId = this.$route.params.projectId
    //   let fPrivilege = this.$projectPrivileges[programId][projectId]
    //   let permissionHash = {"write": "W", "read": "R", "delete": "D"}
    //   let s = permissionHash[salut]
    //   return  fPrivilege[view].includes(s);
    // },
    _isallowed(salut) {
      //  console.log(this.$route)
        return this.checkPrivileges("Kanban", salut, this.$route)
    }, 
    setupColumns(cards) {       
      this.stageId = `${this.kanbanType.slice(0, -1)}StageId`    
      this.columns.push({
        stage: {id: null},
        title: "No stage",
        tasks: [],
        percentage: -1
      })   
      for (let stage of this.stages) {      
        this.columns.push({
          stage: stage,
          title: stage.name,
          tasks: _.filter(cards, c => c[this.stageId] == stage.id),
          percentage: stage.percentage
        })
      }
      this.columns.sort((a,b) => (a.percentage > b.percentage) ? 1 : -1)
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
            var s = this.stages.find(s => s.name == this.movingSlot)          
            if(s){
              data[this.kanbanType][task.id][this.stageId] = s.id
                                  
            }else{
              data[this.kanbanType][task.id][this.stageId] = null
            }            
          }
        }
        this.updateKanbanTaskIssues({ projectId, facilityId, data, type: this.kanbanType, })
          .then((res) => {
            if (res.status === 200 && item.added) {
              MessageDialogService.showDialog({
                message: 'Stage was updated successfully.',
                
                
              });
            }
          });

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
    ]),
    cardShow() {
      return _.upperFirst(`${this.kanbanType.slice(0, -1)}Show`)
    },   
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
  .task-card, .read-only-card {
    border-radius: 3px;   
    background: #fff;
    border: none !important;
    // border-top: solid 8px #ffa500 !important;
    overflow-wrap: break-word;
    padding: 6px;
    box-shadow: 0 2.5px 5px rgba(56,56, 56,0.19), 0 3px 3px rgba(56,56,56,0.23) !important;
  }
  .task-card { cursor: move;}
  .read-only-card { cursor: pointer;}
  .kanban-draggable {
    height: 65vh;
    overflow-wrap: break-word;
  }
  .ghost-card {
    opacity: 0.5;
    background: #F7FAFC;
    border: 1px solid #4299e1;
  }

  .kan-col {
    background-color: #ededed;
    box-shadow: 0 5px 10px rgba(56,56, 56,0.19), 0 6px 6px rgba(56,56,56,0.23);
    position: relative;
    overflow: hidden; 
    padding-left: .76rem;
    padding-right: .76rem;  
    max-width: 296px;
    border-radius: .15rem;
  }
  .kan-has-stage {
     max-width: 18.5rem;
  }
  .kan-body {
    overflow-y: auto;
  }
  .badge {
    display: flex;
    cursor: pointer;
    padding: 5px;
    border-radius: .15rem;
    transition: auto;
    color: #ffffff;
    font-size: 1rem;
    font-weight: 500;
    background-color: #17a2b8;
    justify-content: center;
    box-shadow: 0 2.5px 5px rgba(56,56, 56,0.19), 0 3px 3px rgba(56,56,56,0.23);   
  }
  .add {
    position: absolute;
    right: 10%;
  }
  .no-stage {
    background: #fff;
    border-right: dotted 1px #ededed;
    margin-top: 24px !important;
    height: auto;
    padding: 0 !important;
    border-radius: 0 !important;
    box-shadow: none;
    width: .5rem !important;
    div.badge {
      display: none;
    }
  }
  .no-stage:hover {
     border-right: dotted 1px rgba(255, 0, 0, 0.5) !important;
  }
</style>