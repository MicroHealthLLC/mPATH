<template>
  <div id="facility-detail-show" class="mt-3">
    <project-show
      :facility="DV_facility"
      @refresh-facility="refreshFacility"
    />
  </div>
</template>

<script>
  import ProjectShow from './../projects/project_show'

  export default {
    name: 'DetailShow',
    props: ['facility'],
    components: { ProjectShow },
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
