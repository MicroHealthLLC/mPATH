export default {
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
    getAverage(_count, _total) {
      return ((_count / _total) * 100).toFixed(2)
    }
  }
}
