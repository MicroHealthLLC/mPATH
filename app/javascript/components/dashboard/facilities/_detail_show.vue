<template>
  <div id="facility-detail-show" class="mt-3">
    <project-index 
      v-if="DV_facility" 
      :facility="DV_facility"
      @refresh-facility="refreshFacility"
    ></project-index>
    <a href="javascript:;" @click.prevent.stop="$emit('show-less')" class="btn btn-link float-right f-show-btn">show less..</a>
  </div>
</template>

<script>
  import ProjectIndex from './projects/_index'
  export default {
    name: 'DetailShow',
    props: ['facility'],
    components: { ProjectIndex },
    data() {
      return {
        DV_facility: this.facility
      }
    },
    methods: {
      refreshFacility() {
        this.$emit('refresh-facility')
      }
    },
    watch: {
      facility: {
        handler: function(value) {
          this.DV_facility = value
        },
        deep: true
      }
    }
  }  
</script>

<style lang="scss" scoped>
  .f-show-btn {
    font-size: 12px;
    font-style: italic;
  }
</style>
