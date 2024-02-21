<script setup lang="ts">
import ScrollDetail from "@/components/ScrollDetail.vue";
import scrolls from "@/assets/scrolls.json";

let no_scrolls: number = 4;
let indexes: number[] = [];

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

  main {
    display: flex; /* This makes it a flex container and aligns children in a row */
    justify-content: center; /* This aligns the children at the start of the container */
    align-items: center; /* This centers the children vertically */
    overflow-x: auto; /* Adds horizontal scrolling if the items overflow */
    gap: 10px; /* Optional: adds space between the children */
    width: 100%;
  }

  header .wrapper {
    display: flex;
    place-items: flex-start;
    flex-wrap: wrap;
  }
}
</style>
