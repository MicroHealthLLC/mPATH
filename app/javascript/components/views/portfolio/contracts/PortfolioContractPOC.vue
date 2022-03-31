<template>
 
    <div style="height:80vh">
      <div  style="height: 100%; overflow-y:auto">
    <el-table
    :data="tableData.filter(data => !search || data.name.toLowerCase().includes(search.toLowerCase()))"
    border
    height="800"
    style="width: 95%">
     <el-table-column
      fixed
      label="Charge Code"
      width="125"
      prop="code">
    </el-table-column>
   <el-table-column
      fixed
      label="Project Name"
      width="200"
      prop="name">
    </el-table-column>
   
     <el-table-column
      label="Contract Program Manager POC"
       width="250"
      prop="poc">
    </el-table-column>
      <el-table-column
      label="Government COR POC / Prime POC"
       width="250"
      prop="gpoc">
    </el-table-column>
     <el-table-column
      label="Contracting Office POC"
       width="250"
      prop="office_poc">
    </el-table-column>
    
    <el-table-column
     label="Actions"
      width="75"
    >
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
  name: "PortfolioContractPOC",
  components: {
  
  },

    data() {    
      return {
        nothing: true,
        tabPosition: 'bottom',
        tableData: [{
          code: 4123, 
          poc: 'Michael  Holmes, 571-303-9150', 
          name: 'Tom',
          gpoc: 'Michael  Holmes, 571-303-9150', 
          office_poc: 'FTC contracting'
        }, {
          code: 1233, 
          poc: 'Gloria Walker, Program Manager, Gloria.Walker@microhealthllc.com, (301) 213–9060', 
          name: 'John',
          gpoc: 'Michael  Holmes, 571-303-9150', 
          office_poc: 'FTC contracting'        
        }, {        
          code: 123, 
          poc: 'Mark Gordy, Program Manager, mark.gordy@hq.doe.gov, 410-482-0060', 
          name: 'Tom',
          gpoc: 'Michael  Holmes, 571-303-9150', 
          office_poc: 'FTC contracting'
        }, {
          code: 123, 
          poc: 'Gloria Walker, Program Manager, Gloria.Walker@microhealthllc.com, (301) 213–9060', 
          name: 'John',
          gpoc: 'Michael  Holmes, 571-303-9150', 
          office_poc: 'FTC contracting'        
        }, {
                code: 4123, 
          poc: 'Michael  Holmes, 571-303-9150', 
          name: 'Tom',
          gpoc: 'Michael  Holmes, 571-303-9150', 
          office_poc: 'FTC contracting'
        }, {
          code: 1233, 
          poc: 'Gloria Walker, Program Manager, Gloria.Walker@microhealthllc.com, (301) 213–9060', 
          name: 'John',
          gpoc: 'Michael  Holmes, 571-303-9150', 
          office_poc: 'FTC contracting'        
        }, {
        
          code: 123, 
          poc: 'Mark Gordy, Program Manager, mark.gordy@hq.doe.gov, 410-482-0060', 
          name: 'Tom',
          gpoc: 'Michael  Holmes, 571-303-9150', 
          office_poc: 'FTC contracting'
        }, {
          code: 123, 
          poc: 'Gloria Walker, Program Manager, Gloria.Walker@microhealthllc.com, (301) 213–9060', 
          name: 'John',
          gpoc: 'Michael  Holmes, 571-303-9150', 
          office_poc: 'FTC contracting'        
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
    th {
      color: #383838;
    }
  }    
</style>