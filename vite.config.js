import {resolve} from 'path'
import vue from '@vitejs/plugin-vue'

export default {
  plugins: [vue()],
  server: {
    host: true,
    port: 80,
    strictPort: true,
    hmr: {
      clientPort: 80,
    }
  },
  resolve: {
    alias: {
      src: resolve(__dirname, 'src')
    }
  },
}
