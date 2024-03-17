import './assets/main.css'

import { createApp } from 'vue'
import App from './App.vue'
import VueGtag from "vue-gtag";

const app = createApp(App);

app.mount('#app')

app.use(VueGtag, {
    config: { id: "G-EC5J9QV19Z" }
});
