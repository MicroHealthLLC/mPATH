export const API_BASE_PATH = "/api/v1"

// mixins Utils
export default {
  data() {
    return {
      DV_months: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
    }
  },
  methods: {
    getSorted(array) {
      if (typeof(array[0]) === 'number') {
        let temp = array[0]
        array[0] = array[1]
        array[1] = temp
      }
      else {
        array.map((element) => this.getSorted(element))
      }
    },
    guid() {
      return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, (c) => {
        var r = Math.random() * 16 | 0, v = c == 'x' ? r : (r & 0x3 | 0x8)
        return v.toString(16)
      })
    },
    random() {
      return Math.floor(new Date().valueOf() * Math.random())
    },
    getAverage(count, total) {
      return Number((((count / total) * 100) || 0).toFixed(2))
    },
    upsert(array, item) {
      const i = array.findIndex(_item => _item.hasOwnProperty(Object.keys(item)[0]))
      if (i > -1) array[i] = item
      else array.push(item)
    },
    getSimpleDate(date) {
      var dt = [undefined, null, 'N/A'].includes(date) ? new Date : new Date(date)
      var y = dt.getFullYear()
      var m = dt.getMonth()
      var d = dt.getDate()
      return new Date(y, m, d, 0, 0, 0).getTime()
    },
    formatDate(date) {
      if (!moment(date).isValid()) return date
      if (date instanceof Date) date = date.toISOString().slice(0, 10)
      var dates = date.split('-')
      return `${dates[2]} ${this.DV_months[Number(dates[1])-1]} ${dates[0]}`
    },
    getColor() {
      var letters = '0123456789ABCDEF'
      var color = '#'
      for (var i=0; i<6; i++) {
        color += letters[Math.floor(Math.random() * 16)]
      }
      return color;
    },
    exists(value) {
      return value !== null && value !== undefined && String(value).trim() !== ''
    }
  }
}
