<template>
  <div class="gantt_board">
    <div v-if="!loading">
      <gantt-elastic
        :options="options"
        :tasks="tasks"
      ></gantt-elastic>
    </div>
    <div v-else class="d-flex justify-content-center align-items-center h-75 mt-5">
      <loader :loading="true" color="black"></loader>
      <p class="__loading">Loading</p>
    </div>
  </div>
</template>

<script>
  import utils from './../../mixins/utils'
  import http from './../../common/http'

  export default {
    name: "Gantt",
    mixins: [utils],
    data() {
      return {
        loading: true,
        tasks: [],
        options: {
          taskMapping: {
            progress: "percent"
          },
          maxRows: 100,
          maxHeight: 500,
          title: {
            label: "Project gantt chart",
            html: false
          },
          row: {
            height: 24
          },
          calendar: {
            hour: {
              display: true
            }
          },
          chart: {
            progress: {
              bar: false
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
                width: 200,
                expander: true,
                html: true,
                events: {
                  click({data, column}) {
                    alert("name clicked!\n" + data.label);
                  }
                }
              },
              {
                id: 2,
                label: "Duration",
                value: "duration",
                width: 100,
                html: true
              },
              {
                id: 3,
                label: "% Complete",
                value: "progress",
                width: 78
              },
              {
                id: 4,
                label: "Start Date",
                value: "startDate",
                width: 130
              },
              {
                id: 5,
                label: "End Date",
                value: "endDate",
                width: 130
              }
            ]
          }
        }
      }
    },
    mounted() {
      this.fetchGantt()
    },
    methods: {
      fetchGantt() {
        http
          .get(`/projects/${this.$route.params.projectId}/gantt_chart.json`)
          .then((res) => {
            this.tasks = res.data.map(task => (task.startDate ? {...task, start: this.getSimpleDate2(task.startDate)} : task) )
            this.loading = false
          })
          .catch((err) => {
            console.error(err)
          })
      },
      getSimpleDate2(date) {
        var dt = new Date(date)
        var y = dt.getFullYear()
        var m = dt.getMonth()
        var d = dt.getDate()
        return new Date(y, m, d, 0, 0, 0).getTime()
      }
    }
  }
</script>

<style scoped lang="scss">
  .gantt_board {
    padding: 10px 70px;
  }
  .__loading {
    margin-top: 125px;
    margin-left: -20px;
  }
</style>
