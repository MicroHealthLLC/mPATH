<template>
  <div class="gantt_board">
    <div v-if="!loading">
      <gantt-elastic
        :options="options"
        :tasks="ganttData"
        :dynamic-style="dynamicStyle"
        >
      </gantt-elastic>
    </div>
    <div v-else class="d-flex justify-content-center align-items-center h-75 mt-5">
      <loader :loading="true" color="black"></loader>
      <p class="__loading">Loading</p>
    </div>
  </div>
</template>

<script>
  import {mapGetters} from 'vuex'

  export default {
    name: "GanttChart",
    data() {
      return {
        loading: true,
        options: {
          times: {
            timeZoom: 21
          },
          taskMapping: {
            progress: "percent"
          },
          maxRows: 1000,
          maxHeight: 620,
          title: {
            label: "Project Gantt Chart View",
            html: false
          },
          row: {
            height: 18
          },
          calendar: {
            hour: {
              display: false
            }
          },
          chart: {
            progress: {
              bar: true
            },
            expander: {
              display: true
            }
          },
          taskList: {
            expander: {
              straight: false
            },
            columns: [
              {
                id: 1,
                label: "Name",
                value: "name",
                width: 180,
                expander: true
              },
              {
                id: 2,
                label: "Duration",
                value: "durationInDays",
                width: 75,
                style: {
                  'task-list-header-label': {
                    'text-align': 'center',
                    width: '100%'
                  },
                  'task-list-item-value-container': {
                    'text-align': 'center',
                    width: '100%'
                  }
                }
              },
              {
                id: 3,
                label: "% Complete",
                value: "progress",
                width: 90,
                style: {
                  'task-list-header-label': {
                    'text-align': 'center',
                    width: '100%'
                  },
                  'task-list-item-value-container': {
                    'text-align': 'center',
                    width: '100%'
                  }
                }
              },
              {
                id: 4,
                label: "Start Date",
                value: "startDate",
                width: 90,
                style: {
                  'task-list-header-label': {
                    'text-align': 'center',
                    width: '100%'
                  },
                  'task-list-item-value-container': {
                    'text-align': 'center',
                    width: '100%'
                  }
                }
              },
              {
                id: 5,
                label: "End Date",
                value: "endDate",
                width: 90,
                style: {
                  'task-list-header-label': {
                    'text-align': 'center',
                    width: '100%'
                  },
                  'task-list-item-value-container': {
                    'text-align': 'center',
                    width: '100%'
                  }
                }
              }
            ]
          }
        },
        dynamicStyle: {
          'task-list-header-label': {
            'font-weight': 'bold'
          }
        }
      }
    },
    mounted() {
      this.loading = false
    },
    computed: {
      ...mapGetters([
        'ganttData'
      ])
    }
  }
</script>

<style scoped lang="scss">
  .gantt_board {
    padding: 10px 70px;
  }
</style>
