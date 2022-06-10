<template>
 <el-switch
  class="mt-3"
  style="display: block"
  v-model="projectContractToggle"
  active-color="#DD9036"
  inactive-color="#9EC64C"               
  inactive-text="PROJECTS"
  active-text="CONTRACTS"
  >
 </el-switch>
</template>

<script>
import { mapGetters, mapMutations } from 'vuex'
export default {
  name: "ProjectContractSwitch",
  methods:{
 ...mapMutations([
    'setShowProjectStats',
    ]),  
  },
  computed: {
    ...mapGetters([
    'getShowProjectStats',
    ]),  
       projectContractToggle:{     
     get(){
       return this.getShowProjectStats
     },
     set(){
       if(this.getShowProjectStats == false){
        this.setShowProjectStats(!this.getShowProjectStats)
      } else if(this.getShowProjectStats == true){
        this.setShowProjectStats(!this.getShowProjectStats)
     } else return
     }
    },   
  },
};
</script>
