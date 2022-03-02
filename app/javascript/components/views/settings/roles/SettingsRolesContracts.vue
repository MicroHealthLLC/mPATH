<template>
<div>
  <el-table      
      :data="tableData"   
      height="450"
      >
  <el-table-column
    fixed
    prop="role"
    label="Contracts Role"
    width="250">
  </el-table-column>
  <el-table-column label="Analytics">
    <el-table-column
      prop="read"
      label="Read"
      width="75">

    <template slot-scope="scope">
      <span 
      v-if="scope.row.read">
      <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       
      </span>
      <span 
      v-show="!scope.row.read">
      <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
      </span>       
      </template>
    </el-table-column>
      <el-table-column
      prop="write"
      label="Write"
      width="75">
      <template slot-scope="scope">
      <span 
      v-if="scope.row.write">
      <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       
      </span>
      <span 
      v-show="!scope.row.write">
      <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
      </span>       
      </template>
    </el-table-column>
    <el-table-column
      prop="delete"
      label="Delete"
      width="75">
      <template slot-scope="scope">
      <span 
      v-if="scope.row.delete">
      <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       
      </span>
      <span 
      v-show="!scope.row.delete">
      <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
      </span>       
      </template>
    </el-table-column>

  </el-table-column>
   <el-table-column label="Tasks">
    <el-table-column
      prop="read"
      label="Read"
      width="75">

    <template slot-scope="scope">
      <span 
      v-if="scope.row.read">
      <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       
      </span>
      <span 
      v-show="!scope.row.read">
      <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
      </span>       
      </template>
    </el-table-column>
      <el-table-column
      prop="write"
      label="Write"
      width="75">
      <template slot-scope="scope">
      <span 
      v-if="scope.row.write">
      <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       
      </span>
      <span 
      v-show="!scope.row.write">
      <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
      </span>       
      </template>
    </el-table-column>
    <el-table-column
      prop="delete"
      label="Delete"
      width="75">
      <template slot-scope="scope">
      <span 
      v-if="scope.row.delete">
      <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       
      </span>
      <span 
      v-show="!scope.row.delete">
      <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
      </span>       
      </template>
    </el-table-column>

  </el-table-column>

     <el-table-column label="Issues">
    <el-table-column
      prop="read"
      label="Read"
      width="75">

    <template slot-scope="scope">
      <span 
      v-if="scope.row.read">
      <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       
      </span>
      <span 
      v-show="!scope.row.read">
      <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
      </span>       
      </template>
    </el-table-column>
      <el-table-column
      prop="write"
      label="Write"
      width="75">
      <template slot-scope="scope">
      <span 
      v-if="scope.row.write">
      <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       
      </span>
      <span 
      v-show="!scope.row.write">
      <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
      </span>       
      </template>
    </el-table-column>
    <el-table-column
      prop="delete"
      label="Delete"
      width="75">
      <template slot-scope="scope">
      <span 
      v-if="scope.row.delete">
      <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       
      </span>
      <span 
      v-show="!scope.row.delete">
      <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
      </span>       
      </template>
    </el-table-column>

  </el-table-column>

     <el-table-column label="Risks">
    <el-table-column
      prop="read"
      label="Read"
      width="75">

    <template slot-scope="scope">
      <span 
      v-if="scope.row.read">
      <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       
      </span>
      <span 
      v-show="!scope.row.read">
      <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
      </span>       
      </template>
    </el-table-column>
      <el-table-column
      prop="write"
      label="Write"
      width="75">
      <template slot-scope="scope">
      <span 
      v-if="scope.row.write">
      <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       
      </span>
      <span 
      v-show="!scope.row.write">
      <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
      </span>       
      </template>
    </el-table-column>
    <el-table-column
      prop="delete"
      label="Delete"
      width="75">
      <template slot-scope="scope">
      <span 
      v-if="scope.row.delete">
      <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       
      </span>
      <span 
      v-show="!scope.row.delete">
      <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
      </span>       
      </template>
    </el-table-column>

  </el-table-column>

     <el-table-column label="Notes">
    <el-table-column
      prop="read"
      label="Read"
      width="75">

    <template slot-scope="scope">
      <span 
      v-if="scope.row.read">
      <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       
      </span>
      <span 
      v-show="!scope.row.read">
      <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
      </span>       
      </template>
    </el-table-column>
      <el-table-column
      prop="write"
      label="Write"
      width="75">
      <template slot-scope="scope">
      <span 
      v-if="scope.row.write">
      <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       
      </span>
      <span 
      v-show="!scope.row.write">
      <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
      </span>       
      </template>
    </el-table-column>
    <el-table-column
      prop="delete"
      label="Delete"
      width="75">
      <template slot-scope="scope">
      <span 
      v-if="scope.row.delete">
      <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       
      </span>
      <span 
      v-show="!scope.row.delete">
      <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
      </span>       
      </template>
    </el-table-column>

  </el-table-column>

     <el-table-column label="Lessons">
    <el-table-column
      prop="read"
      label="Read"
      width="75">

    <template slot-scope="scope">
      <span 
      v-if="scope.row.read">
      <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       
      </span>
      <span 
      v-show="!scope.row.read">
      <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
      </span>       
      </template>
    </el-table-column>
      <el-table-column
      prop="write"
      label="Write"
      width="75">
      <template slot-scope="scope">
      <span 
      v-if="scope.row.write">
      <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       
      </span>
      <span 
      v-show="!scope.row.write">
      <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
      </span>       
      </template>
    </el-table-column>
    <el-table-column
      prop="delete"
      label="Delete"
      width="75">
      <template slot-scope="scope">
      <span 
      v-if="scope.row.delete">
      <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       
      </span>
      <span 
      v-show="!scope.row.delete">
      <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
      </span>       
      </template>
    </el-table-column>

  </el-table-column>

    
  </el-table>
