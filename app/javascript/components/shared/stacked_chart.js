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
            stacked: true,
            gridLines: {
              color: "rgba(0, 0, 0, 0.05)",
            },
            ticks: {
              beginAtZero: true,
              precision: 0
            }
          }],
          yAxes: [{
            stacked: true,
          }]
        },
        tooltips: {
          enabled: false
        },
        legend: {
          position: 'top',
          onClick: () => {},
        }
      }
    }
  },
  mounted () {
    this.renderChart(this.chartData, this.options)
  }
}
