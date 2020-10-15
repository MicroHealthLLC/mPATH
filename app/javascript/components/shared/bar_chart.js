import {HorizontalBar, mixins} from 'vue-chartjs'
const {reactiveProp} = mixins

export default {
  extends: HorizontalBar,
  mixins: [reactiveProp],
  data() {
    return {
      options: {
        scales: {
          xAxes: [{
            ticks: {
              beginAtZero: true,
              precision: 0
            },
            gridLines: {
              color: "rgba(0, 0, 0, 0.05)",
            }
          }],
          yAxes:[{
            ticks: {
              display: false
            }
          }]
        },
        tooltips: {
          enabled: true,
          position: "nearest",
          mode: 'dataset',
          titleFontSize: 14,
          displayColors: false,
          callbacks: {
            title: ((item, data) => {
              var stat = data.datasets[item[0].datasetIndex]._meta.stat
              return `${stat.type}: ${stat.tasks.length} & Checklists: ${stat.checklists.length}`
            }),
            label: () => "",
            afterLabel: ((item, data) => {
              var label = ""
              for (var task of data.datasets[item.datasetIndex]._meta.stat.tasks) label = label + `- ${task.text || task.title} -> ${task.progress}% \n`
              return label
            })
          },
        },
        legend: {
          position: 'left',
          onClick: () => {},
        }
      }
    }
  },
  mounted () {
    this.renderChart(this.chartData, this.options)
  }
}
