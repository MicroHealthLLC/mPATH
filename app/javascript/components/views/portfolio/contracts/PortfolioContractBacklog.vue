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
      label="Name"
      width="175"
      prop="name">
    </el-table-column>
   
     <el-table-column
      label="Contract Start Date"
       width="165"
      prop="startdate">
    </el-table-column>
       <el-table-column
     label="Contract End Date"
       width="160"
      prop="startdate">
    </el-table-column>
     <el-table-column
      label="Total Contract Value"
       width="200"
      prop="value">
    </el-table-column>
     <el-table-column
      label="Total Funded Value"
       width="200"
      prop="value">
    </el-table-column>
     <el-table-column
      label="Billings to Date"
       width="200"
      prop="value">
    </el-table-column>
     <el-table-column
      label="% Completed"
      width="125"
      prop="percent">
    </el-table-column>
         <el-table-column
      label="Funded Remaining"
       width="200"
      prop="value">
    </el-table-column>
      <el-table-column
      label="Total Backlog (Sum of A & B)"
       width="200"
      prop="value">
    </el-table-column>
       <el-table-column
      label="Notes/Questions"
       width="350"
      prop="">
    </el-table-column>
    <el-table-column
     label="Actions"
      width="75"
      fixed="right"
      align="right">
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
  name: "PortfolioContractBacklog",
  components: {
  
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
          startdate: '2016-05-03',
          percent: '12%',
          name: 'Tom',
          address: 'No. 189, Grove St, Los Angeles'
        }, {
          code: 123, 
          type: 'FFP', 
          startdate: '2016-05-02',
          value: "$7,343,342.45",
            percent: '12%',
          name: 'John',
          primesub: "Prime",
          address: 'No. 189, Grove St, Los Angeles'
        }, {
          code: 123, 
          startdate: '2016-05-04',
          type: 'T&M', 
          primesub: "Sub",
          percent: '42%',
          value: "$5,643.45",
          name: 'Morgan',
          address: 'No. 189, Grove St, Los Angeles'
        }, {
          code: 123, 
          startdate: '2016-05-01',
          name: 'Jessy',
          percent: '67%',
          type: 'T&M', 
          value: "$17,343,342.45",
          primesub: "Prime",
          address: 'No. 189, Grove St, Los Angeles'
        }, {
          code: 123, 
          startdate: '2016-05-03',
          name: 'Tom',
          value: "$6,343,342.45",
          percent: '42%',
          primesub: "Prime",
          type: 'T&M', 
          address: 'No. 189, Grove St, Los Angeles'
        }, {
           code: 123, 
           startdate:'2016-05-02',
          name: 'John',
          primesub: "Sub",
          value: "$7,343,342.45",
          percent: '42%',
          type: 'T&M', 
          address: 'No. 189, Grove St, Los Angeles'
        }, {
          code: 123, 
          type: 'FFP', 
          startdate: '2016-05-02',
          value: "$7,343,342.45",
          percent: '48%',
          name: 'John',
          primesub: "Prime",
          address: 'No. 189, Grove St, Los Angeles'
        }, {
          code: 123, 
          startdate: '2016-05-04',
          type: 'T&M', 
          primesub: "Sub",
          value: "$5,643.45",
          percent: '4%',
          name: 'Morgan',
          address: 'No. 189, Grove St, Los Angeles'
        }, {
          code: 123, 
          startdate: '2016-05-01',
          name: 'Jessy',
          type: 'T&M', 
          value: "$17,343,342.45",
          percent: '98%',
          primesub: "Prime",
          address: 'No. 189, Grove St, Los Angeles'
        }, {
          code: 123, 
          startdate: '2016-05-03',
          name: 'Tom',
          value: "$6,343,342.45",
          percent: '74%',
          primesub: "Prime",
          type: 'T&M', 
          address: 'No. 189, Grove St, Los Angeles'
        }, {
           code: 123, 
           startdate:'2016-05-02',
          name: 'John',
          primesub: "Sub",
          value: "$7,343,342.45",
          percent: '23%',
          type: 'T&M', 
          address: 'No. 189, Grove St, Los Angeles'
        }, {
           code: 123, 
          startdate: '2016-05-04',
          name: 'Morgan',
          value: "$7,343,342.45",
          percent: '45%',
          primesub: "Prime",
          address: 'No. 189, Grove St, Los Angeles'
        }, {
          code: 123, 
          startdate: '2016-05-01',
          name: 'Jessy',
          type: 'T&M', 
          value: "$17,343,342.45",
          percent: '45%',
          primesub: "Prime",
          address: 'No. 189, Grove St, Los Angeles'
        }, {
          code: 123, 
          startdate: '2016-05-03',
          name: 'Tom',
          value: "$6,343,342.45",
          percent: '45%',
          primesub: "Prime",
          type: 'T&M', 
          address: 'No. 189, Grove St, Los Angeles'
        }, {
           code: 123, 
           startdate:'2016-05-02',
          name: 'John',
          primesub: "Sub",
           value: "$7,343,342.45",
           percent: '45%',
          type: 'T&M', 
          address: 'No. 189, Grove St, Los Angeles'
        }, {
           code: 123, 
          startdate: '2016-05-04',
          name: 'Morgan',
          value: "$7,343,342.45",
          percent: '45%',
          primesub: "Prime",
          address: 'No. 189, Grove St, Los Angeles'
        }, {
          code: 123, 
          startdate: '2016-05-01',
          name: 'Jessy',
          value: "$7,343,342.45",
          percent: '45%',
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
    th {
      color: #383838;
    }
  }    
</style>