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
    <img :src="imgPath" :alt="scroll.name" width="80%" />
    <p>{{ scroll.desc }}</p>
  </div>
</template>

<style scoped>

  h1, p {
    text-align: center;
  }

  img {
    display: block;
    margin: 0 auto;
  }

  .scroll-detail {
    flex-basis: 100%;
    padding: 10px;
    border: 1px solid var(--color-text);
  }

</style>