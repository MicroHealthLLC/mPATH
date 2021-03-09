// Reference URL: https://docs.vuestorefront.io/v1/guide/vuex/vuex-conventions.html

// The Vuex module should be created for a specific set of functionalities. It should also
// have only absolutely necessary dependencies to other modules. The name of module should
// be short, quite clear about it’s destination, and have words separated by a dash (this
// module is named example-module-store.js, for example).
const exampleModule = {
  // State property names are written in underscore-case notation and indicate what they
  //contain.
  state: () => ({
    example_value: "I am an example value.",
  }),
  // Every state change from outside of a module should be invoked as an action.
  // Actions within a module can commit mutations from the main store (index.js).
  // Actions are Asynchronous.
  actions: {
    setExampleValue({ commit }, newValue) {
      commit("SET_EXAMPLE_VALUE", newValue);
    },
  },
  // Only mutations can change the state of the module. They should be synchronous (never
  // return promise), not contain any logic (be extremely fast), except one needed to keep
  // the state as it should be (for example, sets default value for state). Mutations should 
  // be invoked only by actions from the same module.
  mutations: {
    // Mutations should be written in all caps and underscore-case notation.
    // Examples: ADD_TASK, REMOVE_RISK, SET_ISSUE.
    SET_EXAMPLE_VALUE: (state, value) => (state.example_value = value),
  },
  // The Vuex state, except of mutations, should always be accessed by getters.
  getters: {
    getExampleValue: (state) => state.example_value,
  },
};

export default exampleModule;
