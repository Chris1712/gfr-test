<script setup lang="ts">
import ScrollDetail from "@/components/ScrollDetail.vue";
import scrolls from "@/assets/scrolls.json";

let no_scrolls: number = 4;
let indexes: number[] = [];

// Pick random indexes from the scrolls array, ensuring no duplicates
while (indexes.length < no_scrolls) {
  let n = Math.floor(Math.random() * scrolls.length);
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
