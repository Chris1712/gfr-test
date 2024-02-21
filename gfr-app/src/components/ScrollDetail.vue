<!--
  Component representing all the details of a scroll
  Input is the index of the scroll
-->
<script setup lang="ts">
import scrolls from "@/assets/scrolls.json";
import { computed } from 'vue';


const props = defineProps<{
  index: number
}>()

const scroll = scrolls[props.index];

// Dynamically construct the image URL; necessary to work with vite once bundled.
const imgPath = computed(() => {
  return new URL(`../assets/scroll-images/${scroll.img_title}`, import.meta.url).href;
});

</script>

<template>
  <div class="scroll-detail">
    <h1>{{ scroll.name }}</h1>
    <img :src="imgPath" :alt="scroll.name" width="125" height="125" />
    <p>{{ scroll.desc }}</p>
  </div>
</template>

<style scoped>

  .scroll-detail {
    flex-basis: 100%;
  }

</style>