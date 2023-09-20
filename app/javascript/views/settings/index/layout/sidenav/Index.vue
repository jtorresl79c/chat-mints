<template>
  <aside
      id="sidenav-main"
      class="border-0 sidenav navbar navbar-vertical navbar-expand-xs border-radius-xl fixed-start"
  >
    <div class="collapse-arrow" :class="{'text-center': !isPinned}">
      <i class="fas"
         @click="navbarMinimize"
         :class="{
           'fa-angle-right': !isPinned,
           'fa-angle-left': isPinned
         }"></i>
    </div>

    <div
        id="sidenav-collapse-main"
        class="w-auto h-auto collapse navbar-collapse max-height-vh-100 h-100"
    >
      <ul class="navbar-nav">

        <li class="nav-item" v-for="(item, index) in items" :key="index">
          <router-link class="nav-link" :class="{'override__nav-link': !isPinned}" :to="{ name: item.name || item.title }">
            <span class="sidenav-mini-icon">
              <component :is="item.icon" class="" v-if="item.icon"/>
            </span>
            <span class="sidenav-normal"> {{ item.title }} </span>
          </router-link>
        </li>

      </ul>
    </div>
  </aside>
</template>
<script>
import SidenavItem from "./SidenavItem.vue";
import SidenavCard from "./SidenavCard.vue";
// Icons
import Presentation from "@icons/Presentation.vue";
import Contact from "@icons/Contact.vue";

import { mapMutations, mapState} from "vuex";
import {markRaw} from "vue";

export default {
  name: "SidenavList",
  components: {
    SidenavItem,
    SidenavCard,
    Presentation,
    Contact,
  },
  data: () => ({
    pages: [{
      title: 'Dashboard',
      slug: 'dashboard',
      icon: markRaw(Presentation),
      ignorePermissions: true
    }, {
      title: 'Contacts',
      slug: 'contacts',
      icon: markRaw(Contact),
      ignorePermissions: true
    }]
  }),
  computed: {
    ...mapState(["isPinned", "me"]),
    items() {
      return this.pages.filter(p => this.me?.permissions?.includes(p.slug) || p.ignorePermissions) || []
    }
  },
  methods: {
    ...mapMutations(['navbarMinimize'])
  }
};
</script>

<style lang="scss" scoped>
.collapse-arrow {
  text-align: right;
  padding-top: 0.1rem;
  padding-bottom: 0.675rem;
  margin: 0 1rem;

  i {
    cursor: pointer;
  }
}

.active {
  background-color: #fff !important;
  color: #000 !important;

  .sidenav-mini-icon {
    background-color: #0395D1;
    color: #fff;
  }
}

.sidenav-mini-icon {
  font-weight: 600;
  box-shadow: 0 20px 27px 0 rgb(0 0 0 / 5%);
  border-radius: 0.5rem;
  background-color: #fff;
  color: #000;
  padding: 0.25rem;
  margin: 0.25rem;
}

.sidenav-normal {
  margin-left: 10px;
}

.override__nav-link {
  background-color: transparent !important;
  box-shadow: none !important;
}
</style>