<template>
  <div>
    <vcl-bullet-list v-if="type == 'bullet'" height="100" :rows="rows" :primary="primary" :secondary="secondary" :rtl="rtl"></vcl-bullet-list>
    <vcl-code v-else-if="type == 'code'" :primary="primary" height="100" :secondary="secondary" :rtl="rtl"></vcl-code>
    <vcl-list v-else :primary="primary" height="100" :secondary="secondary" :rtl="rtl"></vcl-list>
  </div>
</template>

<script>
  import {VclList, VclCode, VclBulletList} from 'vue-content-loading'
  export default {
    name: 'Loader',
    props: ['type', 'rtl'],
    components: {
      VclList,
      VclBulletList,
      VclCode
    },
    data() {
      return {
        primary: '#e0e0e0',
        secondary: '#868788',
        rows: 3
      }
    }
  }
</script>
