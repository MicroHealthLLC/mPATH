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
      label="Name"
      width="175"
      prop="name">
    </el-table-column>
    <el-table-column
      label="Vehicle Full Name"
      width="250"
      prop="type">
    </el-table-column>
      <el-table-column
      label="SINS or Subcategories"
      width="250"
      prop="type">
    </el-table-column>
     <el-table-column
      label="Contracting Agency"
      width="175"
      prop="name">
    </el-table-column>
  <el-table-column
      label="Vehicle Type"
      width="175"
      prop="name">
    </el-table-column>
     <el-table-column
      label="Contract Number"
      width="175"
      prop="startdate">
    </el-table-column>
     <el-table-column
      label="Ceiling"
      width="175"
      prop="startdate">
    </el-table-column>

    <el-table-column
      label="Base Period Start"
       width="165"
      prop="startdate">
    </el-table-column>
       <el-table-column
     label="Base Period End"
       width="160"
      prop="startdate">
    </el-table-column>
     <el-table-column
      label="Option Period Start"
       width="165"
      prop="startdate">
    </el-table-column>
       <el-table-column
     label="Option Period End"
       width="160"
      prop="startdate">
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
  name: "PortfolioVehicles",
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
          name: 'Tom',
          address: 'No. 189, Grove St, Los Angeles'
        }, {
          code: 123, 
          type: 'FFP', 
          startdate: '2016-05-02',
          value: "$7,343,342.45",
          name: 'John',
          primesub: "Prime",
          address: 'No. 189, Grove St, Los Angeles'
        }, {
          code: 123, 
          startdate: '2016-05-04',
          type: 'T&M', 
          primesub: "Sub",
          value: "$5,643.45",
          name: 'Morgan',
          address: 'No. 189, Grove St, Los Angeles'
        }, {
          code: 123, 
          startdate: '2016-05-01',
          name: 'Jessy',
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
          type: 'T&M', 
          address: 'No. 189, Grove St, Los Angeles'
        }, {
           code: 123, 
           startdate:'2016-05-02',
          name: 'John',
          primesub: "Sub",
           value: "$7,343,342.45",
          type: 'T&M', 
          address: 'No. 189, Grove St, Los Angeles'
        }, {
          code: 123, 
          type: 'FFP', 
          startdate: '2016-05-02',
          value: "$7,343,342.45",
          name: 'John',
          primesub: "Prime",
          address: 'No. 189, Grove St, Los Angeles'
        }, {
          code: 123, 
          startdate: '2016-05-04',
          type: 'T&M', 
          primesub: "Sub",
          value: "$5,643.45",
          name: 'Morgan',
          address: 'No. 189, Grove St, Los Angeles'
        }, {
          code: 123, 
          startdate: '2016-05-01',
          name: 'Jessy',
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
          type: 'T&M', 
          address: 'No. 189, Grove St, Los Angeles'
        }, {
           code: 123, 
           startdate:'2016-05-02',
          name: 'John',
          primesub: "Sub",
           value: "$7,343,342.45",
          type: 'T&M', 
          address: 'No. 189, Grove St, Los Angeles'
        }, {
           code: 123, 
          startdate: '2016-05-04',
          name: 'Morgan',
          value: "$7,343,342.45",
          primesub: "Prime",
          address: 'No. 189, Grove St, Los Angeles'
        }, {
          code: 123, 
          startdate: '2016-05-01',
          name: 'Jessy',
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
          type: 'T&M', 
          address: 'No. 189, Grove St, Los Angeles'
        }, {
           code: 123, 
           startdate:'2016-05-02',
          name: 'John',
          primesub: "Sub",
           value: "$7,343,342.45",
          type: 'T&M', 
          address: 'No. 189, Grove St, Los Angeles'
        }, {
           code: 123, 
          startdate: '2016-05-04',
          name: 'Morgan',
          value: "$7,343,342.45",
          primesub: "Prime",
          address: 'No. 189, Grove St, Los Angeles'
        }, {
          code: 123, 
          startdate: '2016-05-01',
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
    th {
      color: #383838;
    }
  }    
</style>