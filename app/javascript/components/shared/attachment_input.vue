<template>
  <div class="area">
    <transition name="slide-fade-up">
      <div
        v-if="C_invalidFiles"
        class="invalid-files"
        >
        <div class="alert alert-danger alert-dismissible mb-0" role="alert">
          <h4 class="alert-heading">File alert!</h4>
          <p>These files are not uploaded..</p>
          <hr>
          <ul class="text-left">
            <li v-for="file in invalidFiles">
              {{(file.size/1000000).toPrecision(4) + "mb"}} - {{file.name}}
            </li>
          </ul>
          <button type="button" class="close" @click.prevent="closeInvalidModal">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
      </div>
    </transition>
    <div
      v-if="!C_invalidFiles"
      class="drop-area"
      :class="{'drop-area--active': isDragActive}"
      @click.stop="onChange"
      @dragleave="onDragLeave"
      @dragover.prevent="onDragEnter"
      @drop="onDrop"
      >
      <label class="drop__label text-center">
        Drop files here or click to upload
        <span
          v-if="showLabel"
          class="drop__sub-label mt-4 d-block"
          >Max file size 50mb.</span>
      </label>
      <input
        ref="fileInput"
        type="file"
        class="drop__file-input"
        name="file"
        multiple
        @change.prevent="onFileChange"
        >
    </div>
  </div>
</template>

<script>
  export default {
    props: {showLabel: Boolean},
    data() {
      return {
        files : [],
        validFiles : [],
        invalidFiles: [],
        inputError : null,
        isDragActive: false
      }
    },
    computed: {
      C_invalidFiles() {
        return this.invalidFiles.length > 0
      }
    },
    methods: {
      onDrop(e) {
        e.stopPropagation()
        e.preventDefault()
        let file = null
        this.isDragActive = false

        for (let idx=0; idx < e.dataTransfer.files.length; idx += 1) {
          file = e.dataTransfer.files[idx]
          if (file.size <= 50000000) {
            this.validFiles.push(file)
          } else {
            this.invalidFiles.push(file)
          }
        }
        this.submitFiles()
      },
      onChange() {
        this.$refs.fileInput.click()
        this.inputError = null
      },
      onFileChange(e) {
        if (!e.currentTarget) return
        let file = null
        for (let idx = 0; idx < this.$refs.fileInput.files.length; idx += 1) {
          file = this.$refs.fileInput.files[idx]
          if (file.size <= 50000000) {
            this.validFiles.push(file)
          } else {
            this.invalidFiles.push(file)
          }
        }
        this.submitFiles()
      },
      submitFiles() {
        if (this.validFiles.length > 0) {
          this.$emit('input', this.validFiles)
          this.validFiles = []
          this.$refs.fileInput.value = ""
        }
      },
      onDragEnter() {
        this.isDragActive = true
      },
      onDragLeave() {
        this.isDragActive = false
      },
      closeInvalidModal() {
        this.invalidFiles = []
      }
    }
  };
</script>

<style scoped lang="scss">
  .dz-details {
    background: white;
    border: 1px dotted #e7e7e7;
    border-radius: 10px;
    font-style: italic;
    padding: 5px;
  }
  .drop__file-input {
    visibility: hidden;
  }
  .drop__label {
    color: gray;
    cursor: inherit;
    left: 50%;
    position: absolute;
    top: 50%;
    transform: translate(-50%, -50%);
    width: 80%;
    font-size: 18px;
    > a {
      text-decoration: underline;
    }
  }
  .drop__sub-label {
    font-size: 80%;
    text-transform: none;
  }
  .drop__img {
    height: 100%;
    left: 50%;
    margin: auto;
    position: absolute;
    top: 50%;
    transform: translate(-50%, -50%);
    width: auto;
  }
  .drop-area {
    background-color: white;
    border: 2px dashed #ccc;
    color: white;
    cursor: pointer;
    height: inherit;
    width: inherit;
    margin: auto;
    overflow: hidden;
    position: relative;
    transition: auto;
    transition-property: border-color;
    vertical-align: middle;
    &:hover {
      border-color: #17a2b8;
    }
  }
  .drop-area--active {
    border-color: #17a2b8;
    background-color: #cfe;
    cursor: copy !important;
  }
  .invalid-files {
    position: absolute;
    width: 92%;
    height: 40vh;
    overflow: auto;
    .alert-danger {
      height: 100%;
    }
  }
  .area {
    height: 100px;
  }

  /*slide animations*/
  .slide-fade-up-leave-active {
    transition: all .4s ease;
  }
  .slide-fade-up-enter, .slide-fade-up-leave-to {
    transform: translateY(-20vh);
    opacity: 0;
  }
</style>
