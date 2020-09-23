import {Doughnut, mixins} from 'vue-chartjs'
const {reactiveProp} = mixins

export default {
  name: 'Doughnut',
  extends: Doughnut,
  mixins: [reactiveProp],
  data() {
    return {
      options: {
        circumference: Math.PI,
        rotation: -Math.PI,
        responsive: true,
        animation: {
          animateScale: true,
          animateRotate: true
        },
        tooltips: {
          enabled: false
        }
      }
    }
  },
  mounted () {
    this.renderChart(this.chartData, this.options)
  }
}
