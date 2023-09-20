import { resolve, join } from 'path'
import { defineConfig } from 'vite'

import vue from '@vitejs/plugin-vue'
import RubyPlugin, { projectRoot } from 'vite-plugin-ruby'

let generatedConfig = defineConfig({
  resolve: {
    alias: {
      '@': resolve(join(projectRoot, 'app/javascript')),
      '@mixins': resolve(join(projectRoot, 'app/javascript/mixins')),
      '@components': resolve(join(projectRoot, 'app/javascript/components')),
      '@mints-components': resolve(join(projectRoot, 'app/javascript/mints-components')),
      '@entrypoints': resolve(join(projectRoot, 'app/javascript/entrypoints')),
      '@helpers': resolve(join(projectRoot, 'app/javascript/helpers')),
      '@stores': resolve(join(projectRoot, 'app/javascript/stores')),
      '@views': resolve(join(projectRoot, 'app/javascript/views')),
      '@routers': resolve(join(projectRoot, 'app/javascript/routers')),
      '@icons': resolve(join(projectRoot, 'app/javascript/icons')),
    },
  },
  plugins: [
    RubyPlugin(),
    vue({
      template: {
        compilerOptions: {
          isCustomElement: (tag) => ['Report'].includes(tag),
        }
      }
    })
  ]
})

const defaultConfig = {
  cssPreprocessOptions: {
    sass: {
      includePaths: [
        'sweetalert2/dist/sweetalert2.min.css'
      ]
    }
  },
}

export default { ...defaultConfig , ...generatedConfig }