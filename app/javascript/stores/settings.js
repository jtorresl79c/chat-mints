import { createStore } from "vuex";

export default createStore({
  state: {
    isPinned: true,
    showConfig: false,
    color: "",
    objects: {},
    meta: {},
    status: {
      get: { isBusy: false, error: null },
      search: { isBusy: false, error: null },
    },
    canDownload: {},
    me: null
  },
  mutations: {
    resetObjects(state) {
      state.objects = {};
      state.meta = {};
    },
    setObjects(state, { key, value }) {
      state.objects[key] = value
    },
    setMeta(state, { key, value }) {
      state.meta[key] = value
    },
    setMyInformation(state, payload){
      state.me = payload
      
      if (payload?.ui_configuration) {
        state.color = payload.ui_configuration.sidebar_colors;
        
        if (payload.ui_configuration.sidenav_mini) {
          navbarMinimize(state)
        }
      }
    },
    setDownloadStatus(state, { key, value }){
      state.canDownload[key] = value
    },
    updateStatus(state, { key, value }){
      state.status[key].isBusy = value
    },
    toggleConfigurator(state) {
      state.showConfig = !state.showConfig;
    },
    navbarMinimize(state) {
      const sidenav_show = document.querySelector(".g-sidenav-show");
      if (sidenav_show.classList.contains("g-sidenav-hidden")) {
        sidenav_show.classList.remove("g-sidenav-hidden");
        sidenav_show.classList.add("g-sidenav-pinned");
        state.isPinned = true;
      } else {
        sidenav_show.classList.add("g-sidenav-hidden");
        sidenav_show.classList.remove("g-sidenav-pinned");
        state.isPinned = false;
      }
    },
    cardBackground(state, payload) {
      state.color = payload;
    },
    setWhatever(state, { key, value }){
      state[key] = value
    }
  },
  actions: {
    setCardBackground({ commit }, payload) {
      commit("cardBackground", payload);
    }
  },
  getters: {
    getIsLoading: (state) => state.status?.get?.isBusy,
  }
});
