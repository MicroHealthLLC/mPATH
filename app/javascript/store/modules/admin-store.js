const adminStore = {
  state: () => ({
    show_admin_btn: false,
  
  }),
  actions: {},
  mutations: {
    setShowAdminBtn: (state, value) => state.show_admin_btn = value,
  },

  getters: {
    getShowAdminBtn: state => state.show_admin_btn, 
    
  },
};

export default adminStore;
