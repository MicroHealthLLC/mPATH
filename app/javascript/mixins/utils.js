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
    }
  }
}
