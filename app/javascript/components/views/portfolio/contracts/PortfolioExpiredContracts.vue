<template>
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
          
</template>
    
<script>
import { mapGetters, mapMutations, mapActions } from "vuex";
export default {
  name: "PortfolioExpiredContracts",
   data() {    
      return {
        nothing: true,
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