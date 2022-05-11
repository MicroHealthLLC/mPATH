<template>
  <div class="container-fluid mt-3 mx-3">
   
    <div style="height:85px">
      <span @click.prevent="backHomeBtn">
        <img
          class="mb-2"
          style="width: 147px;cursor:pointer"
          :src="require('../../../../../assets/images/microhealthllc.png')"
        />
        <!-- <h3 class="d-inline mt-1 programName">{{ this.$portfolio_heading }}</h3> -->
      </span>
      <span class="float-right mr-4">
        <button
          class="portfolioHomeBtn mh-orange btn btn-sm"
          style="cursor: pointer"
          @click.prevent="backHomeBtn"
        >
          <i class="fas fa-home text-light"></i>
        </button>
      </span>
    </div>

  <el-tabs :tab-position="tabPosition" type="card"  class="bottomTabs">
    <el-tab-pane>
          <span slot="label"> <i class="far fa-file-contract mr-1 mh-orange-text"></i>CONTRACT DETAILS</span>
    <div style="height:80vh">
      <div  style="height: 100%; overflow-y:auto">
    <el-table
    :data="tableData.filter(data => !search || data.name.toLowerCase().includes(search.toLowerCase()))"
    border
    height="800"
    style="width: 95%">
    <el-table-column
      label="Code"
      width="55"
      prop="code">
    </el-table-column>
    <el-table-column
      fixed
      label="Project Name"
      width="200"
      prop="name">
    </el-table-column>
     <el-table-column
    
      label="Customer"
      width="200"
      prop="name">
    </el-table-column>
      <el-table-column
    
      label="Vehicle/ Schedule"
      width="125"
      prop="sched">
    </el-table-column>
      <el-table-column
    
      label="Contract #"
      width="125"
      prop="sched">
    </el-table-column>
    <el-table-column
  
      label="Award/ TO #"
      width="125"
      prop="sched">
    </el-table-column>
     <el-table-column
      label="NAICS"
      width="70"
      prop="type">
    </el-table-column>
     <el-table-column
      label="Award Type"
      width="70"
      prop="type">
    </el-table-column>
    <el-table-column
      label="Contract Type"
      width="70"
      prop="type">
    </el-table-column>
      <el-table-column
      label="Prime Vs Sub"
      width="55"
      prop="primesub">
    </el-table-column>
     <el-table-column
      label="Contract Start Date"
      width="100"
      prop="startdate">
    </el-table-column>
     <el-table-column
      label="Contract End Date"
      width="100"
      prop="startdate">
    </el-table-column>
     <el-table-column
      label="Total Contract Value"
       width="115"
      prop="value">
    </el-table-column>
    <el-table-column
      label="PoP's"
       width="55"
      prop="type">
    </el-table-column>
     <el-table-column
      label="Current PoP"
      width="70"
      prop="type">
    </el-table-column>
    <el-table-column
      label="Contract Pop Start Date"
       width="100"
      prop="startdate">
    </el-table-column>
       <el-table-column
      label="Contract Pop End Date"
       width="100"
      prop="startdate">
    </el-table-column>
    <el-table-column
      label="Actions"
      width="75"
      fixed="right"
      align="right">
      <!-- <template slot="header" slot-scope="scope">
        <el-input
         
          v-model="search"
          size="mini"
          placeholder="Type to search"/>
      </template> -->
      <template slot-scope="scope">
         <el-button
          type="default"
          class="bg-light btn-sm"
          @click="handleEdit(scope.$index, scope.row)"><i class="fal fa-edit text-primary"></i>
          </el-button>
        <!-- <el-button
          size="mini"
          type="danger"
          @click="handleDelete(scope.$index, scope.row)">Delete</el-button> -->
      </template>
    </el-table-column>
  </el-table>
      </div>
      </div>
    </el-tab-pane>
    <el-tab-pane label="">
     <span slot="label"> <i class="fa-solid fa-car mr-1 mh-green-text"></i>VEHICLES</span>
      <PortfolioVehicles/>
    </el-tab-pane>
    <el-tab-pane>
    <span slot="label"> <i class="fa-solid fa-book mr-1 mh-blue-text"></i>   CONTRACT BACKLOG</span> 
    <PortfolioContractBacklog/>
    </el-tab-pane>
   <el-tab-pane>
    <span slot="label"> <i class="fa-solid fa-user mr-1 bootstrap-purple-text"></i>CONTRACT POC</span>
    <PortfolioContractPOC/>
    </el-tab-pane>
    <el-tab-pane>
    <span slot="label">  <i class="fa-solid fa-calendar-xmark mr-1 text-danger"></i>EXPIRED CONTRACTS</span>

    </el-tab-pane>
  </el-tabs>

 
<!-- 
  TABS
  
  CONTRACT DETAILS
  VEHICLES
  CONTRACT BACKLOG
  CONTRACT POC
  EXPIRED CONTRACTS





 -->

  </div>
      
</template>
    
<script>
import { mapGetters, mapMutations, mapActions } from "vuex";
import PortfolioVehicles from "./PortfolioVehicles.vue";
import PortfolioContractBacklog from "./PortfolioContractBacklog.vue";
import PortfolioContractPOC from "./PortfolioContractPOC.vue";
// import ProgramTaskForm from "./ProgramTaskForm.vue";
// import ProgramLessons from "./ProgramLessons.vue";

