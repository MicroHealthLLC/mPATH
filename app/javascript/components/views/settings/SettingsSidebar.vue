<template>
<div class="filterbar">

<div id="filter_bar">
    <h5>
    <ul class="pt-3 program-name">
       <router-link :to="adminGroupsView" > 
        <li class="p-3 entity">
          <i class="fal fa-network-wired mr-2"></i>Groups
        </li>
    </router-link>
    <router-link :to="adminProjectsView" > 
        <li class="p-3 entity">
          <i class="fal fa-clipboard-list mr-3"></i> Projects
        </li>
    </router-link>
    <router-link :to="adminContractsView" > 
       <li class="p-3 entity">
          <i class="far fa-file-contract mr-3"></i>  Contracts
        </li>
    </router-link>
     <!-- <li class="p-3 entity">
         <i class="fad fa-layer-group mr-3"></i> Stages
        </li> -->
      <!-- <li class="p-3 entity">
         <i class="far fa-users mr-2"></i> Users
        </li>
          -->


        <!-- <li>
        
        </li> -->
    </ul>
    </h5>

</div>
 <!-- <router-link  >  -->
      <button class="btn btn-sm btn-light settingsBackBtn"  @click.prevent="backToSheetView" style="cursor: pointer">
       <h6> <i class="far fa-arrow-square-left mr-1"></i> Back To Program</h6>
      </button>  
      <!-- </router-link> -->
</div>
</template>

<script>
import { mapGetters, mapActions, mapMutations } from "vuex";
export default {
  name: 'SettingsSidebar',
  data() {
    return {
      
    }
  },
  mounted() {
   
  },
  computed: {
    ...mapGetters([
        'getShowAdminBtn',
     ]),
   backToSheetView() {
      // this.setShowAdminBtn(!this.getShowAdminBtn);
        this.$router.push(
      `/programs/${this.$route.params.programId}/sheet`
      );
      },
    adminProjectsView() {
     return `/programs/${this.$route.params.programId}/settings/projects`
    },
    adminContractsView() {
     return `/programs/${this.$route.params.programId}/settings/contracts`
    },
    adminGroupsView() {
     return `/programs/${this.$route.params.programId}/settings/groups`
    },
    // filterBarStyle() {
    //   if (this.getShowAdminBtn) return {}
    //   return {
    //     transform: 'translateX(-685px)'
    //   }
    // },
  },
  methods: {
    ...mapMutations([
        'setShowAdminBtn',
        ]),
    toggleAdminFilter() {
      this.setShowAdminBtn(!this.getShowAdminBtn)
    },
    log(e){
        console.log(e);  
    },
  }
}

</script>

<style lang="scss" scoped>
.filterbar {
  position: absolute;
  z-index: 1100;
  width: 90%;
  transition: .4s ease;
//   box-shadow: 0 20px 40px rgba(0, 0, 0, 0.19), 0 24px 24px rgba(0, 0, 0, 0.23);
}
#filter_bar {
  overflow-y: auto;
  border-radius: 4px;
  background-color: #ededed;
  height: calc(100vh - 94px);
  max-height: calc(100vh - 94px);
//   box-shadow: 0 20px 40px rgba(0, 0, 0, 0.19), 0 24px 24px rgba(0, 0, 0, 0.23);
}
ul {

  list-style-type: none; /* Remove bullets */
  li {
  color: #212529 !important; /* default color of text to replace blue default link color */
  } 
}

.entity:hover {
    background-color: rgba(91, 192, 222, 0.3);
    cursor: pointer;
  }

.settingsBackBtn {
  position: absolute;
  bottom: 15px;
  left: 15%;
  z-index: 1140;
}

</style>
