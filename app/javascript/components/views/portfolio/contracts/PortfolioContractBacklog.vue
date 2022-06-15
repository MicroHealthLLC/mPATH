<template>
   <div style="height:80vh" class="portfolio-contracts-module">
    <div  style="height: 100%; overflow-y:auto">
     <el-table
    :data="tableData"
    border
    height="800"
    style="width: 95%"
    :summary-method="getSummaries"
    show-summary
    >
    <el-table-column
      fixed
      label="Code"
      width=""
      prop="charge_code">
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
      prop="contract_customer.name">    
    </el-table-column> 
     <el-table-column
      label="Contract Start Date"
      width="100"
      prop="contract_start_date">
      <template slot-scope="scope">
     {{ moment(scope.row.contract_start_date).format("MM-DD-YYYY") }}
      </template>
    </el-table-column>
     <el-table-column
      label="Contract End Date"
      width="100"
      prop="contract_end_date">
       <template slot-scope="scope">
     {{ moment(scope.row.contract_end_date).format("MM-DD-YYYY") }}
      </template>
     </el-table-column>
     <el-table-column
      label="Total Contract Value"
       width="115"
      prop="total_contract_value">
       <template slot-scope="scope">
        {{ scope.row.total_contract_value | toCurrency }}
       </template>
    </el-table-column>
    <el-table-column
      label="Total Funded Value"
       width="115"
      prop="total_founded_value">
     <template slot-scope="scope">
     <span v-if="rowId == scope.row.id">
     <el-input
      size="small"      
      type="number"
      placeholder=""
      style="text-align:center"
      v-model="scope.row.total_founded_value"
      controls-position="right"
      ></el-input>
      </span>
      <span v-else>
      {{ scope.row.total_founded_value | toCurrency }}
      </span>
    </template>
    </el-table-column>  
     <el-table-column
      label="Billings to Date"
       width="115"
      prop="billings_to_date">
     <template slot-scope="scope">
     <span v-if="rowId == scope.row.id">
     <el-input
      size="small"      
      type="number"
      placeholder=""
      style="text-align:center"
      v-model="scope.row.billings_to_date"
      controls-position="right"
      ></el-input>
      </span>
      <span v-else>
      {{ scope.row.billings_to_date | toCurrency }}
      </span>
    </template>
    </el-table-column>   
     <el-table-column
      label="%Completed"
       width="115"
      >
      <template slot-scope="scope">
     <span v-if="scope.row.billings_to_date && scope.row.total_contract_value ">
      <!-- {{(scope.row.billings_to_date / scope.row.total_contract_value).toFixed(2) }}% -->
      {{ Number((scope.row.billings_to_date / scope.row.total_contract_value)/1).toLocaleString(undefined,{style: 'percent', minimumFractionDigits:0}) }}
      
     </span>
      </template>
    </el-table-column>
    <el-table-column
       label="Funded Remaining"
       width="115"
       prop="scope.row.total_founded_value - scope.row.billings_to_date"
      >
       <template slot-scope="scope">
       <span v-if="scope.row.billings_to_date && scope.row.total_founded_value ">
         {{ (scope.row.total_founded_value - scope.row.billings_to_date) | toCurrency }}
        </span>     
       </template>       
    </el-table-column>
    <el-table-column
      label="Total Backlog (Sum of A & B)"
       width="115"
      >
     <template slot-scope="scope">
    <span v-if="scope.row.billings_to_date && scope.row.total_contract_value ">
      {{ (scope.row.total_contract_value - scope.row.billings_to_date) | toCurrency }}
      </span>
     </template>

    </el-table-column>
     <el-table-column
       label="Notes/Questions"
       width="300"
      >
      <template slot-scope="scope">
       <span v-if="rowId == scope.row.id">
        <el-input
          size="small"
          style="text-align:center"
          v-model="scope.row.comments"
          controls-position="right"
          ></el-input>
        </span>
        <span v-else>
          <span v-if="scope.row.comments && scope.row.comments !== 'null'">
            {{ scope.row.comments }}
          </span>
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
        @click="saveBacklogValues(scope.$index, scope.row)"
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
           v-if="(scope.$index !== rowIndex)"
          @click="editMode(scope.$index, scope.row)"><i class="fal fa-edit text-primary"></i>
          </el-button>
        </template>

    </el-table-column>
  </el-table>
      </div>
    </div>


 
