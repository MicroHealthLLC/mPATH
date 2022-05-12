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

  <el-tabs :tab-position="tabPosition" type="border-card"  class="bottomTabs"  @tab-click="handleClick">
    <el-tab-pane label="">
     <span slot="label"> <i class="fa-solid fa-car mr-1" :class="[ pane0? 'mh-green-text' : 'txt-secondary']"></i>
     VEHICLES
     </span>
      <PortfolioVehicles/>
    </el-tab-pane>
    
    <el-tab-pane>
     <span slot="label"> <i class="far fa-file-contract mr-1" :class="[ pane1? 'mh-orange-text' : 'txt-secondary']"></i>CONTRACT DETAILS</span>
    <div style="height:80vh" class="portfolio-contracts-module">
      <div  style="height: 100%; overflow-y:auto">
    <el-table
    :data="tableData.filter(data => !search || data.name.toLowerCase().includes(search.toLowerCase()))"
    border
    height="800"
    style="width: 95%">
    <el-table-column
      fixed
      label="Code"
      width="55"
      prop="charge_code">
    </el-table-column>
    <el-table-column
      fixed
      label="Project Name"
      width="200"
      prop="project_name">
    </el-table-column>
     <el-table-column
    
      label="Customer"
      width="200"
      prop="customer_name">
    </el-table-column>
      <el-table-column
    
      label="Vehicle/ Schedule"
      width="125"
      prop="vehicle">
    </el-table-column>
      <el-table-column
    
      label="Contract #"
      width="125"
      prop="contract_number">
    </el-table-column>
    <el-table-column
  
      label="Award/ TO #"
      width="125"
      prop="award_number">
    </el-table-column>
     <el-table-column
      label="NAICS"
      width="70"
      prop="naics">
    </el-table-column>
     <el-table-column
      label="Award Type"
      width="70"
      prop="award_type">
    </el-table-column>
    <el-table-column
      label="Contract Type"
      width="75"
      prop="contract_type">
    </el-table-column>
      <el-table-column
      label="Prime Vs Sub"
      width="55"
      prop="prime_or_sub">
    </el-table-column>
     <el-table-column
      label="Contract Start Date"
      width="100"
      prop="contract_start_date">
    </el-table-column>
     <el-table-column
      label="Contract End Date"
      width="100"
      prop="contract_end_date">
    </el-table-column>
     <el-table-column
      label="Total Contract Value"
       width="115"
      prop="total_contract_val">
    </el-table-column>
    <el-table-column
      label="PoP's"
       width="100"
      prop="pops">
    </el-table-column>
     <el-table-column
      label="Current PoP"
      width="100"
      prop="current_pop">
    </el-table-column>
    <el-table-column
      label="Contract Pop Start Date"
       width="100"
      prop="current_pop_start_date">
    </el-table-column>
       <el-table-column
      label="Contract Pop End Date"
       width="100"
      prop="current_pop_end_date">
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
 
    <el-tab-pane>
    <span slot="label"> <i class="fa-solid fa-book mr-1" :class="[ pane2? 'mh-blue-text' : 'txt-secondary']"></i>
     CONTRACT BACKLOG
     </span> 
    <PortfolioContractBacklog/>
    </el-tab-pane>
   <el-tab-pane>
    <span slot="label"> <i class="fa-solid fa-user mr-1" :class="[ pane3? 'bootstrap-purple-text' : 'txt-secondary']"></i>
    CONTRACT POC
    </span>
    <PortfolioContractPOC/>
    </el-tab-pane>
    <el-tab-pane>
    <span slot="label">  <i class="fa-solid fa-calendar-xmark mr-1" :class="[ pane4? 'text-danger' : 'txt-secondary']"></i>
    EXPIRED CONTRACTS
    </span>
   <PortfolioExpiredContracts/>
    </el-tab-pane>
  </el-tabs>
  </div>
      
</template>
    