export default {
  name: "PortfolioContracts",
  components: {
    PortfolioVehicles,  
    PortfolioContractBacklog,
    PortfolioContractPOC
  },

    data() {    
      return {
        nothing: true,
        tabPosition: 'bottom',
        tableData: [{
          code: 123, 
          type: 'FFP', 
          value: "$7,343,342.45",
          primesub: "Sub",
          sched: "CIOSP3-SDVOSB",
          startdate: '2016-05-03',
          name: 'SEC FOIA Admin Proceedings',
          address: 'No. 189, Grove St, Los Angeles'
        }, {
          code: 123, 
          type: 'FFP', 
          startdate: '2016-05-02',
            sched: "CIOSP3-SDVOSB",
          value: "$7,343,342.45",
          name: 'John',
          primesub: "Prime",
          address: 'No. 189, Grove St, Los Angeles'
        }, {
          code: 123, 
          startdate: '2016-05-04',
          type: 'T&M', 
          primesub: "Sub",
            sched: "CIOSP3-SDVOSB",
          value: "$5,643.45",
          name: 'Morgan',
          address: 'No. 189, Grove St, Los Angeles'
        }, {
          code: 123, 
          startdate: '2016-05-01',
          name: 'Jessy',
          type: 'T&M', 
            sched: "CIOSP3-SDVOSB",
          value: "$17,343,342.45",
          primesub: "Prime",
          address: 'No. 189, Grove St, Los Angeles'
        }, {
          code: 123, 
          startdate: '2016-05-03',
          name: 'Tom',
            sched: "CIOSP3-SDVOSB",
          value: "$6,343,342.45",
          primesub: "Prime",
          type: 'T&M', 
          address: 'No. 189, Grove St, Los Angeles'
        }, {
           code: 123, 
           startdate:'2016-05-02',
          name: 'John',
          primesub: "Sub",
            sched: "CIOSP3-SDVOSB",
           value: "$7,343,342.45",
          type: 'T&M', 
          address: 'No. 189, Grove St, Los Angeles'
        }, {
          code: 123, 
          type: 'FFP', 
          startdate: '2016-05-02',
          value: "$7,343,342.45",
            sched: "CIOSP3-SDVOSB",
          name: 'John',
          primesub: "Prime",
          address: 'No. 189, Grove St, Los Angeles'
        }, {
          code: 123, 
          startdate: '2016-05-04',
          type: 'T&M', 
          primesub: "Sub",
          value: "$5,643.45",
            sched: "CIOSP3-SDVOSB",
          name: 'Morgan',
          address: 'No. 189, Grove St, Los Angeles'
        }, {
          code: 123, 
          startdate: '2016-05-01',
          name: 'Jessy',
            sched: "CIOSP3-SDVOSB",
          type: 'T&M', 
          value: "$17,343,342.45",
          primesub: "Prime",
          address: 'No. 189, Grove St, Los Angeles'
        }, {
          code: 123, 
          startdate: '2016-05-03',
          name: 'Tom',
          value: "$6,343,342.45",
          primesub: "Prime",
          sched: "CIOSP3-SDVOSB",
          type: 'T&M', 
          address: 'No. 189, Grove St, Los Angeles'
        }, {
           code: 123, 
           startdate:'2016-05-02',
          name: 'John',
          primesub: "Sub",
           value: "$7,343,342.45",
          sched: "CIOSP3-SDVOSB",
          type: 'T&M', 
          address: 'No. 189, Grove St, Los Angeles'
        }, {
           code: 123, 
          startdate: '2016-05-04',
          name: 'Morgan',
          sched: "CIOSP3-SDVOSB",
          value: "$7,343,342.45",
          primesub: "Prime",
          address: 'No. 189, Grove St, Los Angeles'
        }, {
          code: 123, 
          startdate: '2016-05-01',
          name: 'Jessy',
          type: 'T&M', 
          sched: "CIOSP3-SDVOSB",
          value: "$17,343,342.45",
          primesub: "Prime",
          address: 'No. 189, Grove St, Los Angeles'
        }, {
          code: 123, 
          startdate: '2016-05-03',
          name: 'Tom',
          value: "$6,343,342.45",
          primesub: "Prime",
          sched: "CIOSP3-SDVOSB",
          type: 'T&M', 
          address: 'No. 189, Grove St, Los Angeles'
        }, {
           code: 123, 
           startdate:'2016-05-02',
          name: 'John',
          primesub: "Sub",
          sched: "CIOSP3-SDVOSB",
           value: "$7,343,342.45",
          type: 'T&M', 
          address: 'No. 189, Grove St, Los Angeles'
        }, {
           code: 123, 
          startdate: '2016-05-04',
          name: 'Morgan',
          sched: "CIOSP3-SDVOSB",
          value: "$7,343,342.45",
          primesub: "Prime",
          address: 'No. 189, Grove St, Los Angeles'
        }, {
          code: 123, 
          startdate: '2016-05-01',
          sched: "CIOSP3-SDVOSB",
          name: 'Jessy',
          value: "$7,343,342.45",
          primesub: "Sub",
          address: 'No. 189, Grove St, Los Angeles'       
        }],
        search: '',
    };
  },
  methods: {
    ...mapMutations([
     
    ]),
    ...mapActions([
      
    ]),  
  backHomeBtn() {
      window.location.pathname = "/";
    },    
  handleEdit(index, row) {
        console.log(index, row);
      },
  handleDelete(index, row) {
    console.log(index, row);
  }
  },
  mounted() {
    
  },
  computed: {
    ...mapGetters([
     
    ]),   
  },
  watch: {
   
  
    
  },
};
</script>
    
<style scoped lang="scss">
  .bottomTabs{
    position: absolute;
    bottom: 2.5%;
    width: 100%;
  }

/deep/.el-table {
    font-size: 13px !important;
    th.el-table__cell>.cell {
      word-break: break-word;
      font-size: .88rem;
    }
    th {
      color: #383838;
    }


  }    
</style>