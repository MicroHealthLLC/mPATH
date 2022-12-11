<!--  NOTE: This file is used in Sheets view as overview tab -->
<template>
  <div id="contract-sheets" data-cy="contract_sheets">
    <div class="position-sticky">
      <div :load="log(contract)">
        <!-- <div 
          v-loading="!contractLoaded"
          element-loading-text="Fetching Portfolio data. Please wait..."
          element-loading-spinner="el-icon-loading"
          element-loading-background="rgba(0, 0, 0, 0.8)"
          > -->
          <div v-if="_isallowed('read')" class="container-fluid px-0 mx-1">
            <!-- <div v-if="_isallowed('read')" class="container-fluid px-0 mx-1"> -->
           <div  class="row mt-3">
           <div class="col-4">
            <!-- {{ c }}  -->
            <el-card
              v-if="c"
              class="box-card mb-2 pb-3"
              style="background-color:#fff"
             >   
            <h4 v-if="c.name">{{ c.name }}</h4>
            <hr>
             <div class="row">
             <div class="col">
              <b>GROUP NAME:</b>
              </div>  
              <div class="col">
               <h5 v-if="c.facilityGroup">{{ c.facilityGroup.name }} </h5>
               </div>  
           </div>  
           <div class="row">
             <div class="col">
              <b>CUSTOMER:</b>
              </div>  
              <div class="col">
               <h5 v-if="c.contractCustomer">{{ c.contractCustomer.name }} </h5>
              </div>  
           </div>  
          
            <div class="row">
             <div class="col">
              <b>CONTRACT NUMBER:</b>
              </div>  
              <div class="col">
               <h5 v-if="c.contractNumber">{{ c.contractNumber.name }}</h5>
              </div>  
           </div>  

             <div class="row">
             <div class="col">
              <b>AWARD/TO NUMBER:</b>
              </div>  
              <div class="col">
               <h5 v-if="c.contractAwardTo">{{ c.contractAwardTo.name }}</h5>
              </div>  
             </div>  
           </el-card>  
           </div>
           </div>

           
          </div>
           <div v-else class="text-danger mx-2 mt-5">
            <h5> <i>Sorry, you don't have read-permissions for this tab! Please click on any available tab.</i></h5>
          </div>
        <!-- </div> -->
      </div>
    </div>
   
  </div>
</template>

<script>
import { mapGetters, mapMutations, mapActions } from "vuex";
import Loader from "../../../shared/loader.vue";
import FormTabs from "../../../shared/FormTabs.vue";
export default {
  name: "SheetContract",
  components: {
    Loader,
    FormTabs,
  },
  props: ["contractClass", 'currentContract', "contract"], 
  data() {
    return {
      loading: true,
      isInputActive: false,
      da: "",
      statusId: null,
      componentKey: 0,
      saving: false, 
      showErrors: false,
      loading: true,
      inputText: "",
      value: "",
      currentTab: "tab1",
      options: [],
  
    };
  },
  mounted() {
    this.loading = false;
  //  if (this.$route.params.contractId) {
  //     this.fetchContract({
  //       id: this.$route.params.contractId,
  //       programId: this.$route.params.programId,
  //     });
  //   }
  },
  methods: {
    ...mapActions([
      "fetchContract",
      ]),
    ...mapMutations([

    ]),
    reRenderDropdowns() {
      this.componentKey += 1;

    },    
    _isallowed(salut) {
      console.log(salut)
        console.log(this.$route)
      return this.checkPrivileges("SheetContract", salut, this.$route)
    },
    log(e){
      console.log(e)
    },
  },
  computed: {
    ...mapGetters([
      "contentLoaded",
      "contractLoaded",
      "contractStatus",
       "contracts",
    ]),
    c(){
      if(this.contract){
          return this.contract
      }
    },  
  },
 };
</script>

