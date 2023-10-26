import axios from "axios";
import {API_BASE_PATH} from './../../mixins/utils'

const notesStore = {
  state: () => ({
    contract_note: {}, 
    contract_notes: [], 
    contract_note_loaded: true,
    contract_notes_loaded: true,
    contract_note_status: 0,
    contract_lesson_status: 0,
    contract_vehicle_note: {}, 
    contract_vehicle_notes: [], 
    contract_vehicle_note_loaded: true,
    contract_vehicle_notes_loaded: true,
    contract_vehicle_note_status: 0,
    contract_vehicle_lesson_status: 0,
  }),
  actions: {
    fetchContractNotes({ commit }, { contractId }) {
      commit("TOGGLE_NOTES_LOADED", false);
      // Send GET request for all lessons contained within a project
      axios({
        method: "GET",
        url: `${API_BASE_PATH}/project_contracts/${contractId}/notes.json`,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          // Mutate state with response from back end
          
          commit("SET_CONTRACT_NOTES", res.data.notes);
        })
        .catch((err) => {
          console.log("Error",err);
        })
        .finally(() => {
          commit("TOGGLE_NOTES_LOADED", true);
        });
    },
    fetchContractNote({ commit }, { id, contractId}) {
      commit("TOGGLE_NOTES_LOADED", false);
      // Retrieve lesson by id
      axios({
        method: "GET",
        url: `${API_BASE_PATH}/project_contracts/${contractId}/notes/${id}.json`,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
           commit("SET_CONTRACT_NOTE", res.data.notes);
           })
        .catch((err) => {
          console.log("Error",err);
        })
        .finally(() => {
          commit("TOGGLE_NOTES_LOADED", true);
        });
    },
    addContractNote({ commit }, { note, contractId }) {
 // Displays loader on front end
    commit("TOGGLE_NOTES_LOADED", false);
  // Utilize utility function to prep Lesson form data
    let formData = noteFormData(note);

    axios({
        method: "POST",
        url: `${API_BASE_PATH}/project_contracts/${contractId}/notes.json`,
        data: formData,
        headers: {
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
    })
        .then((res) => {
          // console.log(res.data)
        commit("SET_CONTRACT_NOTE", res.data);
        commit("SET_CONTRACT_NOTE_STATUS", res.status);
        
        })
        .catch((err) => {
        console.log("Error",err);
        })
        .finally(() => {
        commit("TOGGLE_NOTES_LOADED", true);
        });
},
    updateContractNote({ commit }, { note, contractId, noteId }) {
      // Displays loader on front end
      commit("TOGGLE_NOTES_LOADED", false);
      // Utilize utility function to prep Lesson form data
      let formData = noteFormData(note);

      axios({
        method: "PATCH",
        url: `${API_BASE_PATH}/project_contracts/${contractId}/notes/${noteId}`,
        data: formData,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          commit("SET_CONTRACT_NOTE", res.data.notes);
          commit("SET_CONTRACT_NOTE_STATUS", res.status);
        })
        .catch((err) => {
          console.log("Error",err);
        })
        .finally(() => {
          commit("TOGGLE_NOTES_LOADED", true);
        });
    },
    deleteContractNote({ commit }, { id, contractId }) {
      // Delete a single lesson
      axios({
        method: "DELETE",
        url: `${API_BASE_PATH}/project_contracts/${contractId}/notes/${id}`,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          commit("DELETE_CONTRACT_NOTE", id);
        })
        .catch((err) => {
          console.log("Error",err);
        })
        .finally(() => {});
    },
// Vehicles
    fetchVehicleNotes({ commit }, { vehicleId }) {
      commit("TOGGLE_NOTES_LOADED", false);
      // Send GET request for all lessons contained within a project
      axios({
        method: "GET",
        url: `${API_BASE_PATH}/project_contract_vehicles/${vehicleId}/notes.json`,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          // Mutate state with response from back end
          
          commit("SET_VEHICLE_NOTES", res.data.notes);
        })
        .catch((err) => {
          console.log("Error",err);
        })
        .finally(() => {
          commit("TOGGLE_NOTES_LOADED", true);
        });
    },
    fetchVehicleNote({ commit }, { id, vehicleId}) {
      commit("TOGGLE_NOTES_LOADED", false);
      // Retrieve lesson by id
      axios({
        method: "GET",
        url: `${API_BASE_PATH}/project_contract_vehicles/${vehicleId}/notes/${id}.json`,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
           commit("SET_VEHICLE_NOTE", res.data.notes);
           })
        .catch((err) => {
          console.log("Error",err);
        })
        .finally(() => {
          commit("TOGGLE_NOTES_LOADED", true);
        });
    },
    addVehicleNote({ commit }, { note, vehicleId }) {
 // Displays loader on front end
    commit("TOGGLE_NOTES_LOADED", false);
  // Utilize utility function to prep Lesson form data
    let formData = noteFormData(note);

    axios({
        method: "POST",
        url: `${API_BASE_PATH}/project_contract_vehicles/${vehicleId}/notes.json`,
        data: formData,
        headers: {
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
    })
        .then((res) => {
          // console.log(res.data)
        commit("SET_VEHICLE_NOTE", res.data);
        commit("SET_VEHICLE_NOTE_STATUS", res.status);
        
        })
        .catch((err) => {
        console.log("Error",err);
        })
        .finally(() => {
        commit("TOGGLE_NOTES_LOADED", true);
        });
},
    updateVehicleNote({ commit }, { note, vehicleId, noteId }) {
      // Displays loader on front end
      commit("TOGGLE_NOTES_LOADED", false);
      // Utilize utility function to prep Lesson form data
      let formData = noteFormData(note);

      axios({
        method: "PATCH",
        url: `${API_BASE_PATH}/project_contract_vehicles/${vehicleId}/notes/${noteId}`,
        data: formData,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          commit("SET_VEHICLE_NOTE", res.data.notes);
          commit("SET_VEHICLE_NOTE_STATUS", res.status);
        })
        .catch((err) => {
          console.log("Error",err);
        })
        .finally(() => {
          commit("TOGGLE_NOTES_LOADED", true);
        });
    },
    deleteVehicleNote({ commit }, { id, vehicleId }) {
      // Delete a single lesson
      axios({
        method: "DELETE",
        url: `${API_BASE_PATH}/project_contract_vehicles/${vehicleId}/notes/${id}`,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          commit("DELETE_VEHICLE_NOTE", id);
        })
        .catch((err) => {
          console.log("Error",err);
        })
        .finally(() => {});
    },
  },
  mutations: {
    SET_CONTRACT_NOTES: (state, notes) => (state.contract_notes = notes),
    SET_CONTRACT_NOTE: (state, note) => (state.contract_note = note),

    DELETE_CONTRACT_NOTE: (state, id) => {
      // Find index of note to delete
      let index = state.contract_notes.findIndex((note) => note.id == id);
      // Remove note from array
      state.contract_notes.splice(index, 1);
    },
    TOGGLE_NOTES_LOADED: (state, loaded) => (state.notes_loaded = loaded),
    SET_CONTRACT_NOTE_STATUS: (state, status) => (state.contract_note_status = status),
    SET_VEHICLE_NOTES: (state, notes) => (state.contract_vehicle_notes = notes),
    SET_VEHICLE_NOTE: (state, note) => (state.contract_vehicle_note = note),

    DELETE_VEHICLE_NOTE: (state, id) => {
      // Find index of note to delete
      let index = state.contract_vehicle_notes.findIndex((note) => note.id == id);
      // Remove note from array
      state.contract_vehicle_notes.splice(index, 1);
    },
    SET_VEHICLE_NOTE_STATUS: (state, status) => (state.contract_vehicle_note_status = status),
  },
  getters: {
    contractNote: (state) => state.contract_note,
    contractNotes: (state) => state.contract_notes,
    contractNotesLoaded: (state) => state.contract_notes_loaded,
    contractNoteStatus: (state) => state.contract_note_status,
    vehicleNote: (state) => state.contract_vehicle_note,
    vehicleNotes: (state) => state.contract_vehicle_notes,
    vehicleNotesLoaded: (state) => state.contract_vehicle_notes_loaded,
    vehicleNoteStatus: (state) => state.contract_vehicle_note_status,  
  },
};
// Utility function to prepare form data from lesson object that is passed from LessonForm.vue
const noteFormData = (note) => {
  // console.log(note)
  let formData = new FormData();
// REPLACE WITH NOTES formData.append info
// formData.append('contract_id', note.contractId)
  formData.append('note[body]', note.body)
  // Prep Files
  note.attach_files.forEach((file) => {
    formData.append("note[note_files][]", file);
  });
 // Prep File Ids to be destroyed
  note.destroy_file_ids.forEach((id) => {
    formData.append("note[destroy_file_ids][]", id);
  });

// formData.append('note[destroy_file_ids]', _.map(this.destroyedFiles, 'id'))
 
  return formData;
};

export default notesStore;