<script>
import { mapGetters, mapMutations, mapActions } from "vuex";
import PortfolioVehicles from "./PortfolioVehicles.vue";
import PortfolioContractBacklog from "./PortfolioContractBacklog.vue";
import PortfolioContractPOC from "./PortfolioContractPOC.vue";
import PortfolioExpiredContracts from "./PortfolioExpiredContracts.vue";
// import ProgramTaskForm from "./ProgramTaskForm.vue";
// import ProgramLessons from "./ProgramLessons.vue";

export default {
  name: "PortfolioContracts",
  components: {
    PortfolioVehicles,  
    PortfolioExpiredContracts,
    PortfolioContractBacklog,
    PortfolioContractPOC
  },

    data() {    
      return {
        nothing: true,
        pane0: true, 
        pane1: false, 
        pane2: false, 
        pane3: false, 
        pane4: false, 
        tabPosition: 'bottom',
        tableData: [{
          id:0,
          charge_code: '1053',
          customer_name: 'Favor TechConsulting, LLC',
          project_name: 'FTC HPS Admin',
          vehicle: 'NA',
          contract_number:'2017-006-T4NG-SC',
          award_number: 'VAT4NG-012-003',
          naics: 'NA',
          award_type: 'NA',
          contract_type: 'FFP',
          prime_or_sub: 'Sub',
          contract_start_date: '6/19/2021',
          contract_end_date: '8/27/2022',
          total_contract_val: 2423434.03,
          pops: 'Base + 4 OYs',
          current_pop: 'OY4 extension',
          current_pop_start_date: '1/19/2022',
          current_pop_end_date: '8/27/2022',
        }, {
          id:1,
          charge_code: '1062',
          customer_name: 'Interagency Program Office',
          project_name: 'IPO Data Gap',
          vehicle: 'GSA IT-70',
          contract_number:'GS-35F-413BA',
          award_number: '140D0418F0001',
          naics: '541512-$30M',
          award_type: 'SDVOSB',
          contract_type: 'F&M',
          prime_or_sub: 'Prime',
          contract_start_date: '6/19/2021',
          contract_end_date: '8/27/2022',
          total_contract_val: 2423434.03,
          pops: 'Base + 4 OYs',
          current_pop: 'OY4 extension',
          current_pop_start_date: '1/19/2022',
          current_pop_end_date: '8/27/2022',
        }, {
          id:2,
          charge_code: '1079',
          project_name: '3M SEDTS 3',
          customer_name: '3M',
          vehicle: 'NA',
          contract_number:'NA',
          award_number: 'HQMMMBCKG0',
          naics: 'NA',
          award_type: 'NA',
          contract_type: 'FFP',
          prime_or_sub: 'Prime',
          contract_start_date: '6/19/2021',
          contract_end_date: '8/27/2022',
          total_contract_val: 2423434.03,
          pops: 'Base + 4 OYs',
          current_pop: 'OY4 extension',
          current_pop_start_date: '1/19/2022',
          current_pop_end_date: '8/27/2022',
        }, {
          id:3,
          charge_code: '1090',
          project_name: 'FTC DIA TO8',
          vehicle: 'NA',
          customer_name: 'Security & Exchange Commission',
          contract_number:'2017-006-T4NG-SC',
          award_number: 'VAT4NG-012-003',
          naics: 'NA',
          award_type: 'NA',
          contract_type: 'FFP',
          prime_or_sub: 'Sub',
          contract_start_date: '6/19/2021',
          contract_end_date: '8/27/2022',
          total_contract_val: 2423434.03,
          pops: 'Base + 4 OYs',
          current_pop: 'OY4 extension',
          current_pop_start_date: '1/19/2022',
          current_pop_end_date: '8/27/2022',
        }, {
          id:4,
          charge_code: '1053',
          project_name: 'FTC HPS Admin',
          vehicle: 'NA',
          contract_number:'2017-006-T4NG-SC',
          customer_name: '3M',
          award_number: 'VAT4NG-012-003',
          naics: 'NA',
          award_type: 'NA',
          contract_type: 'FFP',
          prime_or_sub: 'Sub',
          contract_start_date: '6/19/2021',
          contract_end_date: '8/27/2022',
          total_contract_val: 2423434.03,
          pops: 'Base + 4 OYs',
          current_pop: 'OY4 extension',
          current_pop_start_date: '1/19/2022',
          current_pop_end_date: '8/27/2022',
        }, {
          id:5,
          charge_code: '1053',
          project_name: 'FTC HPS Admin',          
          customer_name: '3M',
          vehicle: 'NA',
          contract_number:'2017-006-T4NG-SC',
          award_number: 'VAT4NG-012-003',
          naics: 'NA',
          award_type: 'NA',
          contract_type: 'FFP',
          prime_or_sub: 'Sub',
          contract_start_date: '6/19/2021',
          contract_end_date: '8/27/2022',
          total_contract_val: 2423434.03,
          pops: 'Base + 4 OYs',
          current_pop: 'OY4 extension',
          current_pop_start_date: '1/19/2022',
          current_pop_end_date: '8/27/2022',
        }, {
          id:6,
          charge_code: '1053',
          project_name: 'FTC HPS Admin',
          customer_name: 'Favor TechConsulting, LLC',
          vehicle: 'NA',
          contract_number:'2017-006-T4NG-SC',
          award_number: 'VAT4NG-012-003',
          naics: 'NA',
          award_type: 'NA',
          contract_type: 'FFP',
          prime_or_sub: 'Sub',
          contract_start_date: '6/19/2021',
          contract_end_date: '8/27/2022',
          total_contract_val: 2423434.03,
          pops: 'Base + 4 OYs',
          current_pop: 'OY4 extension',
          current_pop_start_date: '1/19/2022',
          current_pop_end_date: '8/27/2022',
        }, {
          id:7,
          charge_code: '1053',
          project_name: 'FTC HPS Admin',
          vehicle: 'NA',
          customer_name: 'Favor TechConsulting, LLC',
          contract_number:'2017-006-T4NG-SC',
          award_number: 'VAT4NG-012-003',
          naics: 'NA',
          award_type: 'NA',
          contract_type: 'FFP',
          prime_or_sub: 'Sub',
          contract_start_date: '6/19/2021',
          contract_end_date: '8/27/2022',
          total_contract_val: 2423434.03,
          pops: 'Base + 4 OYs',
          current_pop: 'OY4 extension',
          current_pop_start_date: '1/19/2022',
          current_pop_end_date: '8/27/2022',
        }, {
          id:8,
          charge_code: '1053',
          project_name: 'FTC HPS Admin',
          vehicle: 'NA',
          contract_number:'2017-006-T4NG-SC',
          customer_name: 'Favor TechConsulting, LLC',
          award_number: 'VAT4NG-012-003',
          naics: 'NA',
          award_type: 'NA',
          contract_type: 'FFP',
          prime_or_sub: 'Sub',
          contract_start_date: '6/19/2021',
          contract_end_date: '8/27/2022',
          total_contract_val: 2423434.03,
          pops: 'Base + 4 OYs',
          current_pop: 'OY4 extension',
          current_pop_start_date: '1/19/2022',
          current_pop_end_date: '8/27/2022',
        }, {
          id:9,
          charge_code: '1053',
          project_name: 'FTC HPS Admin',
          customer_name: 'Favor TechConsulting, LLC',
          vehicle: 'NA',
          contract_number:'2017-006-T4NG-SC',
          award_number: 'VAT4NG-012-003',
          naics: 'NA',
          award_type: 'NA',
          contract_type: 'FFP',
          prime_or_sub: 'Sub',
          contract_start_date: '6/19/2021',
          contract_end_date: '8/27/2022',
          total_contract_val: 2423434.03,
          pops: 'Base + 4 OYs',
          current_pop: 'OY4 extension',
          current_pop_start_date: '1/19/2022',
          current_pop_end_date: '8/27/2022',
        }, {
          id:10,
          charge_code: '1053',
          project_name: 'FTC HPS Admin',
          vehicle: 'NA',
          contract_number:'2017-006-T4NG-SC',
          customer_name: 'Favor TechConsulting, LLC',
          award_number: 'VAT4NG-012-003',
          naics: 'NA',
          award_type: 'NA',
          contract_type: 'FFP',
          prime_or_sub: 'Sub',
          contract_start_date: '6/19/2021',
          contract_end_date: '8/27/2022',
          total_contract_val: 2423434.03,
          pops: 'Base + 4 OYs',
          current_pop: 'OY4 extension',
          current_pop_start_date: '1/19/2022',
          current_pop_end_date: '8/27/2022',
        }, {
          id:11,
          charge_code: '1053',
          project_name: 'FTC HPS Admin',
          vehicle: 'NA',
          contract_number:'2017-006-T4NG-SC',
          award_number: 'VAT4NG-012-003',
          naics: 'NA',
          award_type: 'NA',
          contract_type: 'FFP',
          prime_or_sub: 'Sub',
          contract_start_date: '6/19/2021',
          contract_end_date: '8/27/2022',
          total_contract_val: 2423434.03,
          pops: 'Base + 4 OYs',
          current_pop: 'OY4 extension',
          current_pop_start_date: '1/19/2022',
          current_pop_end_date: '8/27/2022',
        }, {
          id:12,
          charge_code: '1053',
          project_name: 'FTC HPS Admin',
          vehicle: 'NA',
          contract_number:'2017-006-T4NG-SC',
          award_number: 'VAT4NG-012-003',
          naics: 'NA',
          award_type: 'NA',
          contract_type: 'FFP',
          prime_or_sub: 'Sub',
          contract_start_date: '6/19/2021',
          contract_end_date: '8/27/2022',
          total_contract_val: 2423434.03,
          pops: 'Base + 4 OYs',
          current_pop: 'OY4 extension',
          current_pop_start_date: '1/19/2022',
          current_pop_end_date: '8/27/2022',
        }, {
          id:13,
          charge_code: '1053',
          project_name: 'FTC HPS Admin',
          vehicle: 'NA',
          contract_number:'2017-006-T4NG-SC',
          award_number: 'VAT4NG-012-003',
          naics: 'NA',
          award_type: 'NA',
          contract_type: 'FFP',
          prime_or_sub: 'Sub',
          contract_start_date: '6/19/2021',
          contract_end_date: '8/27/2022',
          total_contract_val: 2423434.03,
          pops: 'Base + 4 OYs',
          current_pop: 'OY4 extension',
          current_pop_start_date: '1/19/2022',
          current_pop_end_date: '8/27/2022',
        }, {
          id:14,
          charge_code: '1053',
          project_name: 'FTC HPS Admin',
          vehicle: 'NA',
          contract_number:'2017-006-T4NG-SC',
          award_number: 'VAT4NG-012-003',
          naics: 'NA',
          award_type: 'NA',
          contract_type: 'FFP',
          prime_or_sub: 'Sub',
          contract_start_date: '6/19/2021',
          contract_end_date: '8/27/2022',
          total_contract_val: 2423434.03,
          pops: 'Base + 4 OYs',
          current_pop: 'OY4 extension',
          current_pop_start_date: '1/19/2022',
          current_pop_end_date: '8/27/2022', 
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
  },
  handleClick(tab, event) {
    if (tab.paneName == 0){
       this.pane0 = true;
       this.pane1 = false;
       this.pane2 = false;
       this.pane3 = false;
       this.pane4 = false;
    }
    if (tab.paneName == 1){
       this.pane0 = false;
       this.pane1 = true;
       this.pane2 = false;
       this.pane3 = false
       this.pane4 = false
    }
    if (tab.paneName == 2){
       this.pane0 = false;
       this.pane1 = false;
       this.pane2 = true;
       this.pane3 = false;
       this.pane4 = false;
    }
    if (tab.paneName == 3){
       this.pane0 = false;
       this.pane1 = false;
       this.pane2 = false;
       this.pane3 = true;
       this.pane4 = false;
    }
   if (tab.paneName == 4){
       this.pane0 = false;
       this.pane1 = false;
       this.pane2 = false;
       this.pane3 = false;
       this.pane4 = true;
    }
 
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