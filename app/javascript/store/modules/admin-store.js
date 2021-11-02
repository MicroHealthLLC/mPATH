const adminStore = {
  state: () => ({
    show_admin_btn: false,
    contract_table: [],
    group_filter: null,

  
  }),
  actions: {},
  mutations: {
    setShowAdminBtn: (state, value) => state.show_admin_btn = value,
    setContractTable: (state, value) => state.contract_table = value,
    setGroupFilter: (state, value) => state.group_filter = value,
  },

  getters: {
    getShowAdminBtn: state => state.show_admin_btn, 
    getContractTable: state => state.contract_table, 
    getGroupFilter: state => state.group_filter, 
  },
};

export default adminStore;
