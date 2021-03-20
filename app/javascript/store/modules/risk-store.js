const riskStore = {
    state: () => ({
      risk_form_open: false,
      selected_risk: {}
    }),
    actions: {},
    mutations: {
      SET_RISK_FORM_OPEN: (state) => state.risk_form_open = !state.risk_form_open,
      SET_SELECTED_RISK: (state, risk) => state.selected_risk = risk
    },
    getters: {
      getRiskFormOpen: (state) => state.risk_form_open,
      getSelectedRisk: (state) => state.selected_risk
    },
  };
  
  export default riskStore;
  