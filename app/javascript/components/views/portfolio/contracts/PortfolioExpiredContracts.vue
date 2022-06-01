<template>
  <div style="height:80vh" class="portfolio-contracts-module">
   <div  style="height: 100%; overflow-y:auto" v-if="contractProjects && contractProjects.length > 0">
   <el-table
    :data="contractProjects.filter(t => t && t.id && t.contract_end_date < today)"
    border
    height="800"
    style="width: 95%">
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
      >
     <template slot-scope="scope" >
      <span v-if="scope.row.contract_customer && scope.row.contract_customer.name !== null">
      {{ scope.row.contract_customer.name }}
      </span>
      </template>
    </el-table-column>
      <el-table-column    
      label="Vehicle/ Schedule"
      width="125"
      prop="contract_vehicle">
       <template slot-scope="scope" >
     <span v-if="scope.row.contract_vehicle && scope.row.contract_vehicle.name !== null">
      {{ scope.row.contract_vehicle.name }}
      </span>
      </template>
    </el-table-column>
      <el-table-column
      label="Contract #"
      width="125"
      prop="number">
    <template slot-scope="scope" >     
      <span v-if="scope.row.number && scope.row.number.name !== null">
      {{ scope.row.number }}
      </span>
      </template>
    </el-table-column>
    <el-table-column
      label="Award/TO #"
      width="125"
      prop="contract_award_to_id">
       <template slot-scope="scope" >
      <span v-if="scope.row.contract_award_to && scope.row.contract_award_to.name !== null">
      {{ scope.row.contract_award_to.name }}
      </span>
      </template>
    </el-table-column>
     <el-table-column
      label="NAICS"
      width="70"
      prop="contract_naic_id">
     <template slot-scope="scope" >
    <span v-if="scope.row.contract_naic && scope.row.contract_naic.name !== null">
      {{ scope.row.contract_naic.name }}
      </span>
      </template>
    </el-table-column>
     <el-table-column
      label="Award Type"
      width="70"
      prop="contract_award_type_id">
      <template slot-scope="scope" >
       <span v-if="scope.row.contract_award_type && scope.row.contract_award_type.name !== null">
      {{ scope.row.contract_award_type.name }}
      </span>
      </template>
    </el-table-column>
    <el-table-column
      label="Contract Type"
      width="75"
      prop="contract_type_id">
      <template slot-scope="scope" >
      <span v-if="scope.row.contract_type && scope.row.contract_type.name !== null">
      {{ scope.row.contract_type.name }}
      </span>
      </template>
    </el-table-column>
      <el-table-column
      label="Prime vs Sub"
      width="55"
      prop="prime_or_sub">
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
      <span>
      {{ scope.row.total_contract_value | toCurrency }}
      </span>
    </template>
   </el-table-column>
    <el-table-column
      label="PoP's"
       width="100"
      prop="contract_pop_id">
      <template slot-scope="scope" >
     <span v-if="scope.row.contract_pop && scope.row.contract_pop.name !== null">
      {{ scope.row.contract_pop.name }}
      </span>
      </template>
    </el-table-column>
     <el-table-column
      label="Current PoP"
      width="100"
      prop="contract_current_pop_id">
    <template slot-scope="scope" >
     <span v-if="scope.row.contract_current_pop && scope.row.contract_current_pop.name !== null">
      {{ scope.row.contract_current_pop.name }}
      </span>
      </template>
    </el-table-column>
    <el-table-column
      label="Contract PoP Start Date"
       width="100"
      prop="contract_current_pop_start_date">
       <template slot-scope="scope">
       {{ moment(scope.row.contract_current_pop_start_date).format('MM-DD-YYYY') }}
       </template>
   
    </el-table-column>
     <el-table-column
      label="Contract PoP End Date"
       width="100"
      prop="contract_current_pop_end_date">
     <template slot-scope="scope">
      {{ moment(scope.row.contract_current_pop_end_date).format('MM-DD-YYYY') }}
      </template>
    </el-table-column>  
  </el-table>
      </div>
      </div>
          
</template>
    
<script>
import { mapGetters } from "vuex";
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
  name: "PortfolioExpiredContracts",
   data() {    
      return {
        nothing: true,
        search: '',
        today: new Date().toISOString().slice(0, 10)
    };
  },
  computed: {
    ...mapGetters([
     "contractProjects"
    ]),   
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