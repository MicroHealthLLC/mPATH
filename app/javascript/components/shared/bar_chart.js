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
            },
            'dataset.maxBarThickness': 2,
          }]
        },
        tooltips: {
          enabled: false
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
