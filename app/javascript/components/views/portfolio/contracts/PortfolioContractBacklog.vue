<template>
   <div style="height:80vh" class="portfolio-contracts-module">
    <div style="height: 80vh; overflow-y:auto">
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
      width="125"
      prop="contract_end_date">
       <template slot-scope="scope">
      <span v-if="scope.row.ignore_expired == true" v-tooltip="`Exempt from expiration`" >
        <i class="fa-solid fa-calendar-xmark text-success"></i>
      </span>
     {{ moment(scope.row.contract_end_date).format("MM-DD-YYYY") }}
      </template>
     </el-table-column>
     <el-table-column
      label="Total Contract Value"
       width="175"
      prop="total_contract_value">
       <template slot-scope="scope">
        {{ scope.row.total_contract_value | toCurrency }}
       </template>
    </el-table-column>
    <el-table-column
      label="Total Funded Value"
       width="175"
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
       width="175"
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
     <span v-if="scope.row.billings_to_date && scope.row.total_contract_value && scope.row.billings_to_date > 0 && scope.row.total_contract_value > 0">
      {{ Number((scope.row.billings_to_date / scope.row.total_contract_value)/1).toLocaleString(undefined,{style: 'percent', minimumFractionDigits:0}) }}
      
     </span>
      </template>
    </el-table-column>
    <el-table-column
       label="Funding Remaining"
       width="175"
            >
       <template slot-scope="scope">
       <span v-if="scope.row.billings_to_date && scope.row.total_founded_value ">
         {{ (scope.row.total_founded_value - scope.row.billings_to_date) | toCurrency }}
        </span>     
       </template>       
    </el-table-column>
    <el-table-column
      label="Total Backlog"
       width="175"       
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
      v-if="_isallowed('write') || _isallowed('delete')"
      align="center">
   <template slot-scope="scope">
      <el-button
        size="mini"
        type="default"
        @click="saveBacklogValues(scope.$index, scope.row)"
        v-if="scope.$index == rowIndex && _isallowed('write')" 
        v-tooltip="`Save`" 
        class="bg-primary text-light px-2">               
        <i class="far fa-save"></i>
        </el-button>
      <el-button 
        size="mini"
        type="default" 
        v-tooltip="`Cancel Edit`"       
        v-if="scope.$index == rowIndex"
        @click.prevent="cancelEdits(scope.$index, scope.row)"  
        class="bg-secondary text-light px-2">
      <i class="fas fa-ban"></i>
        </el-button>
         <el-button
         size="mini"
          type="default"
           v-tooltip="`Edit`" 
          class="bg-light px-2"
           v-if="(scope.$index !== rowIndex) &&  _isallowed('write')"
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
     return this.checkPortfolioContractPrivileges("PortfolioContracts", salut, this.$route, {settingType: 'Contracts'})
  }, 
  getSummaries(param) {
    const { columns, data } = param;
    const sums = [];
    columns.forEach((column, index) => {
      if (index === 0) {
        sums[index] = 'Totals';
        return;
      }
     if (index === 9) {
        sums[index] = 'FR';
        return;
      }
     if (index === 10) {
        sums[index] = 'BL';
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
     
         
      let fundRemaining = (sums[6] - sums[7]);
      let totalBacklog = (sums[5] - sums[7]);      
      //  console.log(fundRemaining)  
 
      const newArr = sums.map(element => {
          if (element === 'FR' ) {
            return fundRemaining;
          }
          if (element === 'BL' ) {
            return totalBacklog
          }
          return element;
        });

      for (const ele of newArr) {
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
    this.fetchContractProjects();    
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
       return validProjects.filter(t => t.contract_end_date > this.today  || t.ignore_expired == true)
     }      
    }, 
  },
  watch: {
   contractProjectStatus: {
      handler() {
        if (this.contractProjectStatus == 200) {
          MessageDialogService.showDialog({
            message: `Contract POCs saved successfully.`,
            
            
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
::v-deep.el-table {
    th {
      color: #383838;
    }
  }    
</style>