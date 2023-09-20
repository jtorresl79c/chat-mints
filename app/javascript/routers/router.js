import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '@components/HomeView.vue'
import PrincipalView from '@components/PrincipalView.vue'
import LoginView from '@components/LoginView.vue'
import LogoutView from '@components/LogoutView.vue'
import RegisterView from '@components/RegisterView.vue'
import CreateRandomUserView from '@components/CreateRandomUserView.vue'
import QrView from '@components/QrView.vue'
import ChatView from '@components/ChatView.vue'
import PruebaView from '@components/PruebaView.vue'

const router = createRouter({
  history: createWebHistory(),
  routes: [
    {
      path: '/',
      name: 'home',
      component: HomeView,
      redirect: to => {
        // the function receives the target route as the argument
        // we return a redirect path/location here.
        return { path: '/login'}
      }
    },
    // {
    //   path: '/about',
    //   name: 'about',
    //   // route level code-splitting
    //   // this generates a separate chunk (About.[hash].js) for this route
    //   // which is lazy-loaded when the route is visited.
    //   component: () => import('../views/AboutView.vue')
    // },
    {
      path: '/login',
      name: 'login',
      component: LoginView,
      meta: {
        requiresVisitor: true
      }
    },
    {
      path: '/logout',
      name: 'logout',
      component: LogoutView,
      meta: {
        requiresAuth: true
      }
    }
    ,
    {
      path: '/principal',
      name: 'principal',
      component: PrincipalView,
      meta: {
        requiresAuth: true
      }
      
    },
    {
      path: '/register',
      name: 'register',
      component: RegisterView,
      meta: {
        requiresVisitor: true
      }
    },
    {
      path: '/createrandomuser/:type',
      name: 'createrandomuser',
      component: CreateRandomUserView
    },
    {
      path: '/qrview',
      name: 'qrview',
      component: QrView
    },
    {
      path: '/chatview/:type',
      name: 'chatview',
      component: ChatView,
      meta: {
        requiresAuth: true
      }
    },
    {
      path: '/prueba',
      name: 'prueba',
      component: PruebaView
    }
  ]
})

export default router
