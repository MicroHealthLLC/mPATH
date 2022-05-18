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
      <template slot-scope="scope">
        <el-input
          size="small"
          v-if="scope.$index == createRow"
          placeholder="Enter Project Name"
          style="text-align:center"
          v-model="scope.row.project_name"
          controls-position="right"
        ></el-input>
        <span v-if="rowId == scope.row.id && scope.$index !== createRow">
        <el-input
          size="small"
          placeholder="Enter Project Name"
          style="text-align:center"
          v-model="scope.row.project_name"
          controls-position="right"
          ></el-input>
        </span>
      <span v-if="rowId !== scope.row.id && scope.$index !== createRow">
        {{ scope.row.project_name }} 
        </span>
        </template>
     </el-table-column>
     <el-table-column
    
      label="Customer"
      width="200"
      prop="customer_name">
     <template slot-scope="scope" >
     <span v-if="rowId == scope.row.id || scope.$index == createRow">
       <el-select
        v-model="scope.row.customer_name"
        filterable       
        track-by="name"        
        value-key="id"
        class="w-100"
        clearable
        allow-create
        default-first-option
        placeholder="Select or enter Customer"

      >
        <el-option
          v-for="item in customerOptions"
          :key="item"
          :label="item"
          :value="item"
        >
        </el-option>
      </el-select>
      </span>
      <span v-if="rowId !== scope.row.id && scope.$index !== createRow">
      {{ scope.row.customer_name }}
      </span>
      </template>
    </el-table-column>
      <el-table-column    
      label="Vehicle/ Schedule"
      width="125"
      prop="vehicle">
       <template slot-scope="scope" >
     <span v-if="rowId == scope.row.id || scope.$index == createRow">
       <el-select
        v-model="scope.row.vehicle"
        filterable       
        track-by="name"        
        value-key="id"
        class="w-100"
        clearable
        allow-create
        default-first-option
        placeholder="Select or enter Vehicle/Schedule"

      >
        <el-option
          v-for="item in vehicleOptions"
          :key="item"
          :label="item"
          :value="item"
        >
        </el-option>
      </el-select>
      </span>
      <span v-if="rowId !== scope.row.id && scope.$index !== createRow">
      {{ scope.row.vehicle }}
      </span>
      </template>
    </el-table-column>
      <el-table-column
      label="Contract #"
      width="125"
      prop="contract_num">
    <template slot-scope="scope" >
     <span v-if="rowId == scope.row.id || scope.$index == createRow">
       <el-select
        v-model="scope.row.contract_num"
        filterable       
        track-by="name"        
        value-key="id"
        class="w-100"
        clearable
        allow-create
        default-first-option
        placeholder="Select or enter Contract #"

      >
        <el-option
          v-for="item in contractNumber"
          :key="item"
          :label="item"
          :value="item"
        >
        </el-option>
      </el-select>
      </span>
      <span v-if="rowId !== scope.row.id && scope.$index !== createRow">
      {{ scope.row.contract_num }}
      </span>
      </template>
    </el-table-column>
    <el-table-column
      label="Award/TO #"
      width="125"
      prop="award_to_num">
       <template slot-scope="scope" >
     <span v-if="rowId == scope.row.id || scope.$index == createRow">
       <el-select
        v-model="scope.row.award_to_num"
        filterable       
        track-by="name"        
        value-key="id"
        class="w-100"
        clearable
        allow-create
        default-first-option
        placeholder="Select or enter Award/TO #"
      >
        <el-option
          v-for="item in awardToNums"
          :key="item"
          :label="item"
          :value="item"
        >
        </el-option>
      </el-select>
      </span>
      <span v-if="rowId !== scope.row.id && scope.$index !== createRow">
      {{ scope.row.award_to_num }}
      </span>
      </template>
    </el-table-column>
     <el-table-column
      label="NAICS"
      width="70"
      prop="naics">
     <template slot-scope="scope" >
      <span v-if="rowId == scope.row.id || scope.$index == createRow">
       <el-select
        v-model="scope.row.naics"
        filterable       
        track-by="name"        
        value-key="id"
        class="w-100"
        clearable
        allow-create
        default-first-option
        placeholder="Select or enter NAICS"
      >
        <el-option
          v-for="item in naicsOptions"
          :key="item"
          :label="item"
          :value="item"
        >
        </el-option>
      </el-select>
      </span>
      <span v-if="rowId !== scope.row.id && scope.$index !== createRow">
      {{ scope.row.naics }}
      </span>
      </template>
    </el-table-column>
     <el-table-column
      label="Award Type"
      width="70"
      prop="award_type">
      <template slot-scope="scope" >
      <span v-if="rowId == scope.row.id || scope.$index == createRow">
       <el-select
        v-model="scope.row.award_type"
        filterable       
        track-by="name"        
        value-key="id"
        class="w-100"
        clearable
        allow-create
        default-first-option
        placeholder="Select or enter Award Type"
      >
        <el-option
          v-for="item in awardTypes"
          :key="item"
          :label="item"
          :value="item"
        >
        </el-option>
      </el-select>
      </span>
      <span v-if="rowId !== scope.row.id && scope.$index !== createRow">
      {{ scope.row.award_type }}
      </span>
      </template>
    </el-table-column>
    <el-table-column
      label="Contract Type"
      width="75"
      prop="contract_type">
      <template slot-scope="scope" >
      <span v-if="rowId == scope.row.id || scope.$index == createRow">
       <el-select
        v-model="scope.row.contract_type"
        filterable       
        track-by="name"        
        value-key="id"
        class="w-100"
        clearable
        allow-create
        default-first-option
        placeholder="Select or enter Contract Type"
      >
        <el-option
          v-for="item in contractTypes"
          :key="item"
          :label="item"
          :value="item"
        >
        </el-option>
      </el-select>
      </span>
      <span v-if="rowId !== scope.row.id && scope.$index !== createRow">
      {{ scope.row.contract_type }}
      </span>
      </template>
    </el-table-column>
      <el-table-column
      label="Prime vs Sub"
      width="55"
      prop="prime_or_sub">
     <template slot-scope="scope" >
      <span v-if="rowId == scope.row.id || scope.$index == createRow">
       <el-select
        v-model="scope.row.prime_or_sub"
        track-by="name"        
        value-key="id"
        class="w-100"
        clearable
        default-first-option
  
      >
        <el-option
          v-for="item in primeOrSub"
          :key="item"
          :label="item"
          :value="item"
        >
        </el-option>
      </el-select>
      </span>
      <span v-if="rowId !== scope.row.id && scope.$index !== createRow">
      {{ scope.row.prime_or_sub }}
      </span>
      </template>
    </el-table-column>
     <el-table-column
      label="Contract Start Date"
      width="100"
      prop="contract_start_date">
       <template slot-scope="scope">
        <v2-date-picker
          name="Date"       
          v-if="scope.$index == createRow"
          value-type="YYYY-MM-DD"                     
          format="M/DD/YYYY"
          class="w-100"
          />
          <span v-else >
      {{ scope.row.contract_start_date }}
      </span>
     </template>
    </el-table-column>
     <el-table-column
      label="Contract End Date"
      width="100"
      prop="contract_end_date">
      <template slot-scope="scope">
        <v2-date-picker
          name="Date"       
          v-if="scope.$index == createRow"
          value-type="YYYY-MM-DD"                     
          format="M/DD/YYYY"
          class="w-100"
          />
          <span v-else >
      {{ scope.row.contract_end_date }}
      </span>
     </template>
    </el-table-column>
     <el-table-column
      label="Total Contract Value"
       width="115"
      prop="total_contract_val">
     <template slot-scope="scope">
     <el-input
      size="small"
      v-if="scope.$index == createRow"
      type="number"
      placeholder="Enter Total Contract Value"
      style="text-align:center"
      v-model="scope.row.total_contract_val"
      controls-position="right"
      ></el-input>
      <span v-if="rowId == scope.row.id && scope.$index !== createRow">
     <el-input
      size="small"      
      type="number"
      placeholder="Enter Total Contract Value"
      style="text-align:center"
      v-model="scope.row.total_contract_val"
      controls-position="right"
      ></el-input>
      </span>
      <span v-if="rowId !== scope.row.id && scope.$index !== createRow">
      {{ scope.row.total_contract_val }}
      </span>
    </template>

    </el-table-column>
    <el-table-column
      label="PoP's"
       width="100"
      prop="pops">
      <template slot-scope="scope" >
      <span v-if="rowId == scope.row.id || scope.$index == createRow">
       <el-select
        v-model="scope.row.pops"
        filterable       
        track-by="name"        
        value-key="id"
        class="w-100"
        clearable
        allow-create
        default-first-option
        placeholder="Select or enter PoPs"
      >
        <el-option
          v-for="item in pops"
          :key="item"
          :label="item"
          :value="item"
        >
        </el-option>
      </el-select>
      </span>
      <span v-if="rowId !== scope.row.id && scope.$index !== createRow">
      {{ scope.row.pops }}
      </span>
      </template>
    </el-table-column>
     <el-table-column
      label="Current PoP"
      width="100"
      prop="current_pop">
    <template slot-scope="scope" >
      <span v-if="rowId == scope.row.id || scope.$index == createRow">
       <el-select
        v-model="scope.row.current_pop"
        filterable       
        track-by="name"        
        value-key="id"
        class="w-100"
        clearable
        allow-create
        default-first-option
        placeholder="Select or enter Current PoP"
      >
        <el-option
          v-for="item in currentPops"
          :key="item"
          :label="item"
          :value="item"
        >
        </el-option>
      </el-select>
      </span>
      <span v-if="rowId !== scope.row.id && scope.$index !== createRow">
      {{ scope.row.current_pop }}
      </span>
      </template>
    </el-table-column>
    <el-table-column
      label="Contract PoP Start Date"
       width="100"
      prop="current_pop_start_date">
      <template slot-scope="scope">
        <v2-date-picker
          name="Date"       
          v-if="scope.$index == createRow"
          value-type="YYYY-MM-DD"                     
          format="M/DD/YYYY"
          class="w-100"
          />
        <span v-if="rowId == scope.row.id && scope.$index !== createRow">
         <v2-date-picker
          name="Date"       
          value-type="YYYY-MM-DD"                     
          format="M/DD/YYYY"
          class="w-100"
          />
        </span>
    <span v-if="rowId !== scope.row.id && scope.$index !== createRow">
      {{ scope.row.current_pop_start_date }}
      </span>
     </template>
    </el-table-column>
       <el-table-column
      label="Contract PoP End Date"
       width="100"
      prop="current_pop_end_date">
     <template slot-scope="scope">
     <v2-date-picker
          name="Date"       
          v-if="scope.$index == createRow"
          value-type="YYYY-MM-DD"                     
          format="M/DD/YYYY"
          class="w-100"
          />
        <span v-if="rowId == scope.row.id && scope.$index !== createRow">
         <v2-date-picker
          name="Date"       
          value-type="YYYY-MM-DD"                     
          format="M/DD/YYYY"
          class="w-100"
          />
        </span>
    <span v-if="rowId !== scope.row.id && scope.$index !== createRow">
      {{ scope.row.current_pop_end_date }}
      </span>
     </template>
    </el-table-column>
    <el-table-column
      label="Actions"
      width="95"
      fixed="right"
      align="center">
   <template slot-scope="scope">
      <el-button
        type="default"
        @click="saveEdits(scope.$index, scope.row)"
        v-if="scope.$index == rowIndex" 
        v-tooltip="`Save`" 
        class="bg-primary btn-sm text-light mx-0">               
        <i class="far fa-save"></i>
        </el-button>
      <el-button 
        type="default" 
        v-tooltip="`Cancel Edit`"       
        v-if="scope.$index == rowIndex"
        @click.prevent="cancelEdits(scope.$index, scope.row)"  
        class="bg-secondary btn-sm text-light mx-0">
      <i class="fas fa-ban"></i>
        </el-button>
         <el-button
          type="default"
           v-tooltip="`Edit`" 
          class="bg-light btn-sm"
           v-if="(scope.$index !== rowIndex) && (scope.$index !== createRow)"
          @click="editMode(scope.$index, scope.row)"><i class="fal fa-edit text-primary"></i>
          </el-button>
        <el-button
          type="default"
          @click="saveNewRow(scope.$index, scope.row)"
          v-if="scope.$index == createRow" 
          v-tooltip="`Save`" 
          class="bg-primary btn-sm text-light mx-0">               
        <i class="far fa-save"></i>
        </el-button>
       </template>

    </el-table-column>
  </el-table>
      <el-dialog
        :visible.sync="pocDialogVisible"
        append-to-body
        center
        class="p-0 users"       
      >
       <span slot="title" class="text-left">
        <h5 class="text-dark"><i class="fa-solid fa-address-card mr-2"></i>Add Contracts POC</h5>
      </span>
      <div class="container" >      
        <div class="row">
        
       <div class="col-12" v-if="pocData">
       <el-table
        :data="pocData.filter(data => !search || data.poc_name.toLowerCase().includes(search.toLowerCase()))"
        border
        height="400"
        style="width: 95%">
        <el-table-column
          fixed
          label="Name"
          width="150"
          prop="poc_name">
          <template slot-scope="scope">
            <el-input
              size="small"
              v-if="scope.$index == pocCreateRow"
              placeholder="Enter POC Name"
              style="text-align:center"
              v-model="scope.row.poc_name"
              controls-position="right"
            ></el-input>
            <span v-if="pocRowId == scope.row.id && scope.$index !== pocCreateRow">
            <el-input
              size="small"
              placeholder="Enter POC Name"
              style="text-align:center"
              v-model="scope.row.poc_name"
              controls-position="right"
              ></el-input>
            </span>
          <span v-if="pocRowId !== scope.row.id && scope.$index !== pocCreateRow">
            {{ scope.row.poc_name }} 
            </span>
            </template>
        </el-table-column>
        <el-table-column
          label="POC Title"
          width="150"
          prop="poc_title">
          <template slot-scope="scope">
            <el-input
              size="small"
              v-if="scope.$index == pocCreateRow"
              placeholder="Enter POC Title"
              style="text-align:center"
              v-model="scope.row.poc_title"
              controls-position="right"
            ></el-input>
            <span v-if="pocRowId == scope.row.id && scope.$index !== pocCreateRow">
            <el-input
              size="small"
              placeholder="Enter POC Title"
              style="text-align:center"
              v-model="scope.row.poc_title"
              controls-position="right"
              ></el-input>
            </span>
          <span v-if="pocRowId !== scope.row.id && scope.$index !== pocCreateRow">
            {{ scope.row.poc_title }} 
            </span>
            </template>
        </el-table-column>    
        <el-table-column
          label="Email"
          width="300"
          prop="poc_email">
          <template slot-scope="scope">
            <el-input
              size="small"
              v-if="scope.$index == pocCreateRow"
              placeholder="Enter POC Email"
              style="text-align:center"
              v-model="scope.row.poc_email"
              controls-position="right"
            ></el-input>
            <span v-if="pocRowId == scope.row.id && scope.$index !== pocCreateRow">
            <el-input
              size="small"
          placeholder="Enter POC Email"
              style="text-align:center"
              v-model="scope.row.poc_email"
              controls-position="right"
              ></el-input>
            </span>
          <span v-if="pocRowId !== scope.row.id && scope.$index !== pocCreateRow">
            {{ scope.row.poc_email }} 
            </span>
            </template>
        </el-table-column>
        <el-table-column
          label="POC Work Phone #"
          width="175"
          prop="title">
          <template slot-scope="scope">
            <el-input
              size="small"
              v-if="scope.$index == pocCreateRow"
              placeholder="Enter POC Work Phone #"
              style="text-align:center"
              v-model="scope.row.poc_work_num"
              controls-position="right"
            ></el-input>
            <span v-if="pocRowId == scope.row.id && scope.$index !== pocCreateRow">
            <el-input
              size="small"
              placeholder="Enter POC Work Phone #"
              style="text-align:center"
              v-model="scope.row.poc_work_num"
              controls-position="right"
              ></el-input>
            </span>
          <span v-if="pocRowId !== scope.row.id && scope.$index !== pocCreateRow">
            {{ scope.row.poc_work_num }} 
            </span>
            </template>
        </el-table-column>
        <el-table-column
          label="POC Mobile Phone #"
          width="175"
          prop="title">
          <template slot-scope="scope">
            <el-input
              size="small"
              v-if="scope.$index == pocCreateRow"
              placeholder="Enter POC Mobile Phone #"
              style="text-align:center"
              v-model="scope.row.poc_mobile_num"
              controls-position="right"
            ></el-input>
            <span v-if="pocRowId == scope.row.id && scope.$index !== pocCreateRow">
            <el-input
              size="small"
              placeholder="Enter POC Mobile Phone #"
              style="text-align:center"
              v-model="scope.row.poc_mobile_num"
              controls-position="right"
              ></el-input>
            </span>
          <span v-if="pocRowId !== scope.row.id && scope.$index !== pocCreateRow">
            {{ scope.row.poc_mobile_num }} 
            </span>
            </template>
        </el-table-column>
        <el-table-column
          label="Notes"
          width="350"
          prop="poc_notes">
          <template slot-scope="scope">
            <el-input
              size="small"
              v-if="scope.$index == pocCreateRow"
              placeholder="Notes"
              style="text-align:center"
              v-model="scope.row.poc_notes"
              controls-position="right"
            ></el-input>
            <span v-if="pocRowId == scope.row.id && scope.$index !== pocCreateRow">
            <el-input
              size="small"
              placeholder="Notes"
              style="text-align:center"
              v-model="scope.row.poc_notes"
              controls-position="right"
              ></el-input>
            </span>
          <span v-if="pocRowId !== scope.row.id && scope.$index !== pocCreateRow">
            {{ scope.row.poc_notes }} 
            </span>
            </template>
        </el-table-column>
        <el-table-column
          label="Actions"
          width="95"
          fixed="right"
          align="center">
         <template slot-scope="scope">
          <el-button
            type="default"
            @click="saveEdits(scope.$index, scope.row)"
            v-if="scope.$index == pocRowIndex" 
            v-tooltip="`Save`" 
            class="bg-primary btn-sm text-light mx-0">               
            <i class="far fa-save"></i>
            </el-button>
          <el-button 
            type="default" 
            v-tooltip="`Cancel Edit`"       
            v-if="scope.$index == pocRowIndex"
            @click.prevent="cancelPocEdits(scope.$index, scope.row)"  
            class="bg-secondary btn-sm text-light mx-0">
          <i class="fas fa-ban"></i>
            </el-button>
            <el-button
              type="default"
              v-tooltip="`Edit`" 
              class="bg-light btn-sm"
              v-if="(scope.$index !== pocRowIndex) && (scope.$index !== pocCreateRow)"
              @click="editPocRow(scope.$index, scope.row)"><i class="fal fa-edit text-primary"></i>
              </el-button>
            <el-button
              type="default"
              @click="saveNewPocRow(scope.$index, scope.row)"
              v-if="scope.$index == pocCreateRow" 
              v-tooltip="`Save`" 
              class="bg-primary btn-sm text-light mx-0">               
            <i class="far fa-save"></i>
            </el-button>
          </template>

        </el-table-column>
       </el-table>
    
       </div> 
        </div>

      </div>
      </el-dialog>

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
    <i v-tooltip="`Manage POCs`" class="far fa-plus-circle mr-1" :class="[ pane3? 'bootstrap-purple-text' : 'd-none']" @click="openPocModal"></i> 
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
        pocDialogVisible: false,
        rowIndex: null, 
        rowId: null, 
        pocRowIndex: null, 
        pocRowId: null, 
        pane0: true, 
        pane1: false, 
        pane2: false, 
        pane3: false, 
        pane4: false, 
        tabPosition: 'bottom',
        awardToNums: [ 
                       '000-33340-3', 
                       'ZPPPP-18F0001',
                       'ZZ-VVBCKG0',
                       'CCCC-008-002'
                       ],
       primeOrSub: [ 
                      'Prime', 
                       'Sub',
                         ],                     
       contractNumber:   [ 
                       '000-33340-3', 
                       'ZPPPP-18F0001',
                       'ZZ-VVBCKG0',
                       'CCCC-008-002'
                        ],
        vehicleOptions: [ 
                        '000-33340-3', 
                       'ZPPPP-18F0001',
                       'ZZ-VVBCKG0',
                       'CCCC-008-002'
                       ],
        customerOptions: [ 
                       'Consulting, LLC', 
                       'Security Incorprated',
                       'Accolade, Inc.',
                       'Department of Acme',
                       'American Honor',
                       'Health & Human Services'
                       ],
        naicsOptions: [ 
                       'NA', 
                       '541611-$16.5M',
                       '541512-$30M',
                       '541512',
                       '519190'
                       ],
        awardTypes:   [ 
                      'NA', 
                      'SDVOSB',
                      'SBA 8a',
                       ],
        pops:          [ 
                      'Base Period',
                      'Base + 2 OYs',
                      'Base + 4 OYs', 
                      'Yearly',
                      '6 mo Base + 1 OY',
                      '9 mo BP + 1 OY',
                       ],

       currentPops:   [ 
                      'Base',
                      'OY1',
                      'OY2',
                      'OY3',
                      'OY4',
                      'Year1',
                      'Year2',
                      'Year3',
                        ],
       contractTypes:  [ 
                      'FFP/FFPU',
                      'FFP', 
                      'T&M',
                       ],
       contractsArray: [{
          id:0,
          charge_code: '383',
          customer_name: 'Tech Consulting Unlimited, LLC',
          project_name: 'KADNK Admin',         
          vehicle: 'NA',
          contract_num:'esdgdsgfsad',
          award_to_num: '9494030293-2',
          naics: 'NA',
          award_type: 'NA',
          contract_type: 'FFP',
          prime_or_sub: 'Sub',
          contract_start_date: '6/19/2021',
          contract_end_date: '8/27/2022',
          billings_to_date: 734365.35,
          total_funded_val: 7999430.32,
          total_contract_val: 7999430.32,
          pops: 'Base + 4 OYs',
          current_pop: 'OY4 extension',
          current_pop_start_date: '1/19/2022',
          current_pop_end_date: '8/27/2022',
          notes: ''
        }, {
          id:1,
          charge_code: '383',
          customer_name: 'Tech Consulting Unlimited, LLC',
          project_name: 'KADNK Admin',         
          vehicle: 'NA',
          contract_num:'esdgdsgfsad',
          award_to_num: '9494030293-2',
          naics: 'NA',
          award_type: 'NA',
          contract_type: 'FFP',
          prime_or_sub: 'Sub',
          contract_start_date: '6/19/2021',
          contract_end_date: '8/27/2022',
          billings_to_date: 734365.35,
          total_funded_val: 7999430.32,
          total_contract_val: 7999430.32,
          pops: 'Base + 4 OYs',
          current_pop: 'OY4 extension',
          current_pop_start_date: '1/19/2022',
          current_pop_end_date: '8/27/2022',
          notes: ''
        }, {
          id:2,
          charge_code: '383',
          customer_name: 'Tech Consulting Unlimited, LLC',
          project_name: 'KADNK Admin',         
          vehicle: 'NA',
          contract_num:'esdgdsgfsad',
          award_to_num: '9494030293-2',
          naics: 'NA',
          award_type: 'NA',
          contract_type: 'FFP',
          prime_or_sub: 'Sub',
          contract_start_date: '6/19/2021',
          contract_end_date: '8/27/2022',
          billings_to_date: 734365.35,
          total_funded_val: 7999430.32,
          total_contract_val: 7999430.32,
          pops: 'Base + 4 OYs',
          current_pop: 'OY4 extension',
          current_pop_start_date: '1/19/2022',
          current_pop_end_date: '8/27/2022',
          notes: ''
        }, {
          id:3,
          charge_code: '383',
          customer_name: 'Tech Consulting Unlimited, LLC',
          project_name: 'KADNK Admin',         
          vehicle: 'NA',
          contract_num:'esdgdsgfsad',
          award_to_num: '9494030293-2',
          naics: 'NA',
          award_type: 'NA',
          contract_type: 'FFP',
          prime_or_sub: 'Sub',
          contract_start_date: '6/19/2021',
          contract_end_date: '8/27/2022',
          billings_to_date: 734365.35,
          total_funded_val: 7999430.32,
          total_contract_val: 7999430.32,
          pops: 'Base + 4 OYs',
          current_pop: 'OY4 extension',
          current_pop_start_date: '1/19/2022',
          current_pop_end_date: '8/27/2022',
          notes: ''
        }, {
          id:4,
          charge_code: '383',
          customer_name: 'Tech Consulting Unlimited, LLC',
          project_name: 'KADNK Admin',         
          vehicle: 'NA',
          contract_num:'esdgdsgfsad',
          award_to_num: '9494030293-2',
          naics: 'NA',
          award_type: 'NA',
          contract_type: 'FFP',
          prime_or_sub: 'Sub',
          contract_start_date: '6/19/2021',
          contract_end_date: '8/27/2022',
          billings_to_date: 734365.35,
          total_funded_val: 7999430.32,
          total_contract_val: 7999430.32,
          pops: 'Base + 4 OYs',
          current_pop: 'OY4 extension',
          current_pop_start_date: '1/19/2022',
          current_pop_end_date: '8/27/2022',
          notes: 'Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in'
        }, {
          id:5,
          charge_code: '383',
          customer_name: 'Tech Consulting Unlimited, LLC',
          project_name: 'KADNK Admin',         
          vehicle: 'NA',
          contract_num:'esdgdsgfsad',
          award_to_num: '9494030293-2',
          naics: 'NA',
          award_type: 'NA',
          contract_type: 'FFP',
          prime_or_sub: 'Sub',
          contract_start_date: '6/19/2021',
          contract_end_date: '8/27/2022',
          billings_to_date: 734365.35,
          total_funded_val: 7999430.32,
          total_contract_val: 7999430.32,
          pops: 'Base + 4 OYs',
          current_pop: 'OY4 extension',
          current_pop_start_date: '1/19/2022',
          current_pop_end_date: '8/27/2022',
          notes: 'Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in'
        }, {
          id:6,
          charge_code: '383',
          customer_name: 'Tech Consulting Unlimited, LLC',
          project_name: 'KADNK Admin',         
          vehicle: 'NA',
          contract_num:'esdgdsgfsad',
          award_to_num: '9494030293-2',
          naics: 'NA',
          award_type: 'NA',
          contract_type: 'FFP',
          prime_or_sub: 'Sub',
          contract_start_date: '6/19/2021',
          contract_end_date: '8/27/2022',
          billings_to_date: 734365.35,
          total_funded_val: 7999430.32,
          total_contract_val: 7999430.32,
          pops: 'Base + 4 OYs',
          current_pop: 'OY4 extension',
          current_pop_start_date: '1/19/2022',
          current_pop_end_date: '8/27/2022',
          notes: 'Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in'
        }, {
          id:7,
          charge_code: '383',
          customer_name: 'Tech Consulting Unlimited, LLC',
          project_name: 'KADNK Admin',         
          vehicle: 'NA',
          contract_num:'esdgdsgfsad',
          award_to_num: '9494030293-2',
          naics: 'NA',
          award_type: 'NA',
          contract_type: 'FFP',
          prime_or_sub: 'Sub',
          contract_start_date: '6/19/2021',
          contract_end_date: '8/27/2022',
          billings_to_date: 734365.35,
          total_funded_val: 7999430.32,
          total_contract_val: 7999430.32,
          pops: 'Base + 4 OYs',
          current_pop: 'OY4 extension',
          current_pop_start_date: '1/19/2022',
          current_pop_end_date: '8/27/2022',
          notes: 'Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in'
        }, {
          id:8,
          charge_code: '383',
          customer_name: 'Tech Consulting Unlimited, LLC',
          project_name: 'KADNK Admin',         
          vehicle: 'NA',
          contract_num:'esdgdsgfsad',
          award_to_num: '9494030293-2',
          naics: 'NA',
          award_type: 'NA',
          contract_type: 'FFP',
          prime_or_sub: 'Sub',
          contract_start_date: '6/19/2021',
          contract_end_date: '8/27/2022',
          billings_to_date: 734365.35,
          total_funded_val: 7999430.32,
          total_contract_val: 7999430.32,
          pops: 'Base + 4 OYs',
          current_pop: 'OY4 extension',
          current_pop_start_date: '1/19/2022',
          current_pop_end_date: '8/27/2022',
          notes: 'Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in'
        }, {
          id:9,
          charge_code: '383',
          customer_name: 'Tech Consulting Unlimited, LLC',
          project_name: 'KADNK Admin',         
          vehicle: 'NA',
          contract_num:'esdgdsgfsad',
          award_to_num: '9494030293-2',
          naics: 'NA',
          award_type: 'NA',
          contract_type: 'FFP',
          prime_or_sub: 'Sub',
          contract_start_date: '6/19/2021',
          contract_end_date: '8/27/2022',
          billings_to_date: 734365.35,
          total_funded_val: 7999430.32,
          total_contract_val: 7999430.32,
          pops: 'Base + 4 OYs',
          current_pop: 'OY4 extension',
          current_pop_start_date: '1/19/2022',
          current_pop_end_date: '8/27/2022',
          notes: 'Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in'
        }, {
          id:10,
          charge_code: '383',
          customer_name: 'Tech Consulting Unlimited, LLC',
          project_name: 'KADNK Admin',         
          vehicle: 'NA',
          contract_num:'esdgdsgfsad',
          award_to_num: '9494030293-2',
          naics: 'NA',
          award_type: 'NA',
          contract_type: 'FFP',
          prime_or_sub: 'Sub',
          contract_start_date: '6/19/2021',
          contract_end_date: '8/27/2022',
          billings_to_date: 734365.35,
          total_funded_val: 7999430.32,
          total_contract_val: 7999430.32,
          pops: 'Base + 4 OYs',
          current_pop: 'OY4 extension',
          current_pop_start_date: '1/19/2022',
          current_pop_end_date: '8/27/2022',
          notes: 'Lorem ipsum, or lipsum as it is somet'
        }, {
          id:11,
          charge_code: '383',
          customer_name: 'Tech Consulting Unlimited, LLC',
          project_name: 'KADNK Admin',         
          vehicle: 'NA',
          contract_num:'esdgdsgfsad',
          award_to_num: '9494030293-2',
          naics: 'NA',
          award_type: 'NA',
          contract_type: 'FFP',
          prime_or_sub: 'Sub',
          contract_start_date: '6/19/2021',
          contract_end_date: '8/27/2022',
          billings_to_date: 734365.35,
          total_funded_val: 7999430.32,
          total_contract_val: 7999430.32,
          pops: 'Base + 4 OYs',
          current_pop: 'OY4 extension',
          current_pop_start_date: '1/19/2022',
          current_pop_end_date: '8/27/2022',
          notes: 'Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in'
   
         }],
         pocsArray: [{
          id: 0,
          poc_name: 'David Pumphrey',
          poc_title: 'Program Manager',
          poc_email: 'david.pumphrey@microhealthllc.com',
          poc_work_num: 8753334567,
          poc_mobile_num: 8753334567,
          notes:'Lorem ipsum dolor sit amet, consectetur adipiscing eliua.',
        }, {
          id: 1,
          poc_name: 'Michael Holmes',
          poc_title: 'Program Manager',
          poc_email: 'michael.holmes@microhealthllc.com',
          poc_work_num: 8753334567,
          poc_mobile_num: 8753334567,
          notes:'Lorem ipsum dolor sit amet, consectetur adipiscing eliua.',
        }, {
          id: 2,
          poc_name: 'Phillip Edmonds',
          poc_title: 'Program Manager',
          poc_email: 'phillip.edmonds.pumphrey@microhealthllc.com',
          poc_work_num: 8753334567,
          poc_mobile_num: 8753334567,
          notes:'Lorem ipsum dolor sit amet, consectetur adipiscing eliua.',
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
  openPocModal(){
    this.pocDialogVisible = true;
  },   
  editMode(index, rows) {
    this.rowIndex = index,
     console.log(rows);
       console.log(this.createRow);
    this.rowId = rows.id
  }, 
  editPocRow(index, rows) {
    this.pocRowIndex = index,
     console.log(rows);
    this.pocRowId = rows.id
  },  
  savePocEdits(){
    // Row edit action will occur here
    this.pocRowIndex = null;
    this.pocRowId = null;
  }, 
  saveNewPocRow(){
    // Row create action will occur here
    //After save, dont forget to push new empty object to append new create row
     this.pocRowIndex = null;
    this.pocRowId = null;
  },
  saveEdits(){
    // Row edit action will occur here
    this.rowIndex = null;
    this.rowId = null;
  }, 
  saveNewRow(){
    // Row create action will occur here
    //After save, dont forget to push new empty object to append new create row
    this.rowIndex = null;
    this.rowId = null;
  },
  cancelPocEdits() {
    this.pocRowIndex = null;
    this.pocRowId = null;
       
  },
  cancelEdits(index, rows) {
    this.rowIndex = null;
    this.rowId = null;
       
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
  tableData(){
      if (this.contractsArray && this.contractsArray.length > 0){
        let data = this.contractsArray
        data.push({})
        return data
     }
    },
    createRow(){
      let lastItem = this.tableData.length - 1
       console.log(lastItem)
      return lastItem
    },
   pocData(){
      if (this.pocsArray && this.pocsArray.length > 0){
        let data = this.pocsArray
        data.push({})
        return data
     }
    },
    pocCreateRow(){
      let lastItem = this.pocData.length - 1
       console.log(lastItem)
      return lastItem
    },
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

    tr, td {
      word-break: break-word;
    }


  }    
</style>