</template>
    
<script>
import { mapGetters, mapMutations, mapActions } from "vuex";
  Vue.filter('toCurrency', function (value) {
      if (typeof value !== "number") {
          return value;
      }
      var formatter = new Intl.NumberFormat('en-US', {
          style: 'currency',
          currency: 'USD'
      });
      return formatter.format(value);
  });
export default {
  name: "PortfolioContractBacklog",
  components: { 
  },
    data() {    
      return {
        nothing: true,
        rowIndex: null, 
        today: new Date().toISOString().slice(0, 10),
        rowId: null, 
        tabPosition: 'bottom',
        search: '',
    };
  },
  methods: {
  ...mapMutations([
    "SET_CONTRACT_PROJECT_STATUS"
  ]),
  ...mapActions([
    "updateContractProject",
    "fetchContractProjects",
  ]),  
   _isallowed(salut) {
            return  []
        // return this.checkPrivileges("PortfolioContracts", salut, this.$route, {settingType: 'Contracts'})
  }, 
  getSummaries(param) {
    const { columns, data } = param;
    const sums = [];
    columns.forEach((column, index) => {
      if (index === 0) {
        sums[index] = 'Totals';
        return;
      }
      const values = data.map(item => Number(item[column.property]));
      if (!values.every(value => isNaN(value))) {
        sums[index] = values.reduce((prev, curr) => {
          const value = Number(curr);
         if (!isNaN(value)) {
            return prev + curr;
          } else {
            return prev;
          }
        }, 0);
      } else {
        sums[index] = '';
      }
    });
     let newSums = ['Totals']
      for (const ele of sums) {
        if (ele !== 'Totals'){          
            newSums.push(ele.toLocaleString('en-US', {
            style: 'currency',
            currency: 'USD',
          }))
        }          
      }       
     return newSums
  },
  saveBacklogValues(index, row){
    this.rowIndex = null;
    this.rowId = null;
    let contractProjectData = {
          cProjectData: {
            tfv: row.total_founded_value,
            btd: row.billings_to_date,
            notes: row.comments
        },
      }
      let id = row.id
      this.updateContractProject({...contractProjectData, id})    
  },
  backHomeBtn() {
      window.location.pathname = "/";
    },
 editMode(index, rows) {
    this.rowIndex = index,
    this.rowId = rows.id
    // console.log(rows)
  },  
  saveEdits(){
    // Row edit action will occur here
    this.rowIndex = null;
    this.rowId = null;
  }, 
  saveNewRow(){
    this.rowIndex = null;
    this.rowId = null;
  },
  cancelEdits(index, rows) {
    this.rowIndex = null;
    this.rowId = null;       
  },    
  },
  mounted() {
    
  },
  computed: {
    ...mapGetters([
     "contractProjectStatus",
     "contractProjects"
    ]),   
   tableData(){
    if (this.contractProjects && this.contractProjects.length > 0){
      let validProjects = this.contractProjects.filter(t => t && t.id)
       return validProjects.filter(t => t.contract_end_date > this.today)
     }      
    }, 
  },
  watch: {
   contractProjectStatus: {
      handler() {
        if (this.contractProjectStatus == 200) {
          this.$message({
            message: `Contract POCs saved successfully.`,
            type: "success",
            showClose: true,
          });
          this.SET_CONTRACT_PROJECT_STATUS(0);
          this.fetchContractProjects();
        }
      },
    },   
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
    th {
      color: #383838;
    }
  }    
</style>