<style lang="scss" scoped>
.f-head {
  word-break: break-word;
  text-overflow: ellipsis;
}
.f-notes {
  border: 1px solid #ccc;
  padding: 5px 10px;
  border-radius: 5px;
  overflow: auto;
  min-height: 20vh;
  max-height: 34vh;
}
.f-show-btn {
  font-size: 12px;
  font-style: italic;
  display: flex;
  flex-direction: row-reverse;
}
.custom-tab {
  background-color: #ededed !important;
  width: auto;
  text-transform: uppercase;
  box-shadow: 0 2.5px 5px rgba(56, 56, 56, 0.19),
    0 3px 3px rgba(56, 56, 56, 0.23);
}
.apply-btn,
.red,
.orange,
.green,
.grey,
.grey2,
.yellow {
  box-shadow: 0 2.5px 5px rgba(56, 56, 56, 0.19),
    0 3px 3px rgba(56, 56, 56, 0.23);
}
.pg-content {
  width: 100%;
  height: 20px;
  font-size: 14px;
  font-weight: bold;
}
.vue-tabs {
  margin-top: 15px;
}
.vdp-datepicker {
  width: 100%;
}
.search-tab {
  width: 80%;
}
.displayNone {
  display: none !important;
}
.fa-usd-square {
  font-size: 1.3rem;
}

::v-deep.el-button.usd-icon {
  cursor:text;
}
.fa-building {
  font-size: large !important;
  color: #383838 !important;
}
.close-sidebar-btn {
  z-index: 800;
  cursor: pointer;
  display: flex;
  position: absolute;
  left: 0;
  top: 0;
  background: #fff;
  padding: 5px;
}
.my-el-card {
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
}
.vue2-datepicker ::v-deep .mx-input:disabled {
  color: #555;
  background-color: #fff;
}
.simple-select ::v-deep .multiselect {
  .multiselect__placeholder {
    text-overflow: ellipsis;
  }
}
.saveBtn {
  box-shadow: 0 2.5px 5px rgba(56, 56, 56, 0.19),
    0 3px 3px rgba(56, 56, 56, 0.23);
}
.fac-sum {
  border-radius: 2px;
  padding: 8px;
  margin-bottom: 8px;
  background-color: #fff;
  box-shadow: 0 5px 5px rgba(0, 0, 0, 0.19), 0 3px 3px rgba(0, 0, 0, 0.23);
}
.grey {
  background-color: lightgray;
}
.grey2 {
  background-color: #ededed;
}
.yellow {
  background-color: yellow;
}
.orange {
  background-color: #f0ad4e;
}
.green {
  background-color: rgb(92, 184, 92);
}
.red {
  background-color: #d9534f;
}
.red,
.orange,
.green,
.grey {
  color: white;
  border-radius: 3px;
}
.grey2 {
  border-radius: 3px;
}
.risk-card-title {
  font-size: 1rem;
}
.font-12 {
  font-size: 12px;
}
.mt-neg-4 {
  margin-top: -4px;
}
.underline {
  text-decoration: underline;
}
.smallerFont {
  font-size: 10px;
}
::v-deep.el-collapse-item__header,
::v-deep.el-collapse-item__wrap {
  border-bottom: none !important;
}

::v-deep.el-card__body {
  padding-bottom: 0 !important;
}
::v-deep.el-progress-circle {
  height: 100px !important;
  width: 100px !important;
}
::v-deep.el-collapse-item__header {
  font-size: 2rem;
}

::v-deep.el-collapse-item__arrow,
::v-deep.el-icon-arrow-right {
  display: none;
}
.giantNumber {
  font-size: 3.7rem;
}
.halfRem {
  margin-top: 0.5rem;
  margin-bottom: 0.5rem;
}
.hide {
  visibility: hidden;
}
.relative {
  position: relative;
}
.absolute {
  position: absolute;
  top: 7%;
  left: 0;
}
.progressLabel {
  position: absolute;
}
.pill {
  position: absolute;
  top: 10%;
  right: 1%;
}

.filterDiv {
  position: fixed;
  top: 130px;
  right: 9.5%;
  width: 20%;
  border-radius: 4px;
  border: 0.5px solid #383838;
  overflow-y: auto;
}
.filterLabel {
  position: fixed;
}

.filterCol {
  height: 70px;
}

@media screen and (min-width: 1550px) {
  .filterDiv {
    right: 8.5%;
  }
}
</style>
