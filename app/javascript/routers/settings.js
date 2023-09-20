import { defineAsyncComponent, markRaw } from 'vue'
import { createRouter, createWebHistory } from "vue-router";
import ServerError from '@views/settings/index/errors/ServerError.vue';
import Loader from '@mints-components/loaders/PageLoader.vue';

const routes = [{
  path: "/settings/dashboard",
  name: "Dashboard",
  component: markRaw(defineAsyncComponent({
    loader: () =>
    import ('@views/settings/index/dashboard/App.vue'),
    loadingComponent: Loader /* shows while loading */ ,
    errorComponent: ServerError /* shows if there's an error */ ,
    delay: 10 /* delay in ms before showing loading component */ ,
    timeout: 30000 /* timeout after this many ms */ ,
  })),
  permission: 'all'
},
  {
    path: "/settings/contactos",
    name: "Contacts",
    component: markRaw(defineAsyncComponent({
      loader: () =>
      import ('@views/settings/index/contacts/App.vue'),
      loadingComponent: Loader /* shows while loading */ ,
      errorComponent: ServerError /* shows if there's an error */ ,
      delay: 10 /* delay in ms before showing loading component */ ,
      timeout: 30000 /* timeout after this many ms */ ,
    })),
    permission: 'all'
  },
  {
    path: '/:pathMatch(.*)',
    name: "NotFound",
    redirect: "/settings/dashboard",
    permission: 'all'
  }
];

export function generateRouter(permissions) {
  let routesFiltered = null
  if ((permissions || []).length === 0) {
    routesFiltered = [{
      path: '/settings/unauthorized',
      name: "Unauthorized",
      component: import ('../views/settings/index/errors/Unauthorized.vue'),
      permission: 'all'
    }, {
      path: '/:pathMatch(.*)',
      name: "NotFound",
      redirect: "/settings/unauthorized",
      permission: 'all'
    }];
  } else {
    routesFiltered = routes.filter(r => permissions.includes(r.permission) || r.permission === 'all');
    
    routesFiltered.unshift({
      path: "/settings",
      name: "/settings",
      redirect: routesFiltered[0].path,
    });
  }
  
  return createRouter({
    history: createWebHistory(),
    routes: routesFiltered,
    linkActiveClass: "active",
  });
}