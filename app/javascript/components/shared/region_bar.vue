<template>
  <div class="d-flex">
    <div v-if="!regionBar" class="map-icon-btn mr-2" @click="openRegionBar">
      <i class="fas fa-info"></i>
    </div>
    <transition name="slide-fade">
      <div v-if="regionBar" id="region-bar">
        <div class="r-header px-3">
          <h5 class="text-muted">Regions</h5>
          <div class="region-minus-btn" @click="closeRegionBar">
            <i class="fas fa-minus"></i>
          </div>
        </div>
        <ul v-if="regions.length > 0" class="regions-list list-unstyled">
          <li v-for="region in filteredRegions" class="px-3">
            <a class="text-secondary d-flex align-items-center" @click.prevent.stop="pointToRegion(region)" href="javascript:;">
            <div class="region-color rounded-lg mr-2" :style="{backgroundColor: region.color}"></div>
              <span>{{region.name}}</span>
            </a>
          </li>
        </ul>
        <div v-else class="text-danger px-3 py-1">
          The Project doesn't have any region associated
        </div>
      </div>
    </transition>
  </div>
</template>

<script>
  export default {
    name: 'RegionBar',
    props: ['regions'],
    data() {
      return {
        regionBar: false
      }
    },
    mounted() {
      if (this.regions.length <= 0) this.regionBar = true
    },
    methods: {
      openRegionBar() {
        this.regionBar = true
      },
      closeRegionBar() {
        this.regionBar = false
      },
      pointToRegion(region) {
        this.regionBar = false
        this.$emit('goto-region', region);
      }
    },
    computed: {
      filteredRegions() {
        return this.regions.filter(region => ['region'].includes(region.regionType)).sort((a, b) => a.name.localeCompare(b.name))
      }
    }
  }
</script>
<style scoped lang="scss">
  #region-bar {
    padding: 10px;
    background: #fff;
    width: 20vw;
    max-height: 60vh;
    min-height: 30vh;
    border-radius: 4px;
    box-shadow: rgba(0, 0, 0, 0.3) 0px 1px 4px -1px;
    .r-header {
      display: flex;
      justify-content: space-between;
    }
    .regions-list {
      max-height: 88%;
      li:hover > a {
        color: #000;
        text-decoration: none;
      }
      li a {
        font-size: 14px;
      }
      li a > .region-color {
        height: 10px;
        width: 15px;
      }
    }
  }
  .map-icon-btn {
    width: 26px;
    height: 26px;
    background: white;
    text-align: center;
    box-shadow: rgba(0, 0, 0, 0.3) 0px 1px 4px -1px;
    border-radius: 2px;
    cursor: pointer;
    font-size: 14px;
    padding: 2px;
  }
  .region-minus-btn {
    cursor: pointer;
  }
  .slide-fade-enter-active {
    transition: all .5s ease-in;
  }
  .slide-fade-leave-active {
    transition: all .4s ease-in-out;
  }
  .slide-fade-enter, .slide-fade-leave-to {
    transform: translateX(-100px);
    opacity: 0;
  }
</style>
