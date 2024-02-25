<!--
  Component presenting a scroll image
  Input is the index of the scroll
-->
<script setup lang="ts">
import ScrollUtils, { type Scroll, type ScrollType } from "@/services/ScrollUtils";
import { computed } from 'vue';


const props = defineProps<{
  index: number
}>()

const scroll: Scroll = ScrollUtils.getScrolls()[props.index];

// Dynamically construct the image URL; necessary to work with vite once bundled.
const imgPath = computed(() => {
  return new URL(`../assets/scroll-images/${scroll.imgTitle}`, import.meta.url).href;
});


</script>

<template>
    <img :src="imgPath" :alt="scroll.name" width="80%" />
</template>


<style scoped>

img {
  display: block;
  margin: 0 auto;
}

</style>