</div>
</template>

<script>
 

import { mapGetters, mapMutations, mapActions } from "vuex";
export default {
  name: "SettingsRolesContracts",
  data() {    
      return {
       tableData: [{
          role: 'contract-read',        
          read: true,
          write: true,
          delete: false,  

          groupsRead: true, 
          groupsWrite: true, 
          groupsDelete: true, 
          
          projectsRead: true, 
          projectsWrite: true, 
          projectsDelete: true, 
          
          contractsRead: true, 
          contractsWrite: true, 
          contractsDelete: true, 

          usersRead: true, 
          usersWrite: true, 
          usersDelete: true, 
        }, {
          role: 'contract-manager',        
          read: false,
          write: true,
          delete: false,  

          groupsRead: true, 
          groupsWrite: true, 
          groupsDelete: true, 
          
          projectsRead: true, 
          projectsWrite: true, 
          projectsDelete: true, 
          
          contractsRead: true, 
          contractsWrite: true, 
          contractsDelete: true, 

          usersRead: false, 
          usersWrite: false, 
          usersDelete: false, 
        },]
      }
  },
  methods: {
    ...mapMutations([
     
    ]),
  ...mapActions([

  ]),
   },
  mounted() {
 
  },
  computed: {
    ...mapGetters([
        "contentLoaded",
        "currentProject",
        "getPortfolioUsers",
        "activeProjectUsers",
        "newUserStatus"
    ]),
     backToSettings() {
      return `/programs/${this.$route.params.programId}/settings`;
    },
    },
  watch: { 
    // newUserStatus: {
    //   handler() {
    //     if (this.newUserStatus == 200) {
    //       this.$message({
    //         message: ` ${this.firstName + this.lastName } successfully added to your program.`,
    //         type: "success",
    //         showClose: true,
    //       });
    //       this.SET_NEW_USER_STATUS(0);
    //       this.lastName = '',
    //       this.firstName = '',
    //       this.email = ''
    //     }
    //   },
    // },
   
  },
};
</script>

<style scoped lang="scss">
.right-panel {
  height: calc(100vh - 100px);
  overflow-y: auto;
}
.buttonWrapper {
  border-bottom: lightgray solid 1px;
}
/deep/.el-dialog__header.users{
  padding: 0;
}
/deep/.el-table th.el-table__cell > .cell {
  color: #383838;
//   font-size: .9rem;
  text-align: center;
}
.modalBtns {
    box-shadow: 0 2.5px 5px rgba(56,56, 56,0.19), 0 3px 3px rgba(56,56,56,0.23);
}
.auto-complete-wrapper {
  justify-content: center;
  align-items: center;
  position: relative;
  input {
    width: 100%;
    border: none;
    height: 38px;
    padding-left: 10px;
    padding-right: -10px;
    box-shadow: inset 0 0 0 1px #b2b2b2;
    border-radius: 4px;
    background: transparent;
    transition: all .2s ease;
    &:focus {
      outline: none;
      box-shadow: inset 0 0 0 2px #DD9036;
    }
  }
  .results {
    position: absolute;
    max-height: 300px;
    overflow-y: auto;
    width: 100%;
    background: #fff;  box-shadow: 0 10px 20px rgba(0,0,0,0.19), 0 6px 6px rgba(0,0,0,0.23);
    .result {     
      padding:  12px 0.75rem;
      &:hover {
        background: #efefef;
      }
    }
  }
}

</style>