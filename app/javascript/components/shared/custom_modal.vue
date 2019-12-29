<template>
  <modal :width="width" :name="name" :clickToClose="false">
    <div slot="top-right" @click.prevent="hideModal" class="close-btn" :style="C_buttonStyle">
      <i class="material-icons modal-close icon-btn">close</i>
    </div>
    <slot name="modal-content"></slot>
  </modal>
</template>

<script>
export default {
  name: 'CustomModal',
  props: [
    'name',
    'width'
  ],
  computed: {
    C_buttonStyle() {
      return {
        left: `calc(15% + ${this.width}px - 30px)`,
        bottom: "0",
        position: "absolute"
      }
    }
  },
  methods: {
    hideModal() {
      this.$modal.hide(this.name)
    }
  }
}
</script>

<style scoped lang="scss">
  .v--modal-overlay /deep/ {
    position: absolute !important;
    z-index: 99999 !important;
    background: rgba(255, 255, 255, 0.9);
    max-height: calc(100vh - 90px);
    overflow: auto;
    .v--modal-box {
      top: 11vh !important;
      left: 15% !important;
      height: 62vh !important;
      overflow-y: scroll !important;
    }
    .v--modal-top-right {
      position: relative;
      top: 10vh !important;
    }
    .modal-close {
      padding: 6px;
      border-radius: 50%;
      background: white;
      font-size: 18px;
      font-weight: bold;
      &:hover {
        background: #f4f4f4;
      }
    }
  }
  .top-right {
    cursor: pointer;
  }
  .close-btn {
    border-radius: 50%;
    cursor: pointer;
  }
</style>
