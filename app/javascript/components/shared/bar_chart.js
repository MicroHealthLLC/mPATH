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
              beginAtZero: true
            },
            gridLines: {
              color: "rgba(0, 0, 0, 0)",
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
