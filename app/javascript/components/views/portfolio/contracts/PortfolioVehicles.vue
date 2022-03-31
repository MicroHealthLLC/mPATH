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
      prop="fullname">
    </el-table-column>
      <el-table-column
      label="SINS or Subcategories"      
      width="200"
      prop="sins">
    </el-table-column>
     <el-table-column
      label="Contracting Agency"
      width="175"
      prop="name">
    </el-table-column>
  <el-table-column
      label="Vehicle Type"
      width="125"
      prop="name">
    </el-table-column>
     <el-table-column
      label="Contract Number"
      width="125"
      prop="startdate">
    </el-table-column>
     <el-table-column
      label="Ceiling"
      width="125"
      prop="ceiling">
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
          fullname: "Center for Medicare and Medicaid Services (CMS) Strategic Partners Acquisition Readiness Contract (SPARC)",
          primesub: "Sub",
          sins: "8(a), SDVOSB, SB",
          startdate: '2016-05-03',
          name: 'Tom',
          ceiling: '$25,000,000,000.00',
          address: 'No. 189, Grove St, Los Angeles'
        }, {
          code: 123, 
          type: 'FFP', 
          startdate: '2016-05-02',
          value: "$7,343,342.45",
          sins:"SIN 132-51 - Information Technology Professional Services and 132-56 (Health IT SIN) ",
          name: 'John',
          primesub: "Prime",
            ceiling: '$25,000,000,000.00',
          address: 'No. 189, Grove St, Los Angeles'
        }, {
          code: 123, 
          startdate: '2016-05-04',
          type: 'T&M', 
          primesub: "Sub",
            fullname: "Center for Medicare and Medicaid Services (CMS) Strategic Partners Acquisition Readiness Contract (SPARC)",
          sins:"SIN 132-51 - Information Technology Professional Services and 132-56 (Health IT SIN) ",
          value: "$5,643.45",
          name: 'Morgan',
            ceiling: '$25,000,000,000.00',
          address: 'No. 189, Grove St, Los Angeles'
        }, {
          code: 123, 
          startdate: '2016-05-01',
          name: 'Jessy',
          type: 'T&M', 
          value: "$17,343,342.45",
          primesub: "Prime",
            ceiling: '$25,000,000,000.00',
          address: 'No. 189, Grove St, Los Angeles'
        }, {
          code: 123, 
          startdate: '2016-05-03',
          name: 'Tom',
          value: "$6,343,342.45",
            fullname: "Center for Medicare and Medicaid Services (CMS) Strategic Partners Acquisition Readiness Contract (SPARC)",
          sins:"SIN 132-51 - Information Technology Professional Services and 132-56 (Health IT SIN) ",
          primesub: "Prime",
          type: 'T&M', 
            ceiling: '$25,000,000,000.00',
          address: 'No. 189, Grove St, Los Angeles'
        }, {
           code: 123, 
           startdate:'2016-05-02',
          name: 'John',
          primesub: "Sub",
          sins: "8(a), SDVOSB, SB",
          value: "$7,343,342.45",
          type: 'T&M', 
            ceiling: '$25,000,000,000.00',
          address: 'No. 189, Grove St, Los Angeles'
        }, {
          code: 123, 
          type: 'FFP', 
          startdate: '2016-05-02',
          value: "$7,343,342.45",
          name: 'John',
          primesub: "Prime",
          sins: "8(a), SDVOSB, SB",
          ceiling: '$25,000,000,000.00',
          address: 'No. 189, Grove St, Los Angeles'
        }, {
          code: 123, 
          startdate: '2016-05-04',
          type: 'T&M', 
          primesub: "Sub",
          sins: "8(a), SDVOSB, SB",
          fullname: "Center for Medicare and Medicaid Services (CMS) Strategic Partners Acquisition Readiness Contract (SPARC)",
          value: "$5,643.45",
          name: 'Morgan',
            ceiling: '$25,000,000,000.00',
          address: 'No. 189, Grove St, Los Angeles'
        }, {
          code: 123, 
          startdate: '2016-05-01',
          name: 'Jessy',
          type: 'T&M', 
          value: "$17,343,342.45",
          primesub: "Prime",
          sins: "8(a), SDVOSB, SB",
          ceiling: '$25,000,000,000.00',
          address: 'No. 189, Grove St, Los Angeles'
        }, {
          code: 123, 
          startdate: '2016-05-03',
          name: 'Tom',
          value: "$6,343,342.45",
          primesub: "Prime",
          sins: "8(a), SDVOSB, SB",
          type: 'T&M', 
          ceiling: '$25,000,000,000.00',
          address: 'No. 189, Grove St, Los Angeles'
        }, {
           code: 123, 
           startdate:'2016-05-02',
          name: 'John',
          primesub: "Sub",
          value: "$7,343,342.45",
          fullname: "Center for Medicare and Medicaid Services (CMS) Strategic Partners Acquisition Readiness Contract (SPARC)",
          sins: "8(a), SDVOSB, SB",
          type: 'T&M', 
          address: 'No. 189, Grove St, Los Angeles'
        }, {
           code: 123, 
          startdate: '2016-05-04',
          name: 'Morgan',
          value: "$7,343,342.45",
          primesub: "Prime",
          sins: "8(a), SDVOSB, SB",
          address: 'No. 189, Grove St, Los Angeles'
        }, {
          code: 123, 
          startdate: '2016-05-01',
          name: 'Jessy',
          type: 'T&M', 
          value: "$17,343,342.45",
          primesub: "Prime",
          sins: "8(a), SDVOSB, SB",
          address: 'No. 189, Grove St, Los Angeles'
        }, {
          code: 123, 
          startdate: '2016-05-03',
          name: 'Tom',
          value: "$6,343,342.45",
          primesub: "Prime",
          type: 'T&M', 
          sins: "8(a), SDVOSB, SB",
          address: 'No. 189, Grove St, Los Angeles'
        }, {
           code: 123, 
           startdate:'2016-05-02',
          name: 'John',
          primesub: "Sub",
          value: "$7,343,342.45",
          type: 'T&M', 
          sins: "8(a), SDVOSB, SB",
          address: 'No. 189, Grove St, Los Angeles'
        }, {
           code: 123, 
          startdate: '2016-05-04',
          name: 'Morgan',
          value: "$7,343,342.45",
          primesub: "Prime",
          sins: "8(a), SDVOSB, SB",
          address: 'No. 189, Grove St, Los Angeles'
        }, {
          code: 123, 
          startdate: '2016-05-01',
          name: 'Jessy',
          value: "$7,343,342.45",
          primesub: "Sub",
          sins: "8(a), SDVOSB, SB",
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