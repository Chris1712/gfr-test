<script setup lang="ts">
import ScrollDetail from "@/components/ScrollDetail.vue";
import ScrollUtils, { type Scroll, type ScrollType } from "@/services/ScrollUtils";

let no_scrolls: number = 4;
let indexes: number[] = [];

// Pick a random number from 1-4 to be the correct answer
let correctIndex: number = Math.floor(Math.random() * no_scrolls) ;

// Pick random indexes from the scrolls array, ensuring no duplicates
while (indexes.length < no_scrolls) {
  let n = Math.floor(Math.random() * ScrollUtils.getScrolls().length);
  if (!indexes.includes(n)) {
    indexes.push(n);
  }
}

</script>

<template>
  <scroll-detail v-for="i in indexes" :index="i" :key="i" />
</template>

<style scoped>

@media (min-width: 1024px) {
  header {
    display: flex;
    place-items: center;
    padding-right: calc(var(--section-gap) / 2);
  }
}
</